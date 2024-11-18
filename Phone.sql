CREATE TABLE phone (
  adhar_id INT,
  phno BIGINT,
  FOREIGN KEY (adhar_id) REFERENCES users(adhar_id)
);
ALTER TABLE phone
ADD PRIMARY KEY (phno);

ALTER TABLE phone
ADD broker_phno BIGINT,
ADD broker_name VARCHAR(255);

ALTER TABLE phone
ADD CONSTRAINT fk_broker_phno
FOREIGN KEY (broker_phno) REFERENCES phone(phno);

ALTER TABLE phone
MODIFY adhar_id INT NOT NULL,
MODIFY phno BIGINT NOT NULL;
ALTER TABLE phone
ALTER broker_name SET DEFAULT 'Unknown Broker';
ALTER TABLE phone
ADD CONSTRAINT fk_phone_q_id
FOREIGN KEY (adhar_id) REFERENCES users(adhar_id) ON DELETE CASCADE;

INSERT INTO phone (adhar_id, phno, broker_phno, broker_name) VALUES
(1001, 9876543210, NULL, NULL),                     -- No broker for this user
(1002, 9876543211, 9123456789, 'Realty Brokers Ltd'),   -- Broker assigned
(1003, 9876543212, NULL, NULL),                     -- No broker for this user
(1004, 9876543213, 9123456789, 'Realty Brokers Ltd'),   -- Broker assigned
(1005, 9876543214, NULL, NULL),                     -- No broker for this user
(1006, 9876543215, 9234567890, 'Home Solutions'),       -- Different broker
(1007, 9876543216, NULL, NULL);                     -- No broker for this user
INSERT INTO phone (adhar_id, phno, broker_name) VALUES
(9001, 9123456789, 'Realty Brokers Ltd'),
(9002, 9234567890, 'Home Solutions');

