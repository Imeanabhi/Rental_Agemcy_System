CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT UNIQUE,
    prop_id INT,
    date DATE,
    cost DECIMAL(10,2),
    description VARCHAR(255),
    FOREIGN KEY (prop_id) REFERENCES property(prop_id)
);
ALTER TABLE maintenance
ADD CONSTRAINT chk_cost CHECK (cost > 0);

ALTER TABLE maintenance
MODIFY prop_id INT NOT NULL,
MODIFY date DATE NOT NULL,
MODIFY cost DECIMAL(10,2) NOT NULL;

ALTER TABLE maintenance
MODIFY description VARCHAR(255) NULL;

ALTER TABLE maintenance
ADD CONSTRAINT chk_date CHECK (date <= CURDATE());

ALTER TABLE maintenance               
ADD PRIMARY KEY (prop_id, date);       


-- Insert maintenance records for properties
INSERT INTO maintenance (prop_id, date, cost, description)
VALUES
(2001, '2024-03-15', 5000.00, 'Painting and minor repairs'),
(2002, '2024-05-20', 3000.00, 'Plumbing maintenance'),
(2003, '2024-07-10', 7000.00, 'Roof replacement'),
(2004, '2024-08-25', 2500.00, 'Electrical rewiring'),
(2005, '2024-09-15', 1500.00, 'Garden landscaping');
