from datetime import datetime
from pathlib import Path

import pandas as pd

from src.utils.hashing import calculate_file_sha256


def get_csv_shape(file_path: str | Path, encoding: str = "utf-8") -> tuple[int, int]:
    """
    Return row count and column count for a CSV file.

    Row count excludes the header row.
    """
    path = Path(file_path)

    df_header = pd.read_csv(path, nrows=0, encoding=encoding)
    column_count = len(df_header.columns)

    row_count = 0
    for chunk in pd.read_csv(path, chunksize=100_000, encoding=encoding):
        row_count += len(chunk)

    return row_count, column_count


def build_ingestion_log_records(
    batch_id: str,
    extract_date: str,
    copy_results: list[dict],
    validation_results: list[dict],
    encoding: str = "utf-8",
) -> list[dict]:
    """
    Build ingestion log records using copy results and validation results.
    """
    validation_lookup = {result["file_name"]: result for result in validation_results}

    records = []

    for copy_result in copy_results:
        file_name = copy_result["file_name"]
        target_file = Path(copy_result["target_file"])
        validation_result = validation_lookup.get(file_name, {})

        if target_file.exists():
            row_count, column_count = get_csv_shape(target_file, encoding=encoding)
            file_size_bytes = target_file.stat().st_size
            file_hash_sha256 = calculate_file_sha256(target_file)
            load_status = "SUCCESS"
            error_message = ""
        else:
            row_count = None
            column_count = None
            file_size_bytes = None
            file_hash_sha256 = None
            load_status = "FAILED"
            error_message = copy_result["copy_status"]

        record = {
            "batch_id": batch_id,
            "extract_date": extract_date,
            "file_name": file_name,
            "source_file": copy_result["source_file"],
            "landing_file": copy_result["target_file"],
            "file_size_bytes": file_size_bytes,
            "row_count": row_count,
            "column_count": column_count,
            "file_hash_sha256": file_hash_sha256,
            "file_exists_check": validation_result.get("file_exists_check"),
            "empty_file_check": validation_result.get("empty_file_check"),
            "required_columns_check": validation_result.get("required_columns_check"),
            "validation_status": validation_result.get("status"),
            "copy_status": copy_result["copy_status"],
            "load_status": load_status,
            "error_message": error_message,
            "logged_at": datetime.now().isoformat(timespec="seconds"),
        }

        records.append(record)

    return records


def write_ingestion_log(
    records: list[dict],
    metadata_batch_dir: str | Path,
    file_name: str = "ingestion_log.csv",
) -> Path:
    """
    Write ingestion log records to a CSV file.
    """
    output_dir = Path(metadata_batch_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    output_path = output_dir / file_name

    df = pd.DataFrame(records)
    df.to_csv(output_path, index=False, encoding="utf-8")

    return output_path
