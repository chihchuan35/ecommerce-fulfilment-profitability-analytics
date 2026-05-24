from pathlib import Path

from src.extract.ingest_local_csv import (
    copy_source_files_to_raw_landing,
    print_copy_results,
)
from src.extract.validate_raw_files import (
    validate_raw_files,
    print_validation_results,
)
from src.utils.config_loader import load_yaml_config
from src.utils.path_manager import (
    generate_batch_id,
    get_extract_date,
    build_raw_landing_batch_path,
    build_metadata_batch_path,
    create_directory,
)
from src.utils.metadata_logger import (
    build_ingestion_log_records,
    write_ingestion_log,
)

DATASETS_CONFIG_PATH = Path("config/datasets.yml")
PATHS_CONFIG_PATH = Path("config/paths.yml")


def get_expected_files(datasets_config: dict) -> list[str]:
    """
    Return expected files from config/datasets.yml.
    """
    expected_files = datasets_config.get("expected_files", [])

    if not expected_files:
        raise ValueError("No expected_files found in config/datasets.yml")

    return expected_files


def run_extract() -> None:
    """
    Run the local extract workflow.

    Current scope:
    1. Validate source CSV files
    2. Create versioned raw landing batch folder
    3. Copy validated source CSV files into raw landing
    4. Write ingestion metadata log
    """
    print("\nStarting Extract Pipeline")
    print("=" * 40)

    datasets_config = load_yaml_config(DATASETS_CONFIG_PATH)
    paths_config = load_yaml_config(PATHS_CONFIG_PATH)

    expected_files = get_expected_files(datasets_config)

    source_download_dir = paths_config["local"]["source_download_dir"]
    raw_landing_dir = paths_config["local"]["raw_landing_dir"]
    metadata_dir = paths_config["local"]["metadata_dir"]

    batch_id_format = paths_config["extract"].get(
        "batch_id_format",
        "%Y%m%d_%H%M%S",
    )
    overwrite_existing_raw_files = paths_config["extract"].get(
        "overwrite_existing_raw_files",
        False,
    )
    default_encoding = paths_config["extract"].get("default_encoding", "utf-8")

    extract_date = get_extract_date()
    batch_id = generate_batch_id(batch_id_format)

    raw_landing_batch_dir = build_raw_landing_batch_path(
        raw_landing_dir=raw_landing_dir,
        extract_date=extract_date,
        batch_id=batch_id,
    )

    metadata_batch_dir = build_metadata_batch_path(
        metadata_dir=metadata_dir,
        batch_id=batch_id,
    )

    print(f"Extract date: {extract_date}")
    print(f"Batch ID: {batch_id}")
    print(f"Source folder: {source_download_dir}")
    print(f"Raw landing folder: {raw_landing_batch_dir}")
    print(f"Metadata folder: {metadata_batch_dir}")

    print("\nStep 1: Validating source files")
    validation_results = validate_raw_files()
    print_validation_results(validation_results)

    print("\nStep 2: Creating raw landing batch folder")
    create_directory(raw_landing_batch_dir)

    print("\nStep 3: Copying source files into raw landing")
    copy_results = copy_source_files_to_raw_landing(
        expected_files=expected_files,
        source_download_dir=source_download_dir,
        raw_landing_batch_dir=raw_landing_batch_dir,
        overwrite_existing_raw_files=overwrite_existing_raw_files,
    )
    print_copy_results(copy_results)

    print("\nStep 4: Writing ingestion metadata log")
    ingestion_log_records = build_ingestion_log_records(
        batch_id=batch_id,
        extract_date=extract_date,
        copy_results=copy_results,
        validation_results=validation_results,
        encoding=default_encoding,
    )

    ingestion_log_path = write_ingestion_log(
        records=ingestion_log_records,
        metadata_batch_dir=metadata_batch_dir,
        file_name="ingestion_log.csv",
    )

    print(f"Ingestion log written to: {ingestion_log_path}")

    print("\nExtract pipeline completed successfully.")
    print(f"Raw batch location: {raw_landing_batch_dir}")
    print(f"Metadata batch location: {metadata_batch_dir}")


if __name__ == "__main__":
    run_extract()
