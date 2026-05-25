# Data Quality Summary

## Purpose

Raw data quality checks were completed after loading the Olist CSV files into Microsoft Fabric.

The goal was to confirm whether the loaded data was reliable enough for Silver transformation and downstream Power BI analysis.

## Completed Checks

| Check Area             | Purpose                                                          |
| ---------------------- | ---------------------------------------------------------------- |
| Row counts             | Confirm raw tables were loaded successfully                      |
| Missing values         | Check important fulfilment, payment, review, and category fields |
| Date sequence logic    | Identify illogical fulfilment timelines                          |
| Numeric validity       | Validate price, freight, and payment values                      |
| Review score validity  | Confirm review scores are within the expected range              |
| Duplicate keys         | Check whether source tables match expected grain                 |
| Relationship integrity | Confirm tables can be joined correctly                           |
| Category translation   | Check English product category mapping                           |

## Key Findings

| Area               | Finding                                                              | Treatment                                            |
| ------------------ | -------------------------------------------------------------------- | ---------------------------------------------------- |
| Orders             | Some fulfilment dates are missing or logically inconsistent          | Preserve records and flag exceptions in Silver       |
| Order items        | 383 records have zero freight value                                  | Preserve and flag as freight exception               |
| Payments           | 11 payment-related exceptions were identified                        | Preserve and flag payment exceptions                 |
| Reviews            | Original review table had CSV parsing issues due to free-text fields | Use Fabric-safe `olist_order_reviews_metadata`       |
| Review grain       | `review_id` is not unique by itself                                  | Use order-review relationship grain                  |
| Relationships      | Main table joins returned zero missing references                    | Proceed to Silver and Gold modelling                 |
| Product categories | 610 products have missing category values                            | Preserve and handle as unknown category in reporting |

## Design Decision

The project does not remove exception records during data quality checks.

Exceptions are preserved as row-level flags so they can support operational analysis in Silver, Gold, and Power BI.
