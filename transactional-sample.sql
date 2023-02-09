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

UPDATE transactional_sample
SET device_id = CASE WHEN device_id = '' THEN NULL END
WHERE device_id IN ('');

ALTER TABLE transactional_sample
MODIFY has_cbk TINYINT;

-- Transactions above a threshold, held by average + 3 * stdev
SELECT * 
FROM transactional_sample
WHERE transaction_amount > (SELECT AVG(transaction_amount) + (3 * STDDEV(transaction_amount)) 
                            FROM transactional_sample);
                        
-- Transactions above a threshold, held by average + 3 * stdev AND without the device_id
SELECT card_number, transaction_amount, transaction_id, merchant_id, has_cbk 
FROM transactional_sample
WHERE device_id IS NULL
  AND transaction_amount > 
    (SELECT AVG(transaction_amount) + (3 * STDDEV(transaction_amount)) 
     FROM transactional_sample);

-- Transactions with less than 3 minutes from the same card
SELECT card_number, transaction_amount, transaction_id, merchant_id, has_cbk 
FROM transactional_sample 
WHERE card_number IN (SELECT card_number 
                      FROM transactional_sample 
                      GROUP BY card_number 
                      HAVING COUNT(*) > 1 
                      AND TIMESTAMPDIFF(MINUTE, MAX(transaction_date), MIN(transaction_date)) < 3) 
ORDER BY card_number;

-- Transactions with less than 3 minutes from the same user_id
SELECT user_id, transaction_amount, transaction_id, merchant_id, has_cbk 
FROM transactional_sample 
WHERE user_id IN (SELECT user_id 
                      FROM transactional_sample 
                      GROUP BY user_id 
                      HAVING COUNT(*) > 1 
                      AND TIMESTAMPDIFF(MINUTE, MAX(transaction_date), MIN(transaction_date)) < 3) 
ORDER BY user_id;