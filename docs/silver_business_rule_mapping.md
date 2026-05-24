# Silver Business Rule Mapping

## Purpose

This document maps the core business problem of the project to the Silver layer business rules required for downstream analysis.

The goal is to ensure the transformation layer is not designed only from a technical perspective. Each Silver-level rule should support a clear analytical need related to fulfilment reliability, customer satisfaction, seller performance, regional delivery patterns, and freight-related margin pressure.

---

## Business Problem

An e-commerce marketplace is experiencing delivery delays, declining customer satisfaction, and freight-related margin pressure.

The business needs to identify which product categories, sellers, regions, and fulfilment patterns are driving operational inefficiency and profitability leakage, then provide data-driven recommendations to improve delivery reliability and margin performance.

---

## Business Rule Mapping Overview

| Business Area           | Analytical Need                                                              | Silver Layer Requirement                                                              | Future Gold Output                                                   |
| ----------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Delivery reliability    | Identify late deliveries                                                     | Standardise order delivery timestamps and create late delivery flags                  | Late delivery rate, average delay days                               |
| Fulfilment process      | Identify fulfilment timeline issues                                          | Validate purchase, approval, carrier, customer delivery, and estimated delivery dates | Fulfilment exception count                                           |
| Customer satisfaction   | Link review scores to delivery outcomes                                      | Preserve review score and connect reviews to orders                                   | Review score by delivery status, seller, region, and category        |
| Freight pressure        | Identify categories and sellers with high freight cost burden                | Preserve item price and freight value at order item level                             | Freight-to-item-price ratio, freight pressure by category and seller |
| Seller performance      | Compare fulfilment reliability across sellers                                | Preserve seller ID and seller location, connect sellers to order items and orders     | Seller delivery performance scorecard                                |
| Regional performance    | Compare customer delivery outcomes by region                                 | Preserve customer city and state from customer records                                | Late delivery rate by customer state and city                        |
| Product category impact | Identify categories linked to delays, freight pressure, or low review scores | Preserve product category and English category translation                            | Category-level fulfilment and profitability analysis                 |

---

## 1. Delivery Reliability Rules

### Business Question

Which orders were delivered late, and which sellers, regions, or categories are associated with higher late delivery rates?

### Required Silver Tables

| Table                                 | Required Fields                                                                              |
| ------------------------------------- | -------------------------------------------------------------------------------------------- |
| `silver_orders`                       | `order_id`, `order_status`, `order_delivered_customer_date`, `order_estimated_delivery_date` |
| `silver_order_items`                  | `order_id`, `product_id`, `seller_id`                                                        |
| `silver_customers`                    | `customer_id`, `customer_city`, `customer_state`                                             |
| `silver_products`                     | `product_id`, `product_category_name`                                                        |
| `silver_product_category_translation` | `product_category_name`, `product_category_name_english`                                     |

### Silver Business Rules

| Rule                        | Description                                                                                      |
| --------------------------- | ------------------------------------------------------------------------------------------------ |
| `is_delivered`              | Flags orders where `order_status = 'delivered'`                                                  |
| `is_late_delivery`          | Flags delivered orders where actual customer delivery date is later than estimated delivery date |
| `has_missing_delivery_date` | Flags delivered orders where customer delivery date is missing                                   |
| Date type standardisation   | Converts delivery-related timestamp fields into proper datetime types                            |

### Future Gold Metrics

| Metric                         | Description                                                                           |
| ------------------------------ | ------------------------------------------------------------------------------------- |
| Late delivery rate             | Percentage of delivered orders that were delivered late                               |
| Average delay days             | Average number of days between actual and estimated delivery date for late deliveries |
| Late orders by category        | Count and rate of late deliveries by product category                                 |
| Late orders by seller          | Count and rate of late deliveries by seller                                           |
| Late orders by customer region | Count and rate of late deliveries by customer city or state                           |

---

## 2. Fulfilment Timeline Rules

### Business Question

Are there operational exceptions in the fulfilment timeline that may indicate process or data quality issues?

### Required Silver Tables

| Table           | Required Fields                                                                                                                                               |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `silver_orders` | `order_id`, `order_purchase_timestamp`, `order_approved_at`, `order_delivered_carrier_date`, `order_delivered_customer_date`, `order_estimated_delivery_date` |

### Silver Business Rules

| Rule                            | Description                                                         |
| ------------------------------- | ------------------------------------------------------------------- |
| `has_invalid_delivery_sequence` | Flags records where fulfilment dates appear in an illogical order   |
| `has_missing_approval_date`     | Flags orders missing approval timestamp where relevant              |
| `has_missing_carrier_date`      | Flags delivered orders missing carrier handover timestamp           |
| Timestamp standardisation       | Converts fulfilment timestamp fields into consistent datetime types |

### Future Gold Metrics

| Metric                             | Description                                                                    |
| ---------------------------------- | ------------------------------------------------------------------------------ |
| Fulfilment exception count         | Number of orders with missing or invalid fulfilment timeline data              |
| Fulfilment exception rate          | Percentage of orders affected by fulfilment data quality or process exceptions |
| Average approval lead time         | Time between purchase and approval                                             |
| Average carrier handover lead time | Time between approval and carrier handover                                     |
| Average delivery lead time         | Time between purchase and customer delivery                                    |

---

## 3. Customer Satisfaction Rules

### Business Question

Are delayed or operationally problematic orders associated with lower customer review scores?

### Required Silver Tables

