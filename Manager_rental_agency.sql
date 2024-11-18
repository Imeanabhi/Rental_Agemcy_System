CREATE TABLE property_manager (
    manager_id INT AUTO_INCREMENT PRIMARY KEY, -- Primary key for property manager
    manager_name VARCHAR(100) NOT NULL,
    contact_number BIGINT NOT NULL UNIQUE, -- Unique phone number for the manager
    office_address VARCHAR(255) 
);


CREATE TABLE manages (
    manager_id INT NOT NULL, -- Foreign key referencing property_manager
    prop_id INT NOT NULL, -- Foreign key referencing property
    start_date DATE NOT NULL,
    end_date DATE NULL,
    PRIMARY KEY (manager_id, prop_id), -- Composite primary key
    FOREIGN KEY (manager_id) REFERENCES property_manager(manager_id) ON DELETE CASCADE,
    FOREIGN KEY (prop_id) REFERENCES property(prop_id) ON DELETE CASCADE
);
DELIMITER $$

CREATE TRIGGER check_manages_dates
BEFORE INSERT ON manages
FOR EACH ROW
BEGIN
    DECLARE prop_start DATE;
    DECLARE prop_end DATE;

    -- Retrieve the property's start and end dates from the property table
    SELECT start_date, end_date INTO prop_start, prop_end
    FROM property
    WHERE prop_id = NEW.prop_id;

    -- Check if the manager's start_date and end_date are within the property's start and end dates
    IF NEW.start_date < prop_start OR NEW.start_date > prop_end THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Property managed start date must be within the property availability period.';
    END IF;

    IF NEW.end_date IS NOT NULL AND (NEW.end_date < prop_start OR NEW.end_date > prop_end) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Property managed date must be within the property availability period.';
    END IF;
END$$

DELIMITER ;

-- Insert property manager records
INSERT INTO property_manager (manager_name, contact_number, office_address)
VALUES
('Rajesh Patel', 9876543210, 'Office 123, Ameerpet, Hyderabad'),
('Sunita Gupta', 9876543211, 'Office 234, Gachibowli, Hyderabad'),
('Anil Kumar', 9876543212, 'Office 345, Miyapur, Hyderabad');

-- Insert management records for properties handled by managers
INSERT INTO manages (manager_id, prop_id, start_date, end_date)
VALUES
(1, 2001, '2024-01-01', '2024-06-30'), -- Manager Rajesh Patel manages Property 2001 for a specified duration
(2, 2002, '2024-02-01', '2024-09-30'), -- Manager Sunita Gupta manages Property 2002
(3, 2003, '2024-03-01', NULL),         -- Manager Anil Kumar manages Property 2003 with no specified end date
(1, 2004, '2024-04-15', '2024-12-31'); -- Rajesh Patel manages another property (2004)

-- Insert more property manager records
INSERT INTO property_manager (manager_name, contact_number, office_address)
VALUES
('Meena Sharma', 9876543213, 'Office 456, Banjara Hills, Hyderabad'),
('Vikram Rao', 9876543214, 'Office 567, Secunderabad, Hyderabad'),
('Priya Das', 9876543215, 'Office 678, Jubilee Hills, Hyderabad'),
('Ramesh Reddy', 9876543216, 'Office 789, Kondapur, Hyderabad');

INSERT INTO property_manager (manager_name, contact_number, office_address)
VALUES
('Meena Sharma', 9876543217, 'Office 456, Banjara Hills, Hyderabad'),  -- Updated contact number
('Vikram Rao', 9876543218, 'Office 567, Secunderabad, Hyderabad'),      -- Updated contact number
('Priya Das', 9876543219, 'Office 678, Jubilee Hills, Hyderabad'),       -- Updated contact number
('Ramesh Reddy', 9876543220, 'Office 789, Kondapur, Hyderabad');         -- Updated contact number



-- New management records
INSERT INTO manages (manager_id, prop_id, start_date, end_date)
VALUES
(4, 2005, '2024-05-01', '2024-12-31'),  -- Manager Meena Sharma manages Property 2005
(5, 2006, '2024-06-01', '2024-12-31'),  -- Manager Vikram Rao manages Property 2006
(6, 2007, '2024-07-01', NULL),          -- Manager Priya Das manages Property 2007 with no specified end date
(4, 2008, '2024-08-01', '2024-12-31');  -- Meena Sharma manages Property 2008

