/* ==========================================================
   Object Name   : get_monthly_member_product_sales
   Author        : Prashant Bhoje
   Created Date  : 2026-01-13
   Purpose       : Generates monthly sales by member and product, ordered by descending sale value for analytics and customer behavior reporting.

   Source Tables :
       - product
       - tran_dtl
       - tran_hdr
       - members

   Output Columns:
       - month
       - member_id
       - product_id
       - product_description
       - total_quantity
       - total_sale

   Business Rule :
       - Month is calculated using DATE_TRUNC('month', tran_dt)
       - Total sale is computed as SUM(amt)
       - Quantity is computed as SUM(qty)

   Change History :
       Date        Author       Description
       ----------  -----------  -----------------------------
       2026-01-13  PBhoje       Initial creation
   ========================================================== */


/* ======================= TEST CODE =========================
SELECT
    DATE_TRUNC('month', td.tran_dt) AS month,
    m.member_id,
    p.product_id,
    p.description AS product_description,
    SUM(td.qty) AS total_quantity,
    SUM(td.amt) AS total_sale
FROM product p
JOIN tran_dtl td
    ON p.product_id = td.product_id
JOIN tran_hdr th
    ON td.tran_id = th.tran_id
JOIN members m
    ON m.member_id = th.member_id
GROUP BY
    DATE_TRUNC('month', td.tran_dt),
    m.member_id,
    p.product_id,
    p.description
ORDER BY
    month,
    m.member_id,
    total_sale DESC;
==============================================================*/

DROP FUNCTION IF EXISTS get_monthly_member_product_sales;
CREATE OR REPLACE FUNCTION get_monthly_member_product_sales()
RETURNS SETOF RECORD
LANGUAGE sql
AS $$
    SELECT 
        DATE_TRUNC('month', td.tran_dt)::DATE AS month,
        m.member_id,
        p.product_id,
        p.description AS product_description,
        SUM(td.qty)::BIGINT AS total_quantity,
        ROUND(SUM(td.amt)::NUMERIC, 2) AS total_sale
    FROM tran_dtl td
    JOIN tran_hdr th
        ON td.tran_id = th.tran_id
    JOIN members m
        ON m.member_id = th.member_id
    JOIN product p
        ON p.product_id = td.product_id
    GROUP BY 
        DATE_TRUNC('month', td.tran_dt),
        m.member_id,
        p.product_id,
        p.description
    ORDER BY 
        month,
        m.member_id,
        total_sale DESC;
$$;


SELECT *
FROM get_monthly_member_product_sales()
AS t(
    month DATE,
    member_id INT,
    product_id INT,
    product_description TEXT,
    total_quantity BIGINT,
    total_sale NUMERIC
);
