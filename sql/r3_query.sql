/* ==========================================================
   Object Name   : get_avg_monthly_sale_by_member
   Author        : Prashant Bhoje
   Created Date  : 2026-01-13
   Purpose       : Calculates average monthly sales per member
                   and ranks members by highest average sales.

   Source Tables :
       - members
       - tran_hdr
       - tran_dtl

   Output Columns:
       - member_id
       - avg_monthly_sale

   Business Rule :
       - Monthly sales are calculated using DATE_TRUNC('month', tran_dt)
       - Average is computed over all available months per member

   Change History :
       Date        Author       Description
       ----------  -----------  -----------------------------
       2026-01-13  PBhoje       Initial creation
   ========================================================== */


/* ======================= TEST CODE =========================
WITH r3_cte AS (
    SELECT 
        m.member_id,
        DATE_TRUNC('month', td.tran_dt) AS month,
        SUM(td.amt) AS total_sale
    FROM members m
    JOIN tran_hdr th
        ON m.member_id = th.member_id
    JOIN tran_dtl td
        ON td.tran_id = th.tran_id
    GROUP BY 
        m.member_id,
        DATE_TRUNC('month', td.tran_dt)
)
SELECT 
    member_id,
    AVG(total_sale) AS avg_monthly_sale
FROM r3_cte
GROUP BY member_id
ORDER BY avg_monthly_sale DESC;
==============================================================*/


CREATE OR REPLACE FUNCTION get_avg_monthly_sale_by_member()
RETURNS TABLE (
    member_id INT,
    avg_monthly_sale NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        member_id,
        AVG(total_sale) AS avg_monthly_sale
    FROM (
            SELECT 
                m.member_id,
                DATE_TRUNC('month', td.tran_dt) AS month,
                SUM(td.amt) AS total_sale
            FROM tran_hdr th
            JOIN tran_dtl td
                ON td.tran_id = th.tran_id
            JOIN members m
                ON m.member_id = th.member_id
            GROUP BY 
                m.member_id,
                DATE_TRUNC('month', td.tran_dt)
         ) monthly_sales
    GROUP BY member_id
    ORDER BY avg_monthly_sale DESC;
END;
$$;


-- SELECT * FROM get_avg_monthly_sale_by_member();
