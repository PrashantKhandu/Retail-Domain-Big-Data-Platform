# 📄 Retail Analytics – Client Business Requirements Document (BRD)

## Objective

* To design and implement an analytical reporting layer over retail transactional data to provide monthly, member-wise, product-wise, store-wise, and category-wise insights that support:
* Sales trend analysis
* Customer behavior analysis
* Product performance monitoring
* Inventory and pricing optimization
* Management dashboards

## Business Benefits
| Benefit               | Impact                                   |
| --------------------- | ---------------------------------------- |
| Sales optimization    | Identify top and low performing products |
| Customer segmentation | Understand buying patterns               |
| Inventory control     | Reduce stock-out and overstock           |
| Pricing strategy      | Support price band decisions             |
| Management dashboards | Faster reporting & decision making       |

## Reporting Requirements
#### R1 – Monthly Product Sales Report

- Generate a report showing monthly total sales by product.
- Output Columns: *month, product_id, product_description, total_quantity, total_sale*

#### R2 – Monthly Product Sales by Member (Ranked)

- Generate monthly sales by member and product, ordered by descending sale value.
- Output Columns: *month, member_id, product_id, total_quantity, total_sale*

#### R3 – Average Monthly Sale by Member (Ranked)

- Generate report showing average monthly sales per member, ordered by highest sales.
- Output Columns: *member_id, avg_monthly_sale*

#### R4 – High Value Product Sales

- Generate monthly product sales where total sale > 1000.
- Output Columns: *month, product_id, total_sale*

#### R5 – High Value Product Count by Month

- For each month, show number of products whose total sale > 1000.
- Output Columns: *month, no_of_products*

#### R6 – Top 5 Products by Member (By Quantity)

- For each member, show Top 5 products ranked by total quantity purchased.
- Output Columns: *member_id, product_id, total_quantity, rank*

#### R7 – Top 10 Products by Store (By Sale Value)

- For each store, show Top 10 products ranked by total sale value.
- Output Columns: *store_id, product_id, total_sale, rank*

#### R8 – Member-Based Product Bucketing

- Bucket each member’s purchased products into 10 buckets based on total sale.
- Output Columns: *member_id, product_id, total_sale, member_bucket*

#### R9 – Global Product Bucketing

- Bucket products into 10 global buckets based on overall total sale.
- Output Columns: *product_id, total_sale, global_bucket*

#### R10 – Member vs Global Bucket Comparison

- Show member and global buckets for each product.
- Output Columns: *member_id, product_id, global_bucket, member_bucket*

#### R11 – Monthly Bucket Matrix Report

- Same as R10 but displayed across 12 month columns.
- Output: *member_id, product_id, Jan, Feb, Mar, … , Dec*

#### R12 – Product vs Category Contribution Report

- For each month, show product contribution within its category.
- Output Columns: *month, product_description, category_description, total_sale_product, total_sale_category, percentage_of_category*

#### R13 – Member Price Segment Report

- Add price_cat column in product table (Low / Medium / High).
- Generate monthly sales by member and price category.

- Output Columns: *member_id, member_name, month, price_cat, total_quantity, total_sale*

#### R14 – Rolling 3-Month Sales Report
* Generate monthly report with last 3 months rolling sales per product and member.
* Output Columns: 'member_id, product_id, month, month_sale, last_3_month_sale'

#### R15 – Sales Window Analysis Report

- Display previous 2 months and next 3 months sales window.
- Output Columns: *member_id, product_id, prev2_month_sale, prev1_month_sale, month_sale, next1_month_sale, next2_month_sale, next3_month_sale*

