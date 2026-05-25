# SQL Scripts

This folder stores SQL scripts used in Microsoft Fabric Warehouse.

## Current Structure

| Folder          | Purpose                                |
| --------------- | -------------------------------------- |
| `data_quality/` | Raw data validation and quality checks |
| `silver/`       | Silver transformation scripts          |
| `gold/`         | Gold reporting model and KPI scripts   |

## Notes

Raw CSV files are loaded into Microsoft Fabric and are not stored in this repository.

Staging scripts will be added only if a separate staging layer is required. At the current stage, the Fabric-loaded source tables are used as the raw starting point for data quality checks and Silver transformation.
