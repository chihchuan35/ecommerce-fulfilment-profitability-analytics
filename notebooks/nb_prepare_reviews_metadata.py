# Fabric Notebook: Prepare review metadata table
#
# Purpose:
# The original Olist order reviews CSV contains free-text comment fields.
# These fields may include commas, quotes, or line breaks, which caused parsing
# issues when the file was loaded through the Fabric UI.
#
# This notebook reloads the original CSV from Lakehouse Files using multiline
# CSV parsing and creates a metadata-only review table for customer satisfaction
# analysis.

review_file_path = "Files/olist_raw/olist_order_reviews_dataset.csv"

reviews_raw = (
    spark.read.format("csv")
    .option("header", "true")
    .option("multiLine", "true")
    .option("quote", '"')
    .option("escape", '"')
    .option("mode", "PERMISSIVE")
    .load(review_file_path)
)

reviews_metadata = reviews_raw.select(
    "review_id",
    "order_id",
    "review_score",
    "review_creation_date",
    "review_answer_timestamp",
)

reviews_metadata.write.format("delta").mode("overwrite").saveAsTable(
    "olist_order_reviews_metadata"
)

display(reviews_metadata.limit(20))
