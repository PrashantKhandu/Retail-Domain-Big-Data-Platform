/* ==========================================================
   Object Name   : get_high_value_product_count_by_month
   Author        : Prashant Bhoje
   Created Date  : 2026-01-13
   Purpose       : Returns number of products per month whose total sales exceed the high-value threshold.

   Source Tables :
       - tran_dtl

   Output Columns:
       - month
       - no_of_products

   Business Rule :
       - Month is calculated using DATE_TRUNC('month', tran_dt)
       - A product is considered high-value if total_sale > 100

   Change History :
       Date        Author       Description
       ----------  -----------  -----------------------------
       2026-01-13  PBhoje       Initial creation
   ========================================================== */


/* ======================= TEST CODE =========================
SELECT
    month,
    COUNT(product_id) AS no_of_products
FROM (
        SELECT 
            td.product_id,
            DATE_TRUNC('month', td.tran_dt) AS month,
            SUM(td.amt) AS total_sale
        FROM tran_dtl td
        GROUP BY 
            td.product_id,
            DATE_TRUNC('month', td.tran_dt)
        HAVING SUM(td.amt) > 100
     ) monthly_product_sales
GROUP BY month
ORDER BY month;
==============================================================*/


CREATE OR REPLACE FUNCTION get_high_value_product_count_by_month()
RETURNS TABLE (
    month DATE,
    no_of_products BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        month::DATE,
        COUNT(product_id) AS no_of_products
    FROM (
            SELECT 
                td.product_id,
                DATE_TRUNC('month', td.tran_dt) AS month,
                SUM(td.amt) AS total_sale
            FROM tran_dtl td
            GROUP BY 
                td.product_id,
                DATE_TRUNC('month', td.tran_dt)
            HAVING SUM(td.amt) > 100
         ) high_value_products
    GROUP BY month
    ORDER BY month;
END;
$$;


-- SELECT * FROM get_high_value_product_count_by_month();
