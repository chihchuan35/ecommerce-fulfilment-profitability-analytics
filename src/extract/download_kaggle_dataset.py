from pathlib import Path
import shutil

import kagglehub

DATASET_HANDLE = "olistbr/brazilian-ecommerce"
TARGET_DIR = Path("data/raw/source_download")


def main() -> None:
    """
    Download the Olist dataset using KaggleHub and copy CSV files into the
    local source_download folder used by the extract pipeline.
    """
    print(f"Downloading dataset from KaggleHub: {DATASET_HANDLE}")

    downloaded_path = Path(kagglehub.dataset_download(DATASET_HANDLE))
    TARGET_DIR.mkdir(parents=True, exist_ok=True)

    csv_files = list(downloaded_path.glob("*.csv"))

    if not csv_files:
        raise FileNotFoundError(
            f"No CSV files found in KaggleHub download path: {downloaded_path}"
        )

    for csv_file in csv_files:
        target_file = TARGET_DIR / csv_file.name
        shutil.copy2(csv_file, target_file)
        print(f"Copied: {csv_file.name} -> {target_file}")

    print(f"Completed. Source files are available in: {TARGET_DIR}")


if __name__ == "__main__":
    main()
