
--L2 branch
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L2.L2_branch` AS
SELECT  
branch_id
, branch_name
FROM `psychic-heading-455311-r2.L1.L1_branch` 
WHERE branch_name != "unknown";

--L2 contract
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L2.L2_contracts_crm` AS
SELECT  
contract_id
, branch_id
, contract_valid_from
, contract_valid_to
, registred_date
, signed_date
, activation_process_date
, prolongation_date
, registration_end_reason
, flag_prolongation
, flag_send_email
, contract_status
FROM `psychic-heading-455311-r2.L1.L1_contracts_crm` 
WHERE registred_date IS NOT NULL;

--L2 invoice
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L2.L2_invoice` AS
SELECT  
i.invoice_id
, i.invoice_previous_id
, i.contract_id
, i.invoice_status_id
, i.issue_date
, i.due_date
, i.paid_date
, i.start_date
, i.end_date
, i.amount_w_vat
, i.return_w_vat
, CASE
    WHEN i.amount_w_vat <= 0 THEN 0
    WHEN i.amount_w_vat > 0 THEN i.amount_w_vat/1.2
END AS amount_wo_vat
, i.insert_date 
, i.update_date
, ROW_NUMBER() OVER(PARTITION BY i.contract_id ORDER BY i.issue_date ASC) AS invoice_order
FROM `psychic-heading-455311-r2.L1.L1_invoice` i
INNER JOIN `psychic-heading-455311-r2.L1.L1_contracts_crm` c
ON i.contract_id = c.contract_id
WHERE i.invoice_type = "invoice"
AND flag_invoice_issued;

--L2 product
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L2.L2_product` AS
SELECT
product_id
, product_name
, product_type
, product_category
FROM `psychic-heading-455311-r2.L1.L1_product` 
WHERE product_category IN("product", "rent");

--L2 product purchases
CREATE OR REPLACE VIEW `psychic-heading-455311-r2.L2.L2_product_purchases` AS
SELECT  
product_purchase_id
, contract_id
, product_id
, create_date
, product_valid_from
, product_valid_to
, price_wo_vat
, IF(price_wo_vat <= 0, 0, price_wo_vat * 1.2) AS price_w_vat
, unit
, update_date
, product_name
, product_type
, IF(product_valid_from ="2035-12-31", TRUE, FALSE) AS flag_unlimited_product
FROM `psychic-heading-455311-r2.L1.L1_product_purchases` 
WHERE product_status NOT IN("canceled", "canceled_registration", "disconnected") 
AND product_status IS NOT NULL
AND product_category IN("product", "rent"); 