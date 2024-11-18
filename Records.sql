CREATE TABLE records (
  prop_id INT,
  adhar_id INT,
  start_date DATE,		
  end_date DATE,
  rent INT,
  hike INT,
  comm INT,
  PRIMARY KEY (prop_id, start_date),
  FOREIGN KEY (prop_id) REFERENCES property(prop_id),
  FOREIGN KEY (adhar_id) REFERENCES users(adhar_id)
);

ALTER TABLE records
ADD CONSTRAINT fk_records_property FOREIGN KEY (prop_id) REFERENCES property(prop_id)
    ON DELETE CASCADE ON UPDATE CASCADE, -- Cascade changes to associated propertyx
ADD CONSTRAINT fk_records_users FOREIGN KEY (adhar_id) REFERENCES users(adhar_id)
    ON DELETE CASCADE ON UPDATE CASCADE, -- Cascade changes to associated user
ADD CONSTRAINT chk_rent1 CHECK (rent > 0),                 -- Ensure rent is positive
ADD CONSTRAINT chk_hike1 CHECK (hike >= 0),                -- Ensure hike is non-negative
ADD CONSTRAINT chk_comm CHECK (comm >= 0);                -- Ensure commission is non-negative
/* Trigger for record dates to be correctly fit*/
DELIMITER $$

CREATE TRIGGER check_rental_dates
BEFORE INSERT ON records
FOR EACH ROW
BEGIN
  DECLARE prop_start DATE;
  DECLARE prop_end DATE;

  -- Retrieve the property start and end dates
  SELECT start_date, end_date INTO prop_start, prop_end
  FROM property
  WHERE prop_id = NEW.prop_id;

  -- Check if the record dates fall within the property dates
  IF NEW.start_date < prop_start OR NEW.start_date > prop_end 
     OR NEW.end_date < prop_start OR NEW.end_date > prop_end THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'The rental start and end dates must be within the property availability period.';
  END IF;
END$$

DELIMITER ;

/* Procedure for calculating the total rent */
DELIMITER $$

CREATE PROCEDURE CalculateTotalRent (
    IN property_id INT,
    IN start_date DATE,
    IN end_date DATE,
    OUT total_rent DECIMAL(10,2)
)
BEGIN
    -- Calculate the total rent collected for a property within a date range
    SELECT SUM(rent) INTO total_rent
    FROM records
    WHERE prop_id = property_id
      AND start_date >= start_date
      AND end_date <= end_date;
END$$

DELIMITER ;

CALL CalculateTotalRent(101, '2024-01-01', '2024-12-31', @total_rent);
SELECT @total_rent;

INSERT INTO records (
    prop_id, adhar_id, start_date, end_date, rent, hike, comm
) VALUES
(2001, 1001, '2024-01-01', '2024-03-31', 25000, 5, 2000),   -- Property 2001, first rental period
(2001, 1001, '2024-04-01', '2024-06-30', 26000, 5, 2100),   -- Property 2001, second rental period

(2002, 1002, '2024-01-15', '2024-05-15', 22000, 4, 1800),   -- Property 2002, first rental period
(2002, 1002, '2024-05-16', '2024-09-15', 23000, 4, 1850),   -- Property 2002, second rental period

(2003, 1003, '2024-02-01', '2024-06-01', 30000, 6, 2500),   -- Property 2003, first rental period
(2003, 1003, '2024-06-02', '2024-10-01', 31000, 6, 2600),   -- Property 2003, second rental period

(2004, 1004, '2024-01-01', '2024-03-31', 18000, 3, 1500),   -- Property 2004, first rental period
(2004, 1004, '2024-04-01', '2024-08-31', 18500, 3, 1550),   -- Property 2004, second rental period

(2005, 1005, '2024-01-10', '2024-04-10', 45000, 8, 4000),   -- Property 2005, first rental period
(2005, 1005, '2024-04-11', '2024-08-10', 46000, 8, 4200),   -- Property 2005, second rental period

(2006, 1006, '2024-03-01', '2024-06-30', 35000, 7, 3000),   -- Property 2006, first rental period
(2006, 1006, '2024-07-01', '2024-10-31', 36000, 7, 3200),   -- Property 2006, second rental period

(2007, 1007, '2024-05-01', '2024-07-31', 27000, 5, 2500),   -- Property 2007, first rental period
(2007, 1007, '2024-08-01', '2024-11-30', 27500, 5, 2600);   -- Property 2007, second rental period



