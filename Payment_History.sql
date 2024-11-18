CREATE TABLE payment_history (
    payment_id INT AUTO_INCREMENT UNIQUE,
    adhar_id INT,
    prop_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    method VARCHAR(50),
    FOREIGN KEY (adhar_id) REFERENCES users(adhar_id),
    FOREIGN KEY (prop_id) REFERENCES property(prop_id)
);

ALTER TABLE payment_history
MODIFY adhar_id INT NOT NULL,
MODIFY prop_id INT NOT NULL,
MODIFY payment_date DATE NOT NULL;

-- Add check constraint to ensure amount is greater than 0
ALTER TABLE payment_history
ADD CONSTRAINT chk_amount_payment CHECK (amount > 0);

-- Add check constraint to restrict payment method to certain values
ALTER TABLE payment_history
ADD CONSTRAINT chk_method CHECK (method IN ('Cash', 'Card', 'Bank Transfer', 'UPI', 'Online'));

DELIMITER $$

CREATE TRIGGER check_payment_date_before_insert
BEFORE INSERT ON payment_history
FOR EACH ROW
BEGIN
    IF NEW.payment_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Payment date cannot be in the future.';
    END IF;
END$$

DELIMITER ;

-- Insert payment history records based on existing data
INSERT INTO payment_history (adhar_id, prop_id, payment_date, amount, method)
VALUES
(1001, 2001, '2024-03-15', 25000.00, 'Bank Transfer'),  -- Payment for Property 2001 by User 1001
(1002, 2002, '2024-05-01', 22000.00, 'UPI'),            -- Payment for Property 2002 by User 1002
(1003, 2003, '2024-06-01', 30000.00, 'Card'),           -- Payment for Property 2003 by User 1003
(1004, 2004, '2024-04-15', 18000.00, 'Cash'),           -- Payment for Property 2004 by User 1004
(1005, 2005, '2024-07-10', 45000.00, 'Online'),         -- Payment for Property 2005 by User 1005
(1006, 2006, '2024-08-01', 35000.00, 'Bank Transfer'),  -- Payment for Property 2006 by User 1006
(1007, 2007, '2024-09-15', 27000.00, 'UPI');            -- Payment for Property 2007 by User 1007




