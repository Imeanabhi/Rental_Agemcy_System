CREATE TABLE users (
  adhar_id INT PRIMARY KEY,
  name VARCHAR(50) ,
  address VARCHAR(100) 
); 
show tables;
ALTER TABLE users MODIFY name VARCHAR(50) NOT NULL;
ALTER TABLE users MODIFY address VARCHAR(100) NOT NULL;
ALTER TABLE users
ADD CONSTRAINT chk_adhar_id CHECK (adhar_id > 0),         -- Ensure positive Adhar ID
ADD CONSTRAINT chk_name CHECK (LENGTH(name) > 1),         -- Ensure name has at least 2 characters
ADD CONSTRAINT chk_address CHECK (LENGTH(address) > 5);   -- Ensure address has at least 5 characters
INSERT INTO users (adhar_id, name, address) VALUES
(1001, 'Nagabothu Suresh', '456/78 Sai Residency, Ameerpet, Hyderabad'),
(1002, 'Kumar Vedant', '12/34 Lotus Apartments, Gachibowli, Hyderabad'),
(1003, 'Megha Varma', '56/78 Shanti Residency, Miyapur, Hyderabad'),
(1004, 'Pallavi Reddy', '23/45 Vinayak Towers, Kukatpally, Hyderabad'),
(1005, 'Ravi Teja', '67/89 Pearl Residency, Banjara Hills, Hyderabad'),
(1006, 'Priya Sharma', '90/12 Rose Villa, Jubilee Hills, Hyderabad'),
(1007, 'Vikram Kumar', '12/56 Green Gardens, Begumpet, Hyderabad');
select * from users;

INSERT INTO users (adhar_id, name, address) VALUES
(9001, 'Realty Brokers Ltd', '123 Broker St, Hyderabad'),
(9002, 'Home Solutions', '456 Broker St, Hyderabad');
