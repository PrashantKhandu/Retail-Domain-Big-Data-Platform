/* ==========================================================
   Object Name   : get_high_value_product_sales
   Author        : Prashant Bhoje
   Created Date  : 2026-01-13
   Purpose       : Identifies monthly product sales where
                   total sale value exceeds the defined threshold.

   Source Tables :
       - product
       - tran_dtl

   Output Columns:
       - month
       - product_id
       - total_sale

   Business Rule :
       - Month is calculated using DATE_TRUNC('month', tran_dt)
       - High value threshold is defined as total_sale > 100

   Change History :
       Date        Author       Description
       ----------  -----------  -----------------------------
       2026-01-13  PBhoje       Initial creation
   ========================================================== */


/* ======================= TEST CODE =========================
SELECT 
    p.product_id,
    DATE_TRUNC('month', td.tran_dt) AS month,
    SUM(td.amt) AS total_sale
FROM product p
JOIN tran_dtl td
    ON p.product_id = td.product_id
GROUP BY 
    p.product_id,
    DATE_TRUNC('month', td.tran_dt)
HAVING SUM(td.amt) > 100;
==============================================================*/


CREATE OR REPLACE FUNCTION get_high_value_product_sales()
RETURNS TABLE (
    month DATE,
    product_id INT,
    total_sale NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        DATE_TRUNC('month', td.tran_dt)::DATE AS month,
        p.product_id,
        SUM(td.amt) AS total_sale
    FROM tran_dtl td
    JOIN product p
        ON p.product_id = td.product_id
    GROUP BY 
        DATE_TRUNC('month', td.tran_dt),
        p.product_id
    HAVING SUM(td.amt) > 100
    ORDER BY month, product_id;
END;
$$;


-- SELECT * FROM get_high_value_product_sales();
