CREATE TABLE property (
  adhar_id INT,
  prop_id INT,
  floors INT,
  start_date DATE,
  end_date DATE,
  area INT,
  address VARCHAR(30),
  rent INT,
  hike INT,
  plinth_area INT,
  yoc INT,
  bedno INT,
  availability INT,
  locality VARCHAR(10),
  PRIMARY KEY (prop_id),
  FOREIGN KEY (adhar_id) REFERENCES users(adhar_id)
);

ALTER TABLE property
ADD CONSTRAINT fk_property_adhar FOREIGN KEY (adhar_id) REFERENCES users(adhar_id) 
ON DELETE CASCADE ON UPDATE CASCADE, -- Cascades to update/delete related rows
ADD CONSTRAINT chk_floors CHECK (floors > 0),             -- Ensure at least one floor
ADD CONSTRAINT chk_area CHECK (area > 0),                 -- Ensure area is positive
ADD CONSTRAINT chk_rent CHECK (rent > 0),                 -- Ensure rent is positive
ADD CONSTRAINT chk_hike CHECK (hike >= 0),                -- Ensure rent hike is non-negative
ADD CONSTRAINT chk_plinth_area CHECK (plinth_area > 0),   -- Ensure plinth area is positive
ADD CONSTRAINT chk_bedno CHECK (bedno >= 1), -- Ensure valid number of bedrooms
ADD CONSTRAINT chk_availability CHECK (availability IN (0, 1)); -- Ensure availability is either 0 or 1

/*Adding constrain i.e not null*/

ALTER TABLE property MODIFY adhar_id INT NOT NULL;
ALTER TABLE property MODIFY prop_id INT NOT NULL;
ALTER TABLE property MODIFY floors INT NOT NULL;
ALTER TABLE property MODIFY start_date DATE NOT NULL;
ALTER TABLE property MODIFY end_date DATE NOT NULL;
ALTER TABLE property MODIFY area INT NOT NULL;
ALTER TABLE property MODIFY address VARCHAR(30) NOT NULL;
ALTER TABLE property MODIFY rent INT NOT NULL;
ALTER TABLE property MODIFY hike INT NOT NULL;
ALTER TABLE property MODIFY plinth_area INT NOT NULL;
ALTER TABLE property MODIFY yoc INT NOT NULL;
ALTER TABLE property MODIFY bedno INT NOT NULL;
ALTER TABLE property MODIFY availability INT NOT NULL;
ALTER TABLE property MODIFY locality VARCHAR(10) NOT NULL;

Alter table property
ADD CONSTRAINT chk_dates CHECK (start_date <= end_date);

DELIMITER $$
CREATE TRIGGER validate_yoc
BEFORE INSERT ON property
FOR EACH ROW
BEGIN
  DECLARE current_year INT;
  SET current_year = YEAR(CURDATE());   -- Set the current year

  IF NEW.yoc < 1800 OR NEW.yoc > current_year THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Year of construction must be between 1800 and the current year.';
  END IF;
END$$

DELIMITER ;

INSERT INTO property (
    adhar_id, prop_id, floors, start_date, end_date, area, address, rent, hike, 
    plinth_area, yoc, bedno, availability, locality
) VALUES
(1001, 2001, 3, '2024-01-01', '2024-12-31', 1500, 'Ameerpet, Hyderabad', 25000, 5, 1300, 2010, 3, 1, 'Urban'),
(1002, 2002, 2, '2024-01-15', '2024-12-31', 1200, 'Gachibowli, Hyderabad', 22000, 4, 1100, 2012, 2, 1, 'Urban'),
(1003, 2003, 4, '2024-02-01', '2024-12-31', 1800, 'Miyapur, Hyderabad', 30000, 6, 1600, 2008, 4, 1, 'Suburban'),
(1004, 2004, 1, '2024-01-01', '2024-12-31', 800, 'Kukatpally, Hyderabad', 18000, 3, 700, 2015, 1, 1, 'Urban'),
(1005, 2005, 5, '2024-01-10', '2024-12-31', 2000, 'Banjara Hills, Hyderabad', 45000, 8, 1900, 2005, 5, 1, 'Luxury'),
(1006, 2006, 2, '2024-03-01', '2024-12-31', 1000, 'Jubilee Hills, Hyderabad', 35000, 7, 900, 2018, 3, 1, 'Luxury'),
(1007, 2007, 3, '2024-05-01', '2024-12-31', 1400, 'Begumpet, Hyderabad', 27000, 5, 1200, 2011, 3, 1, 'Urban');



INSERT INTO property (adhar_id, prop_id, floors, start_date, end_date, area, address, rent, hike, 
                      plinth_area, yoc, bedno, availability, locality)
VALUES
(1005, 2005, 5, '2024-01-10', '2024-12-31', 2000, 'Banjara Hills, Hyderabad', 45000, 8, 1900, 2005, 5, 1, 'Luxury'),
(1006, 2006, 2, '2024-03-01', '2024-12-31', 1000, 'Jubilee Hills, Hyderabad', 35000, 7, 900, 2018, 3, 1, 'Luxury'),
(1007, 2007, 3, '2024-05-01', '2024-12-31', 1400, 'Begumpet, Hyderabad', 27000, 5, 1200, 2011, 3, 1, 'Urban'),
(1008, 2008, 3, '2024-04-01', '2024-12-31', 1500, 'Kondapur, Hyderabad', 30000, 6, 1300, 2012, 4, 1, 'Suburban');


