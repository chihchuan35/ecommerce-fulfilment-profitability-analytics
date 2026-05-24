from pathlib import Path
import shutil


def copy_source_files_to_raw_landing(
    expected_files: list[str],
    source_download_dir: str | Path,
    raw_landing_batch_dir: str | Path,
    overwrite_existing_raw_files: bool = False,
) -> list[dict]:
    """
    Copy expected source CSV files into the versioned raw landing batch folder.

    This function does not transform the files. It only preserves the raw files
    in a structured landing zone.
    """
    source_dir = Path(source_download_dir)
    target_dir = Path(raw_landing_batch_dir)

    copy_results = []

    for file_name in expected_files:
        source_file = source_dir / file_name
        target_file = target_dir / file_name

        result = {
            "file_name": file_name,
            "source_file": str(source_file),
            "target_file": str(target_file),
            "copy_status": "PENDING",
        }

        if not source_file.exists():
            result["copy_status"] = "FAILED - source file not found"
            copy_results.append(result)
            continue

        if target_file.exists() and not overwrite_existing_raw_files:
            result["copy_status"] = "SKIPPED - target file already exists"
            copy_results.append(result)
            continue

        shutil.copy2(source_file, target_file)
        result["copy_status"] = "COPIED"
        copy_results.append(result)

    return copy_results


def print_copy_results(copy_results: list[dict]) -> None:
    """
    Print file copy results in a readable format.
    """
    print("\nRaw Landing Copy Results")
    print("=" * 40)

    for result in copy_results:
        print(f"\nFile: {result['file_name']}")
        print(f"Source: {result['source_file']}")
        print(f"Target: {result['target_file']}")
        print(f"Status: {result['copy_status']}")

    failed_files = [
        result for result in copy_results if result["copy_status"].startswith("FAILED")
    ]

    print("\nSummary")
    print("=" * 40)
    print(f"Total files processed: {len(copy_results)}")
    print(
        f"Copied: {sum(result['copy_status'] == 'COPIED' for result in copy_results)}"
    )
    print(
        f"Skipped: {sum(result['copy_status'].startswith('SKIPPED') for result in copy_results)}"
    )
    print(f"Failed: {len(failed_files)}")

    if failed_files:
        raise RuntimeError("One or more files failed to copy into raw landing.")
