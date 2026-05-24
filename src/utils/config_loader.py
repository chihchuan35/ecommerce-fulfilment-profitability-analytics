from pathlib import Path
from typing import Any

import yaml


def load_yaml_config(config_path: str | Path) -> dict[str, Any]:
    """
    Load a YAML configuration file.

    Parameters
    ----------
    config_path:
        Path to the YAML configuration file.

    Returns
    -------
    dict
        Parsed YAML content. Returns an empty dictionary if the file is empty.
    """
    path = Path(config_path)

    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {path}")

    with path.open("r", encoding="utf-8") as file:
        return yaml.safe_load(file) or {}
