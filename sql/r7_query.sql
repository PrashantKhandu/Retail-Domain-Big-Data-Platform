/* ==========================================================
   Object Name   : get_top_10_products_by_store
   Author        : Prashant Bhoje
   Created Date  : 2026-01-15
   Purpose       : Returns Top 10 products per store based on
                   total sale value (amt).

   Source Tables :
       - tran_dtl
       - tran_hdr

   Output Columns:
       - store_id
       - product_id
       - total_sale
       - rank

   Business Rule :
       - Total sale is SUM(td.amt) rounded to 2 decimal places
       - Products ranked per store using ROW_NUMBER()
         ordered by total_sale DESC
       - Only Top 10 products per store (rank <= 10) returned

   Change History :
       Date        Author       Description
       ----------  -----------  -----------------------------
       2026-01-15  PBhoje       Initial creation
   ========================================================== */


/* ======================= TEST CODE =========================
SELECT 
    th.store_id,
    td.product_id,
    ROUND(SUM(td.amt), 2) AS total_sale,
    ROW_NUMBER() OVER (
        PARTITION BY th.store_id 
        ORDER BY SUM(td.amt) DESC
    ) AS rank
FROM tran_dtl td
JOIN tran_hdr th
    ON th.tran_id = td.tran_id
GROUP BY 
    th.store_id, 
    td.product_id
HAVING ROW_NUMBER() OVER (
    PARTITION BY th.store_id 
    ORDER BY SUM(td.amt) DESC
) <= 10;
==============================================================*/


CREATE OR ALTER FUNCTION dbo.get_top_10_products_by_store()
RETURNS TABLE
AS
RETURN
(
    SELECT
        r7_result.store_id,
        r7_result.product_id,
        r7_result.total_sale,
        r7_result.rank
    FROM (
        SELECT 
            th.store_id, 
            td.product_id, 
            ROUND(SUM(td.amt), 2) AS total_sale, 
            ROW_NUMBER() OVER (
                PARTITION BY th.store_id 
                ORDER BY SUM(td.amt) DESC
            ) AS rank
        FROM tran_dtl td
        JOIN tran_hdr th
            ON th.tran_id = td.tran_id
        GROUP BY 
            th.store_id, 
            td.product_id
    ) AS r7_result
    WHERE r7_result.rank <= 10
);

GO

-- TEST:
-- SELECT * FROM dbo.get_top_10_products_by_store() ORDER BY store_id, rank;
