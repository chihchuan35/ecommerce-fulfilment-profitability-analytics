from pathlib import Path

import pandas as pd

from src.utils.config_loader import load_yaml_config

DATASETS_CONFIG_PATH = Path("config/datasets.yml")
REQUIRED_COLUMNS_CONFIG_PATH = Path("config/required_columns.yml")
PATHS_CONFIG_PATH = Path("config/paths.yml")


def get_expected_files(datasets_config: dict) -> list[str]:
    """
    Return the list of expected source CSV files from datasets.yml.
    """
    expected_files = datasets_config.get("expected_files", [])

    if not expected_files:
        raise ValueError("No expected_files found in config/datasets.yml")

    return expected_files


def validate_file_exists(file_path: Path) -> tuple[bool, str]:
    """
    Check whether the file exists.
    """
    if file_path.exists():
        return True, "PASS"

    return False, "FAIL - file not found"


def validate_file_not_empty(file_path: Path) -> tuple[bool, str]:
    """
    Check whether the file is not empty.
    """
    if file_path.stat().st_size > 0:
        return True, "PASS"

    return False, "FAIL - empty file"


def get_csv_columns(file_path: Path, encoding: str) -> list[str]:
    """
    Read only the CSV header to capture column names.
    """
    df_header = pd.read_csv(file_path, nrows=0, encoding=encoding)
    return list(df_header.columns)


def validate_required_columns(
    actual_columns: list[str],
    required_columns: list[str],
) -> tuple[bool, str]:
    """
    Check whether all required columns exist in the source file.
    """
    missing_columns = [
        column for column in required_columns if column not in actual_columns
    ]

    if not missing_columns:
        return True, "PASS"

    return False, f"FAIL - missing columns: {missing_columns}"


def validate_raw_files() -> list[dict]:
    """
    Validate expected raw source files.

    Current validation scope:
    - file exists
    - file is not empty
    - required columns exist
    """
    datasets_config = load_yaml_config(DATASETS_CONFIG_PATH)
    required_columns_config = load_yaml_config(REQUIRED_COLUMNS_CONFIG_PATH)
    paths_config = load_yaml_config(PATHS_CONFIG_PATH)

    source_download_dir = Path(paths_config["local"]["source_download_dir"])
    default_encoding = paths_config["extract"].get("default_encoding", "utf-8")

    expected_files = get_expected_files(datasets_config)

    validation_results = []

    for file_name in expected_files:
        file_path = source_download_dir / file_name

        result = {
            "file_name": file_name,
            "file_path": str(file_path),
            "file_exists_check": None,
            "empty_file_check": None,
            "required_columns_check": None,
            "status": "PASS",
        }

        file_exists, file_exists_message = validate_file_exists(file_path)
        result["file_exists_check"] = file_exists_message

        if not file_exists:
            result["status"] = "FAIL"
            validation_results.append(result)
            continue

        not_empty, not_empty_message = validate_file_not_empty(file_path)
        result["empty_file_check"] = not_empty_message

        if not not_empty:
            result["status"] = "FAIL"
            validation_results.append(result)
            continue

        try:
            actual_columns = get_csv_columns(file_path, default_encoding)
            required_columns = required_columns_config.get(file_name, [])

            required_columns_passed, required_columns_message = (
                validate_required_columns(
                    actual_columns=actual_columns,
                    required_columns=required_columns,
                )
            )

            result["required_columns_check"] = required_columns_message

            if not required_columns_passed:
                result["status"] = "FAIL"

        except Exception as error:
            result["required_columns_check"] = (
                f"FAIL - unable to read CSV header: {error}"
            )
            result["status"] = "FAIL"

        validation_results.append(result)

    return validation_results


def print_validation_results(validation_results: list[dict]) -> None:
    """
    Print validation results in a readable format.
    """
    print("\nRaw Source File Validation Results")
    print("=" * 40)

    for result in validation_results:
        print(f"\nFile: {result['file_name']}")
        print(f"Path: {result['file_path']}")
        print(f"File exists: {result['file_exists_check']}")
        print(f"Not empty: {result['empty_file_check']}")
        print(f"Required columns: {result['required_columns_check']}")
        print(f"Status: {result['status']}")

    failed_files = [
        result for result in validation_results if result["status"] == "FAIL"
    ]

    print("\nSummary")
    print("=" * 40)
    print(f"Total files checked: {len(validation_results)}")
    print(f"Passed: {len(validation_results) - len(failed_files)}")
    print(f"Failed: {len(failed_files)}")

    if failed_files:
        raise RuntimeError("Raw file validation failed. Check failed files above.")


if __name__ == "__main__":
    results = validate_raw_files()
    print_validation_results(results)
