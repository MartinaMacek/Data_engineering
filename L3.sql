
--L3 branch
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L3.L3_branch` AS 
SELECT
branch_id
, branch_name
FROM `psychic-heading-455311-r2.L2.L2_branch`;

-- L3 contract
CREATE OR REPLACE VIEW  `psychic-heading-455311-r2.L3.L3_contracts_crm` AS
SELECT
contract_id
, branch_id
, contract_valid_from
, contract_valid_to
, prolongation_date
, registration_end_reason
, contract_status
, flag_prolongation
, contract_duration
, start_year_of_contract
    --EXTRACT(YEAR FROM DATETIME(contract_valid_from)) AS start_year_of_the_contract 
--, CASE
    -- WHEN DATE_DIFF(contract_valid_to, contract_valid_from, MONTH) < 6 THEN 'less than half year'
   -- WHEN DATE_DIFF(contract_valid_to, contract_valid_from, YEAR) = 1 THEN '1 year'
  --  WHEN DATE_DIFF(contract_valid_to, contract_valid_from, YEAR) = 2 THEN '2 years'
-- WHEN DATE_DIFF(contract_valid_to, contract_valid_from, YEAR) > 2 THEN 'more than 2 years'
 --   ELSE NULL
--  END AS contract_duration
FROM `psychic-heading-455311-r2.L2.L2_contracts_crm`
--WHERE contract_valid_from IS NOT NULL
--AND contract_valid_to IS NOT NULL
--AND contract_valid_to >= contract_valid_from
    ; 

--L3 invoice
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L3.L3_invoice` AS
SELECT 
i.invoice_id
, i.contract_id
, i.paid_date
, i.amount_w_vat
, i.return_w_vat
, pp.product_id
, (i.amount_w_vat - i.return_w_vat) AS total_usd_paid
FROM `psychic-heading-455311-r2.L2.L2_invoice` i
LEFT JOIN `psychic-heading-455311-r2.L2.L2_product_purchases` pp
ON pp.contract_id = i.contract_id;

--L3 product
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L3.L3_product` AS
SELECT 
p.product_id
, pp.product_purchase_id
, pp.product_valid_from
, pp.product_valid_to
, pp.unit
, pp.flag_unlimited_product
, p.product_name
, p.product_type
FROM `psychic-heading-455311-r2.L2.L2_product_purchases` pp
LEFT JOIN `psychic-heading-455311-r2.L2.L2_product` p ON
pp.product_id = p.product_id;
