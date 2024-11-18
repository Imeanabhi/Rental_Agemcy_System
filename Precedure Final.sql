DELIMITER $$

DROP PROCEDURE IF EXISTS GetTotalPaymentsForProperty$$

CREATE PROCEDURE GetTotalPaymentsForProperty(
    IN input_prop_id INT,
    OUT total_payment DECIMAL(10,2)
)
BEGIN
    -- Calculate total payments for the given property ID
    SELECT IFNULL(SUM(amount), 0)
    INTO total_payment
    FROM payment_history
    WHERE prop_id = input_prop_id;
END$$

DELIMITER ;




-- Call the stored procedure with the property ID (for example, 2005)
CALL GetTotalPaymentsForProperty(2001, @total_payment);

-- Retrieve the result from the output variable
SELECT @total_payment AS total_payment
 
 

-- 2nd Procedure 
DELIMITER $$

DROP PROCEDURE IF EXISTS GetManagerDetailsForProperty$$

CREATE PROCEDURE GetManagerDetailsForProperty(
    IN input_prop_id INT
)
BEGIN
    -- Retrieve the manager details for the given property ID
    SELECT pm.manager_name, pm.contact_number, pm.office_address, m.start_date, m.end_date
    FROM property_manager pm
    JOIN manages m ON pm.manager_id = m.manager_id
    WHERE m.prop_id = input_prop_id;
END$$

DELIMITER ;

-- Call the stored procedure with the property ID (for example, 2002)
CALL GetManagerDetailsForProperty(2004);



-- 3rd Procedure
DELIMITER $$

DROP PROCEDURE IF EXISTS GetPaymentHistoryForProperty$$

CREATE PROCEDURE GetPaymentHistoryForProperty(
    IN input_prop_id INT
)
BEGIN
    -- Retrieve the payment history for the given property ID
    SELECT payment_id, adhar_id, payment_date, amount, method
    FROM payment_history
    WHERE prop_id = input_prop_id
    ORDER BY payment_date DESC;
END$$

DELIMITER ;

-- Call the stored procedure with the property ID (for example, 2002)
CALL GetPaymentHistoryForProperty(2009);

-- 4th Procedure

DELIMITER $$

DROP PROCEDURE IF EXISTS GetTotalPropertiesManagedByManager$$

CREATE PROCEDURE GetTotalPropertiesManagedByManager(
    IN input_manager_id INT,
    OUT total_properties INT
)
BEGIN
    -- Count the total number of properties managed by the given manager
    SELECT IFNULL(COUNT(*), 0)
    INTO total_properties
    FROM manages
    WHERE manager_id = input_manager_id;
END$$

DELIMITER ;

-- Declare a variable to hold the result
SET @total_properties = 0;

-- Call the stored procedure with the manager ID (for example, 1)
CALL GetTotalPropertiesManagedByManager(1, @total_properties);

-- Retrieve the result from the output variable
SELECT @total_properties AS total_properties;