| Table                  | Required Fields                                                                            |
| ---------------------- | ------------------------------------------------------------------------------------------ |
| `silver_order_reviews` | `review_id`, `order_id`, `review_score`, `review_creation_date`, `review_answer_timestamp` |
| `silver_orders`        | `order_id`, `order_status`, `is_late_delivery`                                             |
| `silver_order_items`   | `order_id`, `product_id`, `seller_id`                                                      |

### Silver Business Rules

| Rule                        | Description                                                              |
| --------------------------- | ------------------------------------------------------------------------ |
| Review score validation     | Checks that review scores are within the expected score range            |
| Review date standardisation | Converts review date fields into proper datetime types                   |
| Review-to-order retention   | Preserves `order_id` so review data can be linked to fulfilment outcomes |

### Future Gold Metrics

| Metric                          | Description                                           |
| ------------------------------- | ----------------------------------------------------- |
| Average review score            | Average customer review score                         |
| Review score by delivery status | Average review score for late vs on-time orders       |
| Low review order count          | Count of orders with low customer satisfaction scores |
| Seller review performance       | Average review score by seller                        |
| Category review performance     | Average review score by product category              |

---

## 4. Freight Pressure Rules

### Business Question

Which product categories or sellers are associated with high freight cost relative to item revenue?

### Required Silver Tables

| Table                                 | Required Fields                                                                  |
| ------------------------------------- | -------------------------------------------------------------------------------- |
| `silver_order_items`                  | `order_id`, `order_item_id`, `product_id`, `seller_id`, `price`, `freight_value` |
| `silver_products`                     | `product_id`, `product_category_name`                                            |
| `silver_product_category_translation` | `product_category_name`, `product_category_name_english`                         |
| `silver_sellers`                      | `seller_id`, `seller_city`, `seller_state`                                       |

### Silver Business Rules

| Rule                            | Description                                                         |
| ------------------------------- | ------------------------------------------------------------------- |
| Price numeric standardisation   | Converts `price` into a numeric type                                |
| Freight numeric standardisation | Converts `freight_value` into a numeric type                        |
| Zero or negative value check    | Flags unexpected zero or negative values for price and freight      |
| Item grain validation           | Confirms item-level uniqueness using `order_id` and `order_item_id` |

### Future Gold Metrics

| Metric                       | Description                                             |
| ---------------------------- | ------------------------------------------------------- |
| Freight-to-price ratio       | Freight value divided by item price                     |
| Average freight value        | Average freight cost per item, seller, or category      |
| High freight pressure items  | Items where freight cost is high relative to item price |
| Freight pressure by category | Category-level freight burden                           |
| Freight pressure by seller   | Seller-level freight burden                             |

---

## 5. Seller Performance Rules

### Business Question

Which sellers are linked to higher delivery delays, freight pressure, or lower customer satisfaction?

### Required Silver Tables

| Table                  | Required Fields                                                 |
| ---------------------- | --------------------------------------------------------------- |
| `silver_sellers`       | `seller_id`, `seller_city`, `seller_state`                      |
| `silver_order_items`   | `order_id`, `seller_id`, `product_id`, `price`, `freight_value` |
| `silver_orders`        | `order_id`, `is_late_delivery`                                  |
| `silver_order_reviews` | `order_id`, `review_score`                                      |

### Silver Business Rules

| Rule                             | Description                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------- |
| Seller key validation            | Checks that `seller_id` is unique in the seller table                         |
| Seller location standardisation  | Standardises seller city and state fields                                     |
| Seller relationship preservation | Keeps seller-to-order item relationships for downstream seller-level analysis |

### Future Gold Metrics

| Metric                       | Description                                                                   |
| ---------------------------- | ----------------------------------------------------------------------------- |
| Seller late delivery rate    | Percentage of delivered seller orders that were late                          |
| Seller average review score  | Average customer review score by seller                                       |
| Seller freight pressure      | Average freight-to-price ratio by seller                                      |
| Seller operational risk flag | Combined indicator based on late delivery, freight pressure, and review score |

---

## 6. Regional Performance Rules

### Business Question

Which customer regions are more affected by delivery delays or lower satisfaction?

### Required Silver Tables

| Table                  | Required Fields                                  |
| ---------------------- | ------------------------------------------------ |
| `silver_customers`     | `customer_id`, `customer_city`, `customer_state` |
| `silver_orders`        | `order_id`, `customer_id`, `is_late_delivery`    |
| `silver_order_reviews` | `order_id`, `review_score`                       |

### Silver Business Rules

| Rule                              | Description                                                       |
| --------------------------------- | ----------------------------------------------------------------- |
| Customer location standardisation | Standardises customer city and state fields                       |
| Customer key preservation         | Keeps `customer_id` for order-level joins                         |
| Regional reporting preparation    | Makes city and state available for downstream fulfilment analysis |

### Future Gold Metrics

| Metric                        | Description                                                    |
| ----------------------------- | -------------------------------------------------------------- |
| Late delivery rate by state   | Percentage of late delivered orders by customer state          |
| Average review score by state | Average customer satisfaction by customer state                |
| Order volume by state         | Number of orders by customer state                             |
| Regional fulfilment risk      | Combined view of order volume, late delivery, and review score |

---

## Design Boundary

The Silver layer should prepare clean, traceable, and reusable data. It should not contain final dashboard-specific aggregations.

Final metric calculation, business segmentation, ranking logic, and recommendation outputs will be handled in the Gold layer and Power BI reporting layer.
