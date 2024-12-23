-- MySQL dump 10.13  Distrib 8.0.37, for Win64 (x86_64)
--
-- Host: localhost    Database: RentalAgency
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `maintenance`
--

DROP TABLE IF EXISTS `maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance` (
  `maintenance_id` int NOT NULL AUTO_INCREMENT,
  `prop_id` int NOT NULL,
  `date` date NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`prop_id`,`date`),
  UNIQUE KEY `maintenance_id` (`maintenance_id`),
  UNIQUE KEY `maintenance_id_2` (`maintenance_id`),
  UNIQUE KEY `maintenance_id_3` (`maintenance_id`),
  UNIQUE KEY `maintenance_id_4` (`maintenance_id`),
  CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`prop_id`) REFERENCES `property` (`prop_id`),
  CONSTRAINT `chk_cost` CHECK ((`cost` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance`
--

LOCK TABLES `maintenance` WRITE;
/*!40000 ALTER TABLE `maintenance` DISABLE KEYS */;
/*!40000 ALTER TABLE `maintenance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manages`
--

DROP TABLE IF EXISTS `manages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manages` (
  `manager_id` int NOT NULL,
  `prop_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`manager_id`,`prop_id`),
  KEY `prop_id` (`prop_id`),
  CONSTRAINT `manages_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `property_manager` (`manager_id`) ON DELETE CASCADE,
  CONSTRAINT `manages_ibfk_2` FOREIGN KEY (`prop_id`) REFERENCES `property` (`prop_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manages`
--

LOCK TABLES `manages` WRITE;
/*!40000 ALTER TABLE `manages` DISABLE KEYS */;
/*!40000 ALTER TABLE `manages` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Abhiram`@`%`*/ /*!50003 TRIGGER `check_manages_dates` BEFORE INSERT ON `manages` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `payment_history`
--

DROP TABLE IF EXISTS `payment_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_history` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `adhar_id` int NOT NULL,
  `prop_id` int NOT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `method` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `adhar_id` (`adhar_id`),
  KEY `prop_id` (`prop_id`),
  CONSTRAINT `payment_history_ibfk_1` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`),
  CONSTRAINT `payment_history_ibfk_2` FOREIGN KEY (`prop_id`) REFERENCES `property` (`prop_id`),
  CONSTRAINT `chk_amount` CHECK ((`amount` > 0)),
  CONSTRAINT `chk_method` CHECK ((`method` in (_utf8mb4'Cash',_utf8mb4'Card',_utf8mb4'Bank Transfer',_utf8mb4'UPI',_utf8mb4'Online')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_history`
--

LOCK TABLES `payment_history` WRITE;
/*!40000 ALTER TABLE `payment_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_history` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Abhiram`@`%`*/ /*!50003 TRIGGER `check_payment_date_before_insert` BEFORE INSERT ON `payment_history` FOR EACH ROW BEGIN
    IF NEW.payment_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Payment date cannot be in the future.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `phone`
--

DROP TABLE IF EXISTS `phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phone` (
  `adhar_id` int NOT NULL,
  `phno` bigint NOT NULL,
  `broker_phno` bigint DEFAULT NULL,
  `broker_name` varchar(255) DEFAULT 'Unknown Broker',
  PRIMARY KEY (`phno`),
  KEY `fk_broker_phno` (`broker_phno`),
  KEY `fk_phone_adhar_id` (`adhar_id`),
  CONSTRAINT `fk_adhar_id` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_broker_phno` FOREIGN KEY (`broker_phno`) REFERENCES `phone` (`phno`),
  CONSTRAINT `fk_phone_adhar_id` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`) ON DELETE CASCADE,
  CONSTRAINT `phone_ibfk_1` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone`
--

LOCK TABLES `phone` WRITE;
/*!40000 ALTER TABLE `phone` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property`
--

DROP TABLE IF EXISTS `property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property` (
  `adhar_id` int NOT NULL,
  `prop_id` int NOT NULL,
  `floors` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `area` int NOT NULL,
  `address` varchar(30) NOT NULL,
  `rent` int NOT NULL,
  `hike` int NOT NULL,
  `plinth_area` int NOT NULL,
  `yoc` int NOT NULL,
  `bedno` int NOT NULL,
  `availability` int NOT NULL,
  `locality` varchar(10) NOT NULL,
  PRIMARY KEY (`prop_id`),
  KEY `fk_property_adhar` (`adhar_id`),
  CONSTRAINT `fk_property_adhar` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `property_ibfk_1` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`),
  CONSTRAINT `chk_area` CHECK ((`area` > 0)),
  CONSTRAINT `chk_availability` CHECK ((`availability` in (0,1))),
  CONSTRAINT `chk_bedno` CHECK ((`bedno` >= 1)),
  CONSTRAINT `chk_dates` CHECK ((`start_date` <= `end_date`)),
  CONSTRAINT `chk_floors` CHECK ((`floors` > 0)),
  CONSTRAINT `chk_hike` CHECK ((`hike` >= 0)),
  CONSTRAINT `chk_plinth_area` CHECK ((`plinth_area` > 0)),
  CONSTRAINT `chk_rent` CHECK ((`rent` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property`
--

LOCK TABLES `property` WRITE;
/*!40000 ALTER TABLE `property` DISABLE KEYS */;
/*!40000 ALTER TABLE `property` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Abhiram`@`%`*/ /*!50003 TRIGGER `validate_yoc` BEFORE INSERT ON `property` FOR EACH ROW BEGIN
  IF NEW.yoc < 1800 OR NEW.yoc > YEAR(CURDATE()) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Year of construction must be between 1800 and the current year.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `property_manager`
--

DROP TABLE IF EXISTS `property_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `property_manager` (
  `manager_id` int NOT NULL AUTO_INCREMENT,
  `manager_name` varchar(100) NOT NULL,
  `contact_number` bigint NOT NULL,
  `office_address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`manager_id`),
  UNIQUE KEY `contact_number` (`contact_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_manager`
--

LOCK TABLES `property_manager` WRITE;
/*!40000 ALTER TABLE `property_manager` DISABLE KEYS */;
/*!40000 ALTER TABLE `property_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `records`
--

DROP TABLE IF EXISTS `records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `records` (
  `prop_id` int NOT NULL,
  `adhar_id` int DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `rent` int DEFAULT NULL,
  `hike` int DEFAULT NULL,
  `comm` int DEFAULT NULL,
  PRIMARY KEY (`prop_id`,`start_date`),
  KEY `fk_records_users` (`adhar_id`),
  CONSTRAINT `fk_records_property` FOREIGN KEY (`prop_id`) REFERENCES `property` (`prop_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `records_ibfk_1` FOREIGN KEY (`prop_id`) REFERENCES `property` (`prop_id`),
  CONSTRAINT `records_ibfk_2` FOREIGN KEY (`adhar_id`) REFERENCES `users` (`adhar_id`),
  CONSTRAINT `chk_comm` CHECK ((`comm` >= 0)),
  CONSTRAINT `chk_hike1` CHECK ((`hike` >= 0)),
  CONSTRAINT `chk_rent1` CHECK ((`rent` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `records`
--

LOCK TABLES `records` WRITE;
/*!40000 ALTER TABLE `records` DISABLE KEYS */;
/*!40000 ALTER TABLE `records` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`Abhiram`@`%`*/ /*!50003 TRIGGER `check_rental_dates` BEFORE INSERT ON `records` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `adhar_id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`adhar_id`),
  CONSTRAINT `chk_address` CHECK ((length(`address`) > 5)),
  CONSTRAINT `chk_adhar_id` CHECK ((`adhar_id` > 0)),
  CONSTRAINT `chk_name` CHECK ((length(`name`) > 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (5320,'Nagabothu Abhiram','120/24 Balaji Adarsh Avenue, Nizampet. Hyderabad.');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-11 17:18:00
