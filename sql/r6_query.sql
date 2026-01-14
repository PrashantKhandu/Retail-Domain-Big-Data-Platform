/* ==========================================================
   Object Name   : dbo.get_top_5_products_by_member
   Author        : Prashant Bhoje
   Created Date  : 2026-01-15
   Purpose       : Returns Top 5 products per member based on total quantity purchased.

   Source Tables :
       - product
       - tran_dtl
       - tran_hdr

   Output Columns:
       - member_id
       - product_id
       - total_quantity
       - rank

   Business Rule :
       - Total quantity is SUM(td.qty) grouped by member and product
       - Products are ranked per member using ROW_NUMBER()
         ordered by total_quantity in descending order
       - Only Top 5 products per member (rank <= 5) are returned
   ========================================================== */

CREATE OR ALTER FUNCTION dbo.get_top_5_products_by_member()
RETURNS TABLE
AS
RETURN
(
    SELECT
        ranked.member_id,
        ranked.product_id,
        ranked.total_quantity,
        ranked.rank
    FROM (
        SELECT
            th.member_id,
            p.product_id,
            SUM(td.qty) AS total_quantity,
            ROW_NUMBER() OVER (
                PARTITION BY th.member_id
                ORDER BY SUM(td.qty) DESC
            ) AS rank
        FROM product p
        JOIN tran_dtl td
            ON p.product_id = td.product_id
        JOIN tran_hdr th
            ON td.tran_id = th.tran_id
        GROUP BY
            th.member_id,
            p.product_id
    ) AS ranked
    WHERE ranked.rank <= 5
);
GO

-- TEST:
-- SELECT * FROM dbo.get_top_5_products_by_member();
