
CREATE TABLE `AccessApproval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `approvalNotes` text DEFAULT NULL,
  `status` varchar(45) NOT NULL,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;