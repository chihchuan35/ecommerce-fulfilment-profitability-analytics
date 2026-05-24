from datetime import datetime
from pathlib import Path


def generate_batch_id(batch_id_format: str = "%Y%m%d_%H%M%S") -> str:
    """
    Generate a batch ID based on the current timestamp.
    """
    return datetime.now().strftime(batch_id_format)


def get_extract_date() -> str:
    """
    Return the current extract date in YYYY-MM-DD format.
    """
    return datetime.now().strftime("%Y-%m-%d")


def build_raw_landing_batch_path(
    raw_landing_dir: str | Path,
    extract_date: str,
    batch_id: str,
) -> Path:
    """
    Build the raw landing batch path.

    Example:
    data/raw/olist_brazilian_ecommerce/extract_date=2026-05-24/batch_id=20260524_143000
    """
    return (
        Path(raw_landing_dir) / f"extract_date={extract_date}" / f"batch_id={batch_id}"
    )


def create_directory(path: str | Path) -> Path:
    """
    Create a directory if it does not already exist.
    """
    directory = Path(path)
    directory.mkdir(parents=True, exist_ok=True)
    return directory


def build_metadata_batch_path(
    metadata_dir: str | Path,
    batch_id: str,
) -> Path:
    """
    Build the metadata batch path.

    Example:
    data/metadata/olist_brazilian_ecommerce/batch_id=20260524_143000
    """
    return Path(metadata_dir) / f"batch_id={batch_id}"
