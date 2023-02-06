CREATE DATABASE IF NOT EXISTS cloudwalk_case;
USE cloudwalk_case;

CREATE TABLE IF NOT EXISTS transactional_sample(
    transaction_id INT NOT NULL PRIMARY KEY,
    merchant_id INT NOT NULL,
    user_id INT NOT NULL,
    card_number VARCHAR(20) NOT NULL,
    transaction_date DATETIME NOT NULL,
    transaction_amount DECIMAL(10,2) NOT NULL,
    device_id VARCHAR(255) NULL,
    has_cbk VARCHAR(255) NOT NULL);

ANALYZE TABLE `cloudwalk_case`.`transactional_sample`;
DELETE FROM transactional_sampletransactional_sampletransactional_samplecloudwalk_case.transactional_sample LIMIT 1;

UPDATE transactional_sample
SET has_cbk = CASE WHEN has_cbk = 'TRUE' THEN 1 ELSE 0 END
WHERE has_cbk IN ('TRUE', 'FALSE');

ALTER TABLE transactional_sample
MODIFY has_cbk TINYINT;

SELECT * from transactional_sample;

SELECT
    SUM(CASE WHEN has_cbk = 0 THEN 1 ELSE 0 END) AS count_0,
    SUM(CASE WHEN has_cbk = 1 THEN 1 ELSE 0 END) AS count_1
FROM transactional_sample;

SELECT card_number, transaction_amount, transaction_id, merchant_id 
FROM transactional_sample 
WHERE card_number IN (SELECT card_number 
                      FROM transactional_sample 
                      GROUP BY card_number 
                      HAVING COUNT(*) > 1 
                      AND TIMESTAMPDIFF(MINUTE, MAX(transaction_date), MIN(transaction_date)) < 3) 
ORDER BY card_number;