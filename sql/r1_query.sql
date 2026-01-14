/* ==========================================================
   Object Name   : get_monthly_product_sales
   Author        : Prashant Bhoje
   Created Date  : 2026-01-13
   Purpose       : Generates monthly total sales and quantity by product for retail analytics reporting.
   
   Source Tables :
       - product
       - tran_dtl

   Output Columns:
       - month
       - product_id
       - product_description
       - total_quantity
       - total_sale

   Business Rule :
       - Month is calculated using DATE_TRUNC('month', tran_dt)
       - Only completed transactions are considered

   Change History :
       Date        Author       Description
       ----------  -----------  -----------------------------
       2026-01-13  PBhoje       Initial creation
   ========================================================== */

/* ======================= TEST CODE =========================
SELECT 
    p.product_id,
    EXTRACT(MONTH FROM td.tran_dt) AS month,
    p.description AS product_description,
    COUNT(td.qty) AS total_quantity,
    SUM(td.amt) AS total_sale
FROM product p
JOIN tran_dtl td
    ON p.product_id = td.product_id
GROUP BY 
    p.product_id,
    EXTRACT(MONTH FROM td.tran_dt),
    p.description
ORDER BY 
    p.product_id,
    month,
    p.description;
 ==============================================================*/

CREATE OR REPLACE FUNCTION get_monthly_product_sales()
RETURNS TABLE (
    month DATE,
    product_id INT,
    product_description TEXT,
    total_quantity BIGINT,
    total_sale NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        DATE_TRUNC('month', td.tran_dt)::DATE AS month,
        p.product_id,
        p.description AS product_description,
        SUM(td.qty) AS total_quantity,
        SUM(td.amt) AS total_sale
    FROM product p
    JOIN tran_dtl td
        ON p.product_id = td.product_id
    GROUP BY 
        DATE_TRUNC('month', td.tran_dt),
        p.product_id,
        p.description
    ORDER BY 
        month,
        p.product_id;
END;
$$;

-- SELECT * FROM get_monthly_product_sales();
