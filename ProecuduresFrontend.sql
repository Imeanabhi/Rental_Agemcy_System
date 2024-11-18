DELIMITER $$

CREATE PROCEDURE GetPhoneDetailsByAdhar(IN input_adhar_id INT)
BEGIN
    SELECT phno, broker_name, broker_phno
    FROM phone
    WHERE adhar_id = input_adhar_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetPropertiesByManagers(IN input_manager_id INT)
BEGIN
    -- Check if the manager exists
    IF EXISTS (SELECT 1 FROM property_manager WHERE manager_id = input_manager_id) THEN
        SELECT 
            p.prop_id AS `Property ID`, 
            p.locality AS `Location`,  -- Ensure `locality` exists in `property`
            p.rent AS `Rent`,          -- Ensure `rent` exists in `property`
            m.start_date AS `Start Date`,
            COALESCE(m.end_date, 'Ongoing') AS `End Date`
        FROM manages m
        JOIN property p ON m.prop_id = p.prop_id
        WHERE m.manager_id = input_manager_id;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetUsersWithoutBrokers()
BEGIN
    SELECT 
        u.name AS `User Name`, 
        u.adhar_id AS `Aadhaar ID`, 
        p.phno AS `Phone Number`
    FROM users u
    JOIN phone p ON u.adhar_id = p.adhar_id
    WHERE p.broker_phno IS NULL;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE UpdatePropertyRent(IN prop_id INT, IN new_rent DECIMAL(10, 2))
BEGIN
    DECLARE current_rent DECIMAL(10, 2);

    -- Get the current rent for the property
    SELECT rent_per_month INTO current_rent
    FROM property
    WHERE prop_id = prop_id
    LIMIT 1;  -- Ensures only one row is returned

    -- If the new rent is higher than the current rent, give a warning
    IF new_rent > current_rent THEN
        SELECT CONCAT('Warning: Rent increased from ', current_rent, ' to ', new_rent) AS `Rent Update Status`;
    END IF;

    -- Update the rent for the property
    UPDATE property
    SET rent_per_month = new_rent
    WHERE prop_id = prop_id;

    -- Confirm the update
    SELECT CONCAT('Rent for Property ID ', prop_id, ' updated to ', new_rent) AS `Update Status`;
END $$

DELIMITER ;




