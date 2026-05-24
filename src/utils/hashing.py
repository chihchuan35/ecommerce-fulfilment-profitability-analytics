from pathlib import Path
import hashlib


def calculate_file_sha256(file_path: str | Path) -> str:
    """
    Calculate SHA256 hash for a file.

    This helps identify whether two files are identical even if they are stored
    in different folders or batches.
    """
    path = Path(file_path)
    sha256_hash = hashlib.sha256()

    with path.open("rb") as file:
        for byte_block in iter(lambda: file.read(4096), b""):
            sha256_hash.update(byte_block)

    return sha256_hash.hexdigest()
