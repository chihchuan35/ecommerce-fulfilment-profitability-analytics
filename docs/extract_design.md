# Extract Layer Design

## Purpose

The extract layer is designed to provide a repeatable and traceable raw data ingestion process for the E-commerce Fulfilment & Profitability Analytics project.

The goal of this stage is not to clean, transform, or model the data. Instead, the extract layer focuses on preserving the original source files, validating that the expected raw files are available, and recording metadata that supports downstream data quality and lineage.

## Source Dataset

Primary source:

- Olist Brazilian E-Commerce Public Dataset
- Source platform: Kaggle
- Dataset handle: `olistbr/brazilian-ecommerce`

The dataset is accessed using `kagglehub` and copied into the local raw source folder used by this project.

Raw dataset files are not uploaded to this repository.

## Extract Scope

The extract stage currently includes:

1. Downloading the Olist dataset using KaggleHub
2. Copying source CSV files into the local source download folder
3. Validating expected raw files
4. Creating a versioned raw landing folder
5. Copying validated source files into the raw landing folder
6. Writing an ingestion metadata log

The extract stage does not perform business transformation, joins, KPI calculation, dimensional modelling, or Power BI reporting.

## Source Download Folder

Downloaded source files are stored locally in:

```text
data/raw/source_download/
```
