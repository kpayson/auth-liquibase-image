--liquibase formatted sql
--changeset auth-team:1.0
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `AccessApproval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccessApproval` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `approvalNotes` text DEFAULT NULL,
  `status` varchar(45) NOT NULL,
  `reviewerNotes` text DEFAULT NULL,
  `accessRequestId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `tenantId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `resourceId` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_AccessApproval_accessRequestId_userId` (`accessRequestId`,`userId`),
  KEY `FK_AccessApproval_userId` (`userId`),
  KEY `FK_AccessApproval_tenantId` (`tenantId`),
  CONSTRAINT `FK_AccessApproval_accessRequestId` FOREIGN KEY (`accessRequestId`) REFERENCES `AccessRequest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessApproval_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessApproval_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccessApproval`
--

LOCK TABLES `AccessApproval` WRITE;
/*!40000 ALTER TABLE `AccessApproval` DISABLE KEYS */;
/*!40000 ALTER TABLE `AccessApproval` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AccessRequest`
--

DROP TABLE IF EXISTS `AccessRequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccessRequest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) NOT NULL,
  `requestorNotes` text DEFAULT NULL,
  `requestedByUserId` int(11) NOT NULL,
  `requestedForUserId` int(11) DEFAULT NULL,
  `requestableAccessId` int(11) NOT NULL,
  `tenantId` int(11) NOT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  `expiresAt` datetime DEFAULT NULL,
  `approvedAt` datetime DEFAULT NULL,
  `resourceId` varchar(255) DEFAULT '',
  `requestDescription` varchar(255) DEFAULT NULL,
  `resourceUrl` varchar(255) DEFAULT NULL,
  `confirmationToken` varchar(255) DEFAULT NULL,
  `confirmationTokenExpiration` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `IDX_AccessRequest_confirmationToken` (`confirmationToken`),
  KEY `IDX_AccessRequest_tenantId` (`tenantId`),
  KEY `IDX_AccessRequest_requestableAccessId` (`requestableAccessId`),
  KEY `IDX_AccessRequest_requestedByUserId` (`requestedByUserId`),
  KEY `IX_AccessRequest_requestedForUserId` (`requestedForUserId`),
  CONSTRAINT `FK_AccessRequest_requestableAccessId` FOREIGN KEY (`requestableAccessId`) REFERENCES `RequestableAccess` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessRequest_requestedByUserId` FOREIGN KEY (`requestedByUserId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessRequest_requestedForUserId` FOREIGN KEY (`requestedForUserId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessRequest_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccessRequest`
--

LOCK TABLES `AccessRequest` WRITE;
/*!40000 ALTER TABLE `AccessRequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `AccessRequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AccessRequestEmailConfirmation`
--

DROP TABLE IF EXISTS `AccessRequestEmailConfirmation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccessRequestEmailConfirmation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(1024) NOT NULL,
  `status` varchar(45) NOT NULL,
  `expiresAt` datetime NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `accessRequestId` int(11) NOT NULL,
  `tenantId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_AccessRequestEmailConfirmation_accessRequestId` (`accessRequestId`),
  KEY `IX_AccessRequestEmailConfirmation_tenantId` (`tenantId`),
  CONSTRAINT `FK_AccessRequestEmailConfirmation_accessRequestId` FOREIGN KEY (`accessRequestId`) REFERENCES `AccessRequest` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessRequestEmailConfirmation_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccessRequestEmailConfirmation`
--

LOCK TABLES `AccessRequestEmailConfirmation` WRITE;
/*!40000 ALTER TABLE `AccessRequestEmailConfirmation` DISABLE KEYS */;
/*!40000 ALTER TABLE `AccessRequestEmailConfirmation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AccessRole`
--

DROP TABLE IF EXISTS `AccessRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccessRole` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `tenantId` int(3) NOT NULL,
  `namespaceId` int(11) DEFAULT NULL,
  `resourceServerId` int(3) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_AccessRole_name_resourceServerId;` (`name`,`resourceServerId`),
  KEY `FK_AccessRole_tenantId` (`tenantId`),
  KEY `FK_AccessRole_namespaceId` (`namespaceId`),
  KEY `FK_AccessRole_resourceServerId` (`resourceServerId`),
  CONSTRAINT `FK_AccessRole_namespaceId` FOREIGN KEY (`namespaceId`) REFERENCES `Namespace` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_AccessRole_resourceServerId` FOREIGN KEY (`resourceServerId`) REFERENCES `ResourceServers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_AccessRole_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccessRole`
--

LOCK TABLES `AccessRole` WRITE;
/*!40000 ALTER TABLE `AccessRole` DISABLE KEYS */;
/*!40000 ALTER TABLE `AccessRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ApprovalWorkflow`
--

DROP TABLE IF EXISTS `ApprovalWorkflow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ApprovalWorkflow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `approvalsRequired` int(11) NOT NULL,
  `isEmailConfirmationRequired` tinyint(1) DEFAULT 0,
  `emailConfirmationExpiresIn` int(10) unsigned NOT NULL,
  `approveIn` bigint(20) NOT NULL,
  `tenantId` int(11) NOT NULL,
  `accessApprovalEmailTemplateId` int(11) DEFAULT NULL,
  `accessRejectionEmailTemplateId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_name_tenantId` (`name`,`tenantId`),
  KEY `FK_ApprovalWorkflow_tenantId` (`tenantId`),
  KEY `FK_accessApprovalEmailTemplateId_emailTemplateId` (`accessApprovalEmailTemplateId`),
  KEY `FK_accessRejectionEmailTemplateId_emailTemplateId` (`accessRejectionEmailTemplateId`),
  CONSTRAINT `FK_ApprovalWorkflow_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_accessApprovalEmailTemplateId_emailTemplateId` FOREIGN KEY (`accessApprovalEmailTemplateId`) REFERENCES `EmailTemplate` (`id`),
  CONSTRAINT `FK_accessRejectionEmailTemplateId_emailTemplateId` FOREIGN KEY (`accessRejectionEmailTemplateId`) REFERENCES `EmailTemplate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ApprovalWorkflow`
--

LOCK TABLES `ApprovalWorkflow` WRITE;
/*!40000 ALTER TABLE `ApprovalWorkflow` DISABLE KEYS */;
/*!40000 ALTER TABLE `ApprovalWorkflow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ApprovalWorkflowApproverGroup`
--

DROP TABLE IF EXISTS `ApprovalWorkflowApproverGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ApprovalWorkflowApproverGroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `approverGroupId` int(3) NOT NULL,
  `approvalWorkflowId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ApprovalWorkflowApproverGroup_groupId_workflowId` (`approverGroupId`,`approvalWorkflowId`),
  KEY `IDX_ApprovalWorkflowApproverGroup_approvalWorkflowId` (`approvalWorkflowId`),
  KEY `IDX_ApprovalWorkflowApproverGroup_approverGroupId` (`approverGroupId`),
  CONSTRAINT `FK_ApprovalWorkflowApproverGroup_approvalWorkflowId` FOREIGN KEY (`approvalWorkflowId`) REFERENCES `ApprovalWorkflow` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ApprovalWorkflowApproverGroup_approverGroupId` FOREIGN KEY (`approverGroupId`) REFERENCES `ApproverGroup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ApprovalWorkflowApproverGroup`
--

LOCK TABLES `ApprovalWorkflowApproverGroup` WRITE;
/*!40000 ALTER TABLE `ApprovalWorkflowApproverGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `ApprovalWorkflowApproverGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ApproverGroup`
--

DROP TABLE IF EXISTS `ApproverGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ApproverGroup` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `tenantId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ApproverGroup_name_tenantId` (`name`,`tenantId`),
  KEY `FK_ApproverGroup_tenantId` (`tenantId`),
  CONSTRAINT `FK_ApproverGroup_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ApproverGroup`
--

LOCK TABLES `ApproverGroup` WRITE;
/*!40000 ALTER TABLE `ApproverGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `ApproverGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ApproverGroupUser`
--

DROP TABLE IF EXISTS `ApproverGroupUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ApproverGroupUser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `approverGroupId` int(3) NOT NULL,
  `userId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ApproverGroupUser_approverGroupId_userId` (`approverGroupId`,`userId`),
  KEY `IDX_ApproverGroupUser_userId` (`userId`),
  KEY `IDX_ApproverGroupUser_approverGroupId` (`approverGroupId`),
  CONSTRAINT `FK_ApproverGroupUser_approverGroupId` FOREIGN KEY (`approverGroupId`) REFERENCES `ApproverGroup` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ApproverGroupUser_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ApproverGroupUser`
--

LOCK TABLES `ApproverGroupUser` WRITE;
/*!40000 ALTER TABLE `ApproverGroupUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `ApproverGroupUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AuditLog`
--

DROP TABLE IF EXISTS `AuditLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AuditLog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auditType` varchar(32) NOT NULL,
  `entityName` varchar(64) NOT NULL,
  `oldEntity` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`oldEntity`)),
  `newEntity` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`newEntity`)),
  `createdOn` datetime NOT NULL DEFAULT current_timestamp(),
  `userId` int(11) DEFAULT NULL,
  `tenantId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuditLog`
--

LOCK TABLES `AuditLog` WRITE;
/*!40000 ALTER TABLE `AuditLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `AuditLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AuthorizationCode`
--

DROP TABLE IF EXISTS `AuthorizationCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AuthorizationCode` (
  `authorizationCode` varchar(255) NOT NULL,
  `grantId` varchar(500) NOT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `isConsumed` tinyint(1) DEFAULT 0,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`authorizationCode`),
  KEY `authorization_code_UNIQUE` (`authorizationCode`),
  KEY `IX_AuthorizationCode_grantId` (`grantId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuthorizationCode`
--

LOCK TABLES `AuthorizationCode` WRITE;
/*!40000 ALTER TABLE `AuthorizationCode` DISABLE KEYS */;
/*!40000 ALTER TABLE `AuthorizationCode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `BatchCommandQueue`
--

DROP TABLE IF EXISTS `BatchCommandQueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BatchCommandQueue` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `batchId` varchar(128) NOT NULL,
  `tenantId` int(3) NOT NULL,
  `success` int(3) NOT NULL,
  `failure` int(3) NOT NULL,
  `pending` int(3) NOT NULL,
  `totalRequests` int(3) NOT NULL,
  `commandKey` varchar(32) NOT NULL,
  `commandData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`commandData`)),
  `status` varchar(32) NOT NULL,
  `requestedByUserId` int(3) NOT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `completedAt` timestamp NULL DEFAULT current_timestamp(),
  `description` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_BatchCommandQueue_batchId` (`batchId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BatchCommandQueue`
--

LOCK TABLES `BatchCommandQueue` WRITE;
/*!40000 ALTER TABLE `BatchCommandQueue` DISABLE KEYS */;
/*!40000 ALTER TABLE `BatchCommandQueue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Client`
--

DROP TABLE IF EXISTS `Client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Client` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `clientId` varchar(255) NOT NULL,
  `clientSecret` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(1024) DEFAULT '',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  `loginEventSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`loginEventSettings`)),
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `clientUri` varchar(1024) DEFAULT '',
  `tenantId` int(3) NOT NULL,
  `type` varchar(255) NOT NULL,
  `createdOn` timestamp NOT NULL DEFAULT current_timestamp(),
  `activeX509CertificateFingerprint` varchar(255) DEFAULT NULL,
  `lastClientSecretUpdate` timestamp NULL DEFAULT current_timestamp(),
  `clientSecretExpirationHasBeenNotified` tinyint(1) NOT NULL DEFAULT 0,
  `notifyExpirationBeforeSeconds` bigint(20) DEFAULT 0,
  `lastClientSecretExpirationNotifiedDate` timestamp NULL DEFAULT NULL,
  `supportsAccountLinking` tinyint(1) DEFAULT 0,
  `shouldUsePreviouslySelectedConnection` tinyint(1) DEFAULT 0,
  `secretLifetimeInDays` int(11) DEFAULT NULL,
  `notifiedSamlCertExpiration` tinyint(1) NOT NULL DEFAULT 0,
  `notifiedSamlCertExpirationDate` timestamp NULL DEFAULT NULL,
  `customErrorSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`customErrorSettings`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Client_clientId_tenantId` (`clientId`,`tenantId`),
  UNIQUE KEY `UQ_Client_name_tenantId` (`tenantId`,`name`),
  KEY `IX_client_tenantId_idx` (`tenantId`),
  CONSTRAINT `FK_Client_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Client`
--

LOCK TABLES `Client` WRITE;
/*!40000 ALTER TABLE `Client` DISABLE KEYS */;
/*!40000 ALTER TABLE `Client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ClientGroups`
--

DROP TABLE IF EXISTS `ClientGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ClientGroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(3) NOT NULL,
  `group_id` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clientID_groupID_const_UNIQUE` (`client_id`,`group_id`),
  KEY `client_group_id_FK` (`group_id`),
  CONSTRAINT `client_group_id_FK` FOREIGN KEY (`group_id`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `group_client_id_FK` FOREIGN KEY (`client_id`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ClientGroups`
--

LOCK TABLES `ClientGroups` WRITE;
/*!40000 ALTER TABLE `ClientGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ClientGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ClientIdentityProvider`
--

DROP TABLE IF EXISTS `ClientIdentityProvider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ClientIdentityProvider` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientId` int(3) NOT NULL,
  `identityProviderId` int(3) NOT NULL,
  `mfaType` varchar(32) DEFAULT NULL,
  `sortOrder` int(2) DEFAULT NULL,
  `verifyEmail` tinyint(1) DEFAULT NULL,
  `storeTokens` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ClientIdentityProvider_clientId_identityProviderId` (`clientId`,`identityProviderId`),
  KEY `IX_ClientIdentityProvider_clientId` (`clientId`),
  KEY `IX_ClientIdentityProvider_clientId_providerId` (`identityProviderId`),
  CONSTRAINT `FK_ClientIdentityProvider_clientId` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ClientIdentityProvider_identityProviderId` FOREIGN KEY (`identityProviderId`) REFERENCES `IdentityProvider` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ClientIdentityProvider`
--

LOCK TABLES `ClientIdentityProvider` WRITE;
/*!40000 ALTER TABLE `ClientIdentityProvider` DISABLE KEYS */;
/*!40000 ALTER TABLE `ClientIdentityProvider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ClientLoginPage`
--

DROP TABLE IF EXISTS `ClientLoginPage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ClientLoginPage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantId` int(11) NOT NULL,
  `clientId` int(11) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `clientLoginPage_clientId_tenantId_UNIQUE` (`clientId`,`tenantId`),
  KEY `clientLoginPage_tenantId_FK` (`tenantId`),
  CONSTRAINT `clientLoginPage_clientId_FK` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `clientLoginPage_tenantId_FK` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ClientLoginPage`
--

LOCK TABLES `ClientLoginPage` WRITE;
/*!40000 ALTER TABLE `ClientLoginPage` DISABLE KEYS */;
/*!40000 ALTER TABLE `ClientLoginPage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ClientPermission`
--

DROP TABLE IF EXISTS `ClientPermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ClientPermission` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `clientId` int(3) NOT NULL,
  `permissionId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `clientId_FK_idx` (`clientId`),
  KEY `permissionId_FK` (`permissionId`),
  CONSTRAINT `clientId_FK` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `permissionId_FK` FOREIGN KEY (`permissionId`) REFERENCES `Permission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ClientPermission`
--

LOCK TABLES `ClientPermission` WRITE;
/*!40000 ALTER TABLE `ClientPermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `ClientPermission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CommandQueue`
--

DROP TABLE IF EXISTS `CommandQueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CommandQueue` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `batchId` varchar(128) NOT NULL,
  `tenantId` int(3) NOT NULL,
  `commandId` int(3) NOT NULL,
  `commandKey` varchar(128) NOT NULL,
  `commandData` mediumtext DEFAULT NULL,
  `status` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_CommandQueue_batchId` (`batchId`),
  CONSTRAINT `FK_CommandQueue_batchId` FOREIGN KEY (`batchId`) REFERENCES `BatchCommandQueue` (`batchId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CommandQueue`
--

LOCK TABLES `CommandQueue` WRITE;
/*!40000 ALTER TABLE `CommandQueue` DISABLE KEYS */;
/*!40000 ALTER TABLE `CommandQueue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATABASECHANGELOG`
--

DROP TABLE IF EXISTS `DATABASECHANGELOG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DATABASECHANGELOG` (
  `ID` varchar(255) NOT NULL,
  `AUTHOR` varchar(255) NOT NULL,
  `FILENAME` varchar(255) NOT NULL,
  `DATEEXECUTED` datetime NOT NULL,
  `ORDEREXECUTED` int(11) NOT NULL,
  `EXECTYPE` varchar(10) NOT NULL,
  `MD5SUM` varchar(35) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `COMMENTS` varchar(255) DEFAULT NULL,
  `TAG` varchar(255) DEFAULT NULL,
  `LIQUIBASE` varchar(20) DEFAULT NULL,
  `CONTEXTS` varchar(255) DEFAULT NULL,
  `LABELS` varchar(255) DEFAULT NULL,
  `DEPLOYMENT_ID` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASECHANGELOG`
--

LOCK TABLES `DATABASECHANGELOG` WRITE;
/*!40000 ALTER TABLE `DATABASECHANGELOG` DISABLE KEYS */;
INSERT INTO `DATABASECHANGELOG` VALUES
('t','auth-team','run/liquibase/changelog/test1.sql','2023-04-21 03:14:31',1,'EXECUTED','8:017393e37477a13009834d75a96ebe1b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.1','auth-team','run/liquibase/changelog/V1.1__drop_user_apps_table.sql','2023-04-21 03:14:31',2,'EXECUTED','8:58c66822f571ee1f4d214ec8d580cf0b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.2','auth-team','run/liquibase/changelog/V1.2__refactor_tables.sql','2023-04-21 03:14:31',3,'EXECUTED','8:12246cd37fc2e25ae4a964f03ee03ab3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.3','auth-team','run/liquibase/changelog/V1.3__create_client_groups_table.sql','2023-04-21 03:14:31',4,'EXECUTED','8:a2ab5b64bdd21cc766480768a15f164c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.4','auth-team','run/liquibase/changelog/V1.4__create_api_authorization_tables.sql','2023-04-21 03:14:31',5,'EXECUTED','8:00406abf59fcd8e05425c81c27459dc3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.5','auth-team','run/liquibase/changelog/V1.5__add_organization_config_column.sql','2023-04-21 03:14:31',6,'EXECUTED','8:863c87805f4caf131672cdca000aade7','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.6','auth-team','run/liquibase/changelog/V1.6__cascade_organization_fk_constraints.sql','2023-04-21 03:14:31',7,'EXECUTED','8:d180c4d175f0d8329847717d2feb2461','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.7','auth-team','run/liquibase/changelog/V1.7__add_unique_const_user_org_table.sql','2023-04-21 03:14:31',8,'EXECUTED','8:28efdb010d3ace2ceeb3019e935d70da','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.8','auth-team','run/liquibase/changelog/V1.8__add_unique_const_client_group_table.sql','2023-04-21 03:14:31',9,'EXECUTED','8:950d2dff2db9a2f8897878337580e188','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('1.9','auth-team','run/liquibase/changelog/V1.9__add_unique_const_role_group_table.sql','2023-04-21 03:14:31',10,'EXECUTED','8:ba6d834bba4c8694f904e43f54c077dd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.0','auth-team','run/liquibase/changelog/V2.0__add_unique_const_resourceserver_clients_table.sql','2023-04-21 03:14:31',11,'EXECUTED','8:58f591f97d393dda0d8d42eb4ab3480d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.1','auth-team','run/liquibase/changelog/V2.1__add_unique_const_user_groups_table.sql','2023-04-21 03:14:31',12,'EXECUTED','8:1e2b6e23c8b2730e6840fcc17bb641e5','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.2','auth-team','run/liquibase/changelog/V2.2__drop_role_column_users_table.sql','2023-04-21 03:14:31',13,'EXECUTED','8:6db570a0da8247625ecab5b69eac68fa','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.3','auth-team','run/liquibase/changelog/V2.3__add_client_id_and_org_usersessions_table.sql','2023-04-21 03:14:31',14,'EXECUTED','8:7df6f267063e34926fcd3931d8462e56','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.4','auth-team','run/liquibase/changelog/V2.4__add_client_id_column_clients_table.sql','2023-04-21 03:14:31',15,'EXECUTED','8:03c696a25c79336ce42ae6b0d159a51c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.5','auth-team','run/liquibase/changelog/V2.5__add_login_page_table.sql','2023-04-21 03:14:31',16,'EXECUTED','8:681f93a1ad6d1079f8f35bfe12414afc','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.6','auth-team','run/liquibase/changelog/V2.6__rename_keyword_to_orgID_organizations_table.sql','2023-04-21 03:14:31',17,'EXECUTED','8:ed02ab55cc29d5e58095a454f4bcda77','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.7','auth-team','run/liquibase/changelog/V2.7__add_expires_column_user_sessions.sql','2023-04-21 03:14:31',18,'EXECUTED','8:63ae4964b9d9e5a7eebd171b6bfe712b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.8','auth-team','run/liquibase/changelog/V2.8__update_event_user_session_cleanup.sql','2023-04-21 03:14:31',19,'EXECUTED','8:399bd725f8a6892a6f0b8618b7f8a3a4','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('2.9','auth-team','run/liquibase/changelog/V2.9__add_errors_table.sql','2023-04-21 03:14:31',20,'EXECUTED','8:da4a5f49b80b3e0a286f293a90b1db26','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.0','auth-team','run/liquibase/changelog/V3.0__add_client_type_lookup_table.sql','2023-04-21 03:14:31',21,'EXECUTED','8:f2b629befe386c0912ab0d68f98d6e70','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.1','auth-team','run/liquibase/changelog/V3.1__add_saml_integrations_table.sql','2023-04-21 03:14:32',22,'EXECUTED','8:683512ff7259a04c9a7cdf79a1239442','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.2','auth-team','run/liquibase/changelog/V3.2__add_identity_provider_strategy_lookup_table.sql','2023-04-21 03:14:32',23,'EXECUTED','8:ae4a378a8cf2def7ec14e4f8973e1a5c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.3','auth-team','run/liquibase/changelog/V3.3__remove_errors_table.sql','2023-04-21 03:14:32',24,'EXECUTED','8:66fb618cf90fda9c9f6915bd37a38f9b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.4','auth-team','run/liquibase/changelog/V3.4__add_authorization_code_table.sql','2023-04-21 03:14:32',25,'EXECUTED','8:4de534263872f648cb121f262655f9b3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.5','auth-team','run/liquibase/changelog/V3.5__add_client_secret_column_to_clients_table.sql','2023-04-21 03:14:32',26,'EXECUTED','8:1c37714ac1f5bdb470443d48dc1916fe','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.6','auth-team','run/liquibase/changelog/V3.6__change_user_token_table_to_refresh_token_table.sql','2023-04-21 03:14:32',27,'EXECUTED','8:76d3566da0705455c229ade6a59cd26f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.7','auth-team','run/liquibase/changelog/V3.7__add_regular_web_oauth_client_type_table.sql','2023-04-21 03:14:32',28,'EXECUTED','8:b5c7000e26fe79dcfbecb5747db38960','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.8','auth-team','run/liquibase/changelog/V3.8__increase_column_size_user_sessions_table.sql','2023-04-21 03:14:32',29,'EXECUTED','8:7abeaef40c242e7eaad3e6a0c30265ac','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('3.9','auth-team','run/liquibase/changelog/V3.9__add_palantir_to_saml_integrations_type_table.sql','2023-04-21 03:14:32',30,'EXECUTED','8:fda6686328098eb0bcee0bac544c6b96','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.0','auth-team','run/liquibase/changelog/V4.0__rename_role_column_user_profiles_table.sql','2023-04-21 03:14:32',31,'EXECUTED','8:ac16b488f4a1c0a0c6ce8605ef0fad90','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.1','auth-team','run/liquibase/changelog/V4.1__rename_organizations_to_tenants.sql','2023-04-21 03:14:32',32,'EXECUTED','8:6af6e82fb1748be9941fa7abf2671512','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.2','auth-team','run/liquibase/changelog/V4.2__add_unique_const_user_profiles_table.sql','2023-04-21 03:14:32',33,'EXECUTED','8:a604556d7d66426399c90dc13724a4b6','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.3','auth-team','run/liquibase/changelog/V4.3__rename_constraints_to_tenants.sql','2023-04-21 03:14:32',34,'EXECUTED','8:7280273427604cbebb84d5c7e0716069','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.4','auth-team','run/liquibase/changelog/V4.4__drop_type_tables.sql','2023-04-21 03:14:32',35,'EXECUTED','8:f6d9d6391811e182b5471df48996f1da','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.5','auth-team','run/liquibase/changelog/V4.5__change_authorization_code_table_client_fk.sql','2023-04-21 03:14:32',36,'EXECUTED','8:292e09b9515f025b7bd9e3fc66d69c46','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.6','auth-team','run/liquibase/changelog/V4.6__change_tenant_user_relation_from_many_to_many_to_one_to_many.sql','2023-04-21 03:14:32',37,'EXECUTED','8:b007b869e75a21a50eefc967e57e23cd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.7','auth-team','run/liquibase/changelog/V4.7__add_unique_index_client_idp_joining_tables.sql','2023-04-21 03:14:32',38,'EXECUTED','8:b20698cbe36cef1e820cb0715b568b11','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.8','auth-team','run/liquibase/changelog/V4.8__create_oidc_session_table.sql','2023-04-21 03:14:32',39,'EXECUTED','8:0f25c0c4dcd6a3e5140487c1f16b11a7','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('4.9','auth-team','run/liquibase/changelog/V4.9__add_details_column_to_authorization_codes_table.sql','2023-04-21 03:14:32',40,'EXECUTED','8:1d18b575192fe2ff78afafabdd51ef4d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.0','auth-team','run/liquibase/changelog/V5.0__add_details_column_to_refresh_tokens_table.sql','2023-04-21 03:14:32',41,'EXECUTED','8:078a28d70ebb1ad2deeb2b3740d9bccd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.1','auth-team','run/liquibase/changelog/V5.1__consolidate_client_types_column.sql','2023-04-21 03:14:32',42,'EXECUTED','8:7ab1e6c701a4e377c83009fc0b746cb8','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.2','auth-team','run/liquibase/changelog/V5.2__create_oidc_access_token_table.sql','2023-04-21 03:14:32',43,'EXECUTED','8:02a62d9189ceeb0f74fd501320fd2638','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.3','auth-team','run/liquibase/changelog/V5.3__remove_user_profile_email_unique_idx.sql','2023-04-21 03:14:32',44,'EXECUTED','8:9b7102853e2d4422208aba7cceb02ac7','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.4','auth-team','run/liquibase/changelog/V5.4__remove_user_profile_groups_column.sql','2023-04-21 03:14:32',45,'EXECUTED','8:949b5e56a646f59e423f4a51c1adeb43','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.5','auth-team','run/liquibase/changelog/V5.5__add_user_columns.sql','2023-04-21 03:14:32',46,'EXECUTED','8:9e299349a22310b1e5b10b44eb1454ce','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.6','auth-team','run/liquibase/changelog/V5.6__remove_user_profiles_upn_column.sql','2023-04-21 03:14:32',47,'EXECUTED','8:236fa21ca8fb62b59aeeb5a8d4d9f618','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.8','auth-team','run/liquibase/changelog/V5.8__rename_fullname_column_in_users_table.sql','2023-04-21 03:14:32',48,'EXECUTED','8:66a5549e0977126e3245ef20e3ceed08','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('5.9','auth-team','run/liquibase/changelog/V5.9__create_client_login_page_table.sql','2023-04-21 03:14:32',49,'EXECUTED','8:867da5e156cd0bcf950546624bb2241a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.0','auth-team','run/liquibase/changelog/V6.0__set_compound_unique_constraint_client_login_page_table.sql','2023-04-21 03:14:32',50,'EXECUTED','8:a7672ee3cb6b90973f1c2880e74240d0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.1','auth-team','run/liquibase/changelog/V6.1__rename_nih_wsfed_to_wsfed.sql','2023-04-21 03:14:32',51,'EXECUTED','8:1f7ac9edf50e1f2799ab36bcaff97d9a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.2','auth-team','run/liquibase/changelog/V6.2__add_grant_id_column_oidc_access_token_table.sql','2023-04-21 03:14:32',52,'EXECUTED','8:4c7ab72e421b3a5055c7c6cfe58ee62a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.3','auth-team','run/liquibase/changelog/V6.3__create_interaction_table.sql','2023-04-21 03:14:32',53,'EXECUTED','8:60d737eda086a3fad6d5a4528a83be3e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.4','auth-team','run/liquibase/changelog/V6.4__add_uid_column_oidc_session_table.sql','2023-04-21 03:14:32',54,'EXECUTED','8:d9602b03a609e5bcad56ff59839a4be8','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.5','auth-team','run/liquibase/changelog/V6.5__add_client_id_column_user_profiles_table.sql','2023-04-21 03:14:32',55,'EXECUTED','8:b27cc2f16af5b54cc8e3402ddf08f6f7','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.6','auth-team','run/liquibase/changelog/V6.6__add_default_id_column_user_groups_table.sql','2023-04-21 03:14:32',56,'EXECUTED','8:97656e386b4a6772e64cc5c3f74eabd3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.7','auth-team','run/liquibase/changelog/V6.7__add_default_id_column_client_groups_table.sql','2023-04-21 03:14:32',57,'EXECUTED','8:1263f7b056247cf4eb7f52dfe3e47cfd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.8','auth-team','run/liquibase/changelog/V6.8__add_default_id_identity_provider_clients_table.sql','2023-04-21 03:14:32',58,'EXECUTED','8:bb411f768ebacba9b0e1958274ccb86e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('6.9','auth-team','run/liquibase/changelog/V6.9__add_provider_column_to_users_table.sql','2023-04-21 03:14:32',59,'EXECUTED','8:1a451b7f93b298683fb7bf47a914991f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.0','auth-team','run/liquibase/changelog/V7.0__add_provider_id_column_user_profiles_table.sql','2023-04-21 03:14:32',60,'EXECUTED','8:9e1c02016b665a606a939ce2f5c4215d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.1','auth-team','run/liquibase/changelog/V7.1__add_client_description_metadata_client_uri_columns.sql','2023-04-21 03:14:32',61,'EXECUTED','8:f658f79d8b6a5168dc127cd3817ff7fa','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.2','auth-team','run/liquibase/changelog/V7.2__add_tenant_description_column_tenant_table.sql','2023-04-21 03:14:32',62,'EXECUTED','8:3b4a7e2041698edf49fcc0b13a7627fb','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.3','auth-team','run/liquibase/changelog/V7.3__add_pk_group_roles_table_for_upsert.sql','2023-04-21 03:14:33',63,'EXECUTED','8:03256d5e8f567aa96dd2ab0fbe9e4971','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.4','auth-team','run/liquibase/changelog/V7.4__add_pk_resource_server_clients_join_table_for_upsert.sql','2023-04-21 03:14:33',64,'EXECUTED','8:d0e899c451c27555c970c9e1bf8cae78','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.5','auth-team','run/liquibase/changelog/V7.5__add_defaults_to_client_table_client_uri_and_description_columns.sql','2023-04-21 03:14:33',65,'EXECUTED','8:a24e226d5da3dc4d675f4e4fc4572fcf','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.6','auth-team','run/liquibase/changelog/V7.6__add_client_id_to_roles_table.sql','2023-04-21 03:14:33',66,'EXECUTED','8:da03a63fed49a3d5f41fc1a8071d97f6','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.7','auth-team','run/liquibase/changelog/V7.7__add_role_permission_table.sql','2023-04-21 03:14:33',67,'EXECUTED','8:53537f98354020b682bedb515657a2b7','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.8','auth-team','run/liquibase/changelog/V7.8__remove_role_fk_from_permissions_table.sql','2023-04-21 03:14:33',68,'EXECUTED','8:542db5155cde0cb08d7a3ea0d5d99cd0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.9','auth-team','run/liquibase/changelog/V7.9__add_client_id_permissions_table.sql','2023-04-21 03:14:33',69,'EXECUTED','8:53c30acd5ef92a4443f09013b1047261','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.10','auth-team','run/liquibase/changelog/V7.10__add_client_permission_table.sql','2023-04-21 03:14:33',70,'EXECUTED','8:a59d5ba8fd72950c2aa7dc540df20773','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.11','auth-team','run/liquibase/changelog/V7.11__add_tenant_id_column_permissions_table.sql','2023-04-21 03:14:33',71,'EXECUTED','8:1f9421ea5bb700a13baacc18d3142705','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.12','auth-team','run/liquibase/changelog/V7.12__add_mfa_type__column_client_identityproviders_table.sql','2023-04-21 03:14:33',72,'EXECUTED','8:02969c1e01bee241afce3be42cb1ad45','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.13','auth-team','run/liquibase/changelog/V7.13__add_mfa_type_column_identityproviders_table.sql','2023-04-21 03:14:33',73,'EXECUTED','8:213c9e819758072226fab60d62ddeac4','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.14','auth-team','run/liquibase/changelog/V7.14__add_otp_secret_strikeCount_lastStrike_lockedOut_columns_users_table.sql','2023-04-21 03:14:33',74,'EXECUTED','8:8296f6b5cb3a4e66c32a310738cf6a60','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.15','auth-team','run/liquibase/changelog/V7.15__unique_permission_name_by_client_instead_of_role_constraint.sql','2023-04-21 03:14:33',75,'EXECUTED','8:d8a030aa6df16ead49e27933eda201bf','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.16','auth-team','run/liquibase/changelog/V7.16__add__sortorder_column_client_identityproviders_table.sql','2023-04-21 03:14:33',76,'EXECUTED','8:df39e3e330009b943ecbe85795dc0d19','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.17','auth-team','run/liquibase/changelog/V7.17__add__sortorder_column_identityproviders_table.sql','2023-04-21 03:14:33',77,'EXECUTED','8:8f90bd14b6a1a63cbc4b56230c261b60','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.18','auth-team','run/liquibase/changelog/V7.18__create_user_trusted_devices_table.sql','2023-04-21 03:14:33',78,'EXECUTED','8:fb3e032fde0f1f6abb4e4d6730c8e32a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.19','auth-team','run/liquibase/changelog/V7.19__create_audit_log_table.sql','2023-04-21 03:14:33',79,'EXECUTED','8:c5147bc0badaa423977bf5a56acc104a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('7.20','auth-team','run/liquibase/changelog/V7.20__add_provider_login_tooltip_column.sql','2023-04-21 03:14:33',80,'EXECUTED','8:04aa5bbf56511c89bfe1056a2a38b2a9','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8','auth-team','run/liquibase/changelog/V8__add_tenant_id_client_id_and_user_id_access_token_table.sql','2023-04-21 03:14:33',81,'EXECUTED','8:4562ce3fe7c11897d4290915ccd2019a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.1','auth-team','run/liquibase/changelog/V8.1__add_tenant_id_authorization_code_table.sql','2023-04-21 03:14:33',82,'EXECUTED','8:ef584a2f058d0b6833fdfa74b026900f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.2','auth-team','run/liquibase/changelog/V8.2__add_tenant_id_refresh_token_table.sql','2023-04-21 03:14:33',83,'EXECUTED','8:fcb46ed024b1ecebd9735aa224331bb8','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.3','auth-team','run/liquibase/changelog/V8.3__add_user_id_wsfed_session_table.sql','2023-04-21 03:14:33',84,'EXECUTED','8:7aa59d78a780546f063a76d5200c3aaf','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.4','auth-team','run/liquibase/changelog/V8.4__drop_user_profiles_table.sql','2023-04-21 03:14:33',85,'EXECUTED','8:a641804cfe3480278473fec573b3a215','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.5','auth-team','run/liquibase/changelog/V8.5__add_unique_const_roles_permissions_table.sql','2023-04-21 03:14:33',86,'EXECUTED','8:b16289287d7e2f4d9a9fe0aa1cafc6a3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.6','auth-team','run/liquibase/changelog/V8.6__add_default_null_grantId_and_userId_columns_openIdconnectaccesstoken_table.sql','2023-04-21 03:14:33',87,'EXECUTED','8:0ee56700281cd4ac19967f6a1af795a3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.7','auth-team','run/liquibase/changelog/V8.7__update_role_name_unique_constraint.sql','2023-04-21 03:14:33',88,'EXECUTED','8:8a2b4604b0e646fac18574f118c62616','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.8','auth-team','run/liquibase/changelog/V8.8__add_user_tenants_joining_table.sql','2023-04-21 03:14:33',89,'EXECUTED','8:31237441b85a23b2c3dd18d65db7faf2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('8.9','auth-team','run/liquibase/changelog/V8.9__change_users_table_from_one_to_many_to_many_to_many.sql','2023-04-21 03:14:33',90,'EXECUTED','8:671e7481152483424ac0a71958a27d9e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.0','auth-team','run/liquibase/changelog/V9.0__add_display_name_column_identity_providers_table.sql','2023-04-21 03:14:33',91,'EXECUTED','8:a3bdc2fa78039997f89f23036eaee903','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.1','auth-team','run/liquibase/changelog/V9.1__add_identity_provider_url_users_table.sql','2023-04-21 03:14:33',92,'EXECUTED','8:1edf17506d687a3face8349e1867fc58','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.2','auth-team','run/liquibase/changelog/V9.2__create_login_event_table.sql','2023-04-21 03:14:33',93,'EXECUTED','8:34e0baa0c56390b007cb80ab0846b654','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.3','auth-team','run/liquibase/changelog/V9.3__add_is_client_role_column_roles_table.sql','2023-04-21 03:14:33',94,'EXECUTED','8:e750ef6fbe03853ffe67add494887362','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.4','auth-team','run/liquibase/changelog/V9.4__add_null_trackingid_login_event_table.sql','2023-04-21 03:14:33',95,'EXECUTED','8:ef5814a8433eb8fca48de266b6384b75','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.5','auth-team','run/liquibase/changelog/V9.5__add_issuer_column_identity_provider_table.sql','2023-04-21 03:14:33',96,'EXECUTED','8:1fc54b190f98d3ca5f3f035c1e4a7cab','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.6','auth-team','run/liquibase/changelog/V9.6__add_tile_config_column_tenant_table.sql','2023-04-21 03:14:33',97,'EXECUTED','8:1f25173351893d6145b19cd80a2f8c02','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.7','auth-team','run/liquibase/changelog/V9.7__add_missing_issuers_users_table.sql','2023-04-21 03:14:33',98,'EXECUTED','8:e6856f0fad7aef9477ad9ab3dcfbf0a5','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.8','auth-team','run/liquibase/changelog/V9.8__add_notification_column_tenant_table.sql','2023-04-21 03:14:33',99,'EXECUTED','8:62b9462e90d8cd63c64b99dfd10072c9','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('9.9','auth-team','run/liquibase/changelog/V9.9__create_open_id_connect_grant_table.sql','2023-04-21 03:14:33',100,'EXECUTED','8:20231c4a419e8421a58f4755b9bef1ee','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10','auth-team','run/liquibase/changelog/V10__remove_clientId_userId_open_id_connect_access_token_table.sql','2023-04-21 03:14:33',101,'EXECUTED','8:17e76004cdf6c7e25eefc1a00ad62e29','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.1','auth-team','run/liquibase/changelog/V10.1__add_settings_column_tenant_table.sql','2023-04-21 03:14:33',102,'EXECUTED','8:2d67ce01fd3eca384787a87c7e6b9545','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.2','auth-team','run/liquibase/changelog/V10.2__rename_tenant_config_column_to_secrets.sql','2023-04-21 03:14:33',103,'EXECUTED','8:ee01c2a9bd1bce71fa8969edd376eea2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.3','auth-team','run/liquibase/changelog/V10.3__add_settings_column_client_table.sql','2023-04-21 03:14:33',104,'EXECUTED','8:53399cc41754acf35178738b344cf94a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.4','auth-team','run/liquibase/changelog/V10.4__remove_not_null_constraint_client_settings_column.sql','2023-04-21 03:14:33',105,'EXECUTED','8:23067c7afa79d503d86a3330d8abd561','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.5','auth-team','run/liquibase/changelog/V10.5__add__login_event_settings_column.sql','2023-04-21 03:14:33',106,'EXECUTED','8:a3932529574d6d8f3cfa26272660fd06','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.6','auth-team','run/liquibase/changelog/V10.6__create_table_email_verification.sql','2023-04-21 03:14:33',107,'EXECUTED','8:4bd25daba1549ccfaffc71162938e200','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.7','auth-team','run/liquibase/changelog/V10.7__add_created_at_timestamp_open_id_connect_grant_model.sql','2023-04-21 03:14:33',108,'EXECUTED','8:8e6bf1f8d4b1bf3518944281fa9cbb93','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.8','auth-team','run/liquibase/changelog/V10.8__create_table_user_alert.sql','2023-04-21 03:14:33',109,'EXECUTED','8:9b280f1a2f4f56589c5352fdd3221cff','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('10.9','auth-team','run/liquibase/changelog/V10.9__add_approver_group_table.sql','2023-04-21 03:14:33',110,'EXECUTED','8:329c04f12b178d6ec751edb122a8bb3b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.0','auth-team','run/liquibase/changelog/V11.0__create_approver_group_user_join_table.sql','2023-04-21 03:14:33',111,'EXECUTED','8:89496b3431f85c08c4fb2b6506b2d717','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.1','auth-team','run/liquibase/changelog/V11.1__create_resource_table.sql','2023-04-21 03:14:33',112,'EXECUTED','8:b0a30f253ccf1ab4ecd5fa89a4b0deb4','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.2','auth-team','run/liquibase/changelog/V11.2__create_approval_workflow_table.sql','2023-04-21 03:14:33',113,'EXECUTED','8:643bb7fb158d0f398fdec4c0681d159e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.3','auth-team','run/liquibase/changelog/V11.3__create_approval_workflow_approver_group_joining_table.sql','2023-04-21 03:14:33',114,'EXECUTED','8:033c8fb4025dc0b8c305ffda52a1e5ba','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.4','auth-team','run/liquibase/changelog/V11.4__create_requestable_access_table.sql','2023-04-21 03:14:33',115,'EXECUTED','8:1bfa5b89fa899d4cace7735bb8f14e0d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.5','auth-team','run/liquibase/changelog/V11.5__create_access_request_table.sql','2023-04-21 03:14:33',116,'EXECUTED','8:996034fd27b5a57c7581531e31f04e03','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.6','auth-team','run/liquibase/changelog/V11.6__create_access_approval_table.sql','2023-04-21 03:14:33',117,'EXECUTED','8:dbc1d493388c8a9a1cd62b682cd7bac6','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.7','auth-team','run/liquibase/changelog/V11.7__add_requested_for_user_id_foreign_key_constraint_access_request_table.sql','2023-04-21 03:14:33',118,'EXECUTED','8:21c74c792dcd5a73a9a66e9717986202','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.8','auth-team','run/liquibase/changelog/V11.8__add_unique_constraint_approver_group_table.sql','2023-04-21 03:14:33',119,'EXECUTED','8:295f347de1451028eb61066dc1f2d754','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('11.9','auth-team','run/liquibase/changelog/V11.9__add_approved_at_column_access_request_table.sql','2023-04-21 03:14:33',120,'EXECUTED','8:735854c126f6792a3d4565c2bb207b83','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.0','auth-team','run/liquibase/changelog/V12.0__add_reviewer_notes_access_approval_table.sql','2023-04-21 03:14:33',121,'EXECUTED','8:7c74b76f5eb529cdac3271876e4f2337','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.1','auth-team','run/liquibase/changelog/V12.1__add_missing_auto_id_column_role_permissions_table.sql','2023-04-21 03:14:33',122,'EXECUTED','8:26079e476b4279cd0fd78dd7aba5b89f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.2','auth-team','run/liquibase/changelog/V12.2__create_client_role_table.sql','2023-04-21 03:14:33',123,'EXECUTED','8:6530298e9042e0cc766d7dbf66d14d0d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.3','auth-team','run/liquibase/changelog/V12.3__remove_bydomain_config.sql','2023-04-21 03:14:33',124,'EXECUTED','8:1ebb07c770e697eddf66511e6d8c55a0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.4','auth-team','run/liquibase/changelog/V12.4__add_picture_column_users_table.sql','2023-04-21 03:14:33',125,'EXECUTED','8:5ceb8bb73c78764f67cab5f81707cd1b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.5','auth-team','run/liquibase/changelog/V12.5__add_unique_constraint_access_approval_table.sql','2023-04-21 03:14:33',126,'EXECUTED','8:f94673d62a62a10c50f1601aa9d7c6f3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.6','auth-team','run/liquibase/changelog/V12.6__remove_status_column_access_approval_table.sql','2023-04-21 03:14:33',127,'EXECUTED','8:f6dfbda5283d5c757fddc29846f630f0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.7','auth-team','run/liquibase/changelog/V12.7__revert_removal_status_column_access_approval_table.sql','2023-04-21 03:14:33',128,'EXECUTED','8:a1a5dc5bfc05164111347cb04eeff7a9','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.8','auth-team','run/liquibase/changelog/V12.8__add_is_email_confirmation_required_column_approval_workflow_table.sql','2023-04-21 03:14:33',129,'EXECUTED','8:d2030728734e1da5bd69d93836815c5d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('12.9','auth-team','run/liquibase/changelog/V12.9__create_data_change_request_table.sql','2023-04-21 03:14:33',130,'EXECUTED','8:608954065a334948c2b26aa7c4c926d1','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.0','auth-team','run/liquibase/changelog/V13.0__add_email_confirmation_expires_in_column_approval_workflow_table.sql','2023-04-21 03:14:33',131,'EXECUTED','8:62a34c0a3bd8ac5ae12118e295d05995','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.1','auth-team','run/liquibase/changelog/V13.1__add_access_request_email_confirmation_table.sql','2023-04-21 03:14:33',132,'EXECUTED','8:da1aa46e8d1b0ea03f3310a8e8e7c527','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.2','auth-team','run/liquibase/changelog/V13.2__update_username_size.sql','2023-04-21 03:14:34',133,'EXECUTED','8:7884b42e654db2f41457e354b2e4257b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.3','auth-team','run/liquibase/changelog/V13.3__change_approval_workflow_approveBy_column_to_approveIn.sql','2023-04-21 03:14:34',134,'EXECUTED','8:136c087f8cc5742f3ef2004ce247d4bf','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.4','auth-team','run/liquibase/changelog/V13.4__add_middle_name_column_users_table.sql','2023-04-21 03:14:34',135,'EXECUTED','8:c7fd6789a03103fa787a88a6100eeb7d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.5','auth-team','run/liquibase/changelog/V13.5__add_name_column_user_table.sql','2023-04-21 03:14:34',136,'EXECUTED','8:88c1552394827760502b3546c7f4b5e1','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.6','auth-team','run/liquibase/changelog/V13.6__create_tenant_error_page_table.sql','2023-04-21 03:14:34',137,'EXECUTED','8:7ff96080d2c2916fac8cb503a5ef4c19','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.7','auth-team','run/liquibase/changelog/V13.7__add_secrets_to_provider_table.sql','2023-04-21 03:14:34',138,'EXECUTED','8:391bb73a7e0d2b9f476422db57e5d669','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.8','auth-team','run/liquibase/changelog/V13.8__add_fk_constraints_client_identity_provider_table.sql','2023-04-21 03:14:34',139,'EXECUTED','8:d80435c4712bc7244afa23288f008351','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('13.9','auth-team','run/liquibase/changelog/V13.9__add_external_groups_and_claims_columns_user_table.sql','2023-04-21 03:14:34',140,'EXECUTED','8:ebe60e4ee4e2c22af18f83b34fc4843f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.0','auth-team','run/liquibase/changelog/V14.0__increase_column_size_users_table_picture_column.sql','2023-04-21 03:14:34',141,'EXECUTED','8:e22b1948f6ac22f8a5d938c48dc96d62','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.1','auth-team','run/liquibase/changelog/V14.1__add_last_login_timestamp_user_table.sql','2023-04-21 03:14:34',142,'EXECUTED','8:640328b0c5ecb2ada3ca7168a66c83b2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.2','auth-team','run/liquibase/changelog/V14.2__add_timestamp_columns_client_login_page_table.sql','2023-04-21 03:14:34',143,'EXECUTED','8:17ad0d61dc16114ec5e9a059881b10e4','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.3','auth-team','run/liquibase/changelog/V14.3__add_updated_at_column_user_table.sql','2023-04-21 03:14:34',144,'EXECUTED','8:c581e791ea29fa683f059b2809d53f84','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.4','auth-team','run/liquibase/changelog/V14.4__add__is_consumable_column_refresh_token_and_authorization_code_tables.sql','2023-04-21 03:14:34',145,'EXECUTED','8:d5d9aa3b940d6abe5ce7e0a56467b3ab','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.5','auth-team','run/liquibase/changelog/V14.5__add_identity_provider_icon_column.sql','2023-04-21 03:14:34',146,'EXECUTED','8:fa322d70d6b5e0c074cf620064c11f12','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.6','auth-team','run/liquibase/changelog/V14.6__add_mfa_settings_column_identity_provider_table.sql','2023-04-21 03:14:34',147,'EXECUTED','8:51aefce067f53f2536e51813053078f4','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.7','auth-team','run/liquibase/changelog/V14.7__add__colum_email_setting.tenant_table.sql','2023-04-21 03:14:34',148,'EXECUTED','8:c58e86eb0c5ec5ba0cc19dd71b35518b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.8','auth-team','run/liquibase/changelog/V14.8__add_amr_column_user_table.sql','2023-04-21 03:14:34',149,'EXECUTED','8:bc4e2316d82adf71b738ee93c10c7c18','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.9','auth-team','run/liquibase/changelog/V14.9__add_column_company_department_user_table.sql','2023-04-21 03:14:34',150,'EXECUTED','8:4a0f218a21d517a868cce7a8659ec307','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.10','auth-team','run/liquibase/changelog/V14.10__add__column_activeX509CertificateFingerprint_tenant_table.sql','2023-04-21 03:14:34',151,'EXECUTED','8:ef1ea4bb25b26e4b3a4fd716c2919d4c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('14.11','auth-team','run/liquibase/changelog/V14.11__refactor_group_role_table_column_names.sql','2023-04-21 03:14:34',152,'EXECUTED','8:7f56b481b64fb36b3b859f836bbc06cb','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.1','auth-team','run/liquibase/changelog/V15.1__add_expirationinminutes_column_datachangerequest_table.sql','2023-04-21 03:14:34',153,'EXECUTED','8:f59d48b938870d4b4149b5457d3f05b8','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.2','auth-team','run/liquibase/changelog/V15.2__add_custom_claims_column_user_table.sql','2023-04-21 03:14:34',154,'EXECUTED','8:eeebb26b8ad98072e44972a6746628e9','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.3','auth-team','run/liquibase/changelog/V15.3__add__column_activeX509CertificateFingerprint_client_table.sql','2023-04-21 03:14:34',155,'EXECUTED','8:a66e88406f9236bccd304320e4b83329','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.4','auth-team','run/liquibase/changelog/V15.4__add_createdAt_and_updatedAt_columns_tenant_table.sql','2023-04-21 03:14:34',156,'EXECUTED','8:28ff0176f3362ae3c6185ebe61a98ff3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.5','auth-team','run/liquibase/changelog/V15.5__add_nickname_column_user_entity.sql','2023-04-21 03:14:34',157,'EXECUTED','8:50c3ff0eae1c1d1e583f8760db006a0e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.6','auth-team','run/liquibase/changelog/V15.6__add_created_by_user_id_and_owner_user_id_columns_tenant_table.sql','2023-04-21 03:14:34',158,'EXECUTED','8:f9bfd98f360cd4dd5080c31abe360dbd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.7','auth-team','run/liquibase/changelog/V15.7__create_openid_connect_device_code_table.sql','2023-04-21 03:14:34',159,'EXECUTED','8:b62be4cb39c97cc1d86f3ebf649e6e67','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.8','auth-team','run/liquibase/changelog/V15.8__add_customizable_user_properties_user_tenant_table.sql','2023-04-21 03:14:34',160,'EXECUTED','8:c9ee49f869cf51f24d4b4af14146e0b2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.9','auth-team','run/liquibase/changelog/V15.9__create_user_login_token_data_table.sql','2023-04-21 03:14:34',161,'EXECUTED','8:6ee8b4296b67e07eb41832f4c84b8c50','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.10','auth-team','run/liquibase/changelog/V15.10__add_store_tokens_column_client_identityproviders_table.sql','2023-04-21 03:14:34',162,'EXECUTED','8:c42d4cf64bbe347b0ca4f1bd321e6164','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('15.11','auth-team','run/liquibase/changelog/V15.11__add_grant_id_to_sessions_table.sql','2023-04-21 03:14:34',163,'EXECUTED','8:0625a11f46b5f9da3c7bd1c6921ed3e5','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.1','auth-team','run/liquibase/changelog/V16.1__add_grant_id_to_sessions_table.sql','2023-04-21 03:14:34',164,'EXECUTED','8:4e84a73645053b82af74a0a9ded1e929','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.2','auth-team','run/liquibase/changelog/V16.2__add_timestamp__to_sessions_table.sql','2023-04-21 03:14:34',165,'EXECUTED','8:af2079f2eb769e641229ad3ac2178487','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.3','auth-team','run/liquibase/changelog/V16.3__add_expire_columns_to_clients_table.sql','2023-04-21 03:14:34',166,'EXECUTED','8:8e245374eb88f77e01f0a052120dd2f9','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.4','auth-team','run/liquibase/changelog/V16.4__add_ externalSecretId_to_dentity_provider_table.sql','2023-04-21 03:14:34',167,'EXECUTED','8:53a6d32b1ee926bc0372ace88acd79d0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.5','auth-team','run/liquibase/changelog/V16.5__add_is_blocked_column_user_table.sql','2023-04-21 03:14:34',168,'EXECUTED','8:c2005f7e70d3527fbd93a7e53e10a85d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.6','auth-team','run/liquibase/changelog/V16.6__change_columns_names_and_add_notifiedDate_to_clients_table.sql','2023-04-21 03:14:34',169,'EXECUTED','8:db79cb9ff58f0df8707c322e5ae02341','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.7','auth-team','run/liquibase/changelog/V16.7__add_visibility_column_tenant_entity.sql','2023-04-21 03:14:34',170,'EXECUTED','8:2cf8cfdfb811a8049753413802b5e4b2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.8','auth-team','run/liquibase/changelog/V16.8__fix_character_encoding_user_table.sql','2023-04-21 03:14:34',171,'EXECUTED','8:8e1644bf4c5196cad8709999a755bb00','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('16.9','auth-team','run/liquibase/changelog/V16.9__update_default_character_encoding_user_tenant_table.sql','2023-04-21 03:14:34',172,'EXECUTED','8:45d217b5b6e18cf110bf88c30b6f7fbb','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.1','auth-team','run/liquibase/changelog/V17.1__update_character_set_user_alert_table_email_column.sql','2023-04-21 03:14:34',173,'EXECUTED','8:627240a2e73ff2148a644ba885b03702','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.2','auth-team','run/liquibase/changelog/V17.2__add_is_shareable_column_identity_provider_table.sql','2023-04-21 03:14:34',174,'EXECUTED','8:2a2902c2f2e52f6a02fb84f13e2e4e3e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.3','auth-team','run/liquibase/changelog/V17.3__add_identity_provider_id_column_wsfederation_user_sessions_table.sql','2023-04-21 03:14:34',175,'EXECUTED','8:49c82c40b8c2fd3ebc134a581b2559e9','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.4','auth-team','run/liquibase/changelog/V17.4__create_user_session_table.sql','2023-04-21 03:14:34',176,'EXECUTED','8:281591b08a8772b6ad25b916e855ff4b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.5','auth-team','run/liquibase/changelog/V17.5__add_unique_const_title_tenant_table.sql','2023-04-21 03:14:34',177,'EXECUTED','8:d8df12d24fb988652f6942f40c73cd07','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.6','auth-team','run/liquibase/changelog/V17.6__create_namespace_table.sql','2023-04-21 03:14:34',178,'EXECUTED','8:4edaf18f9a9dd56c45361f2d7bd95327','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.7','auth-team','run/liquibase/changelog/V17.7__add_password_hash_column_user_table.sql','2023-04-21 03:14:34',179,'EXECUTED','8:1d5e0ec893f87bff502806a3a1ed9eb2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.8','auth-team','run/liquibase/changelog/V17.8__add_namespace_columns_on_roles_groups.sql','2023-04-21 03:14:34',180,'EXECUTED','8:d4b19988ecfe97265f624172c3a4a334','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.9','auth-team','run/liquibase/changelog/V17.9__update_namespace_table_parent_constraint.sql','2023-04-21 03:14:34',181,'EXECUTED','8:8ccca4f9cd08a38588b348ea6b675d86','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.10','auth-team','run/liquibase/changelog/V17.10__unique_added_on_group_and_role_table.sql','2023-04-21 03:14:34',182,'EXECUTED','8:aade5ad4351de86cd3f981df38fd4042','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.11','auth-team','run/liquibase/changelog/V17.11__remove_unique_keys_wihout_namespace.sql','2023-04-21 03:14:34',183,'EXECUTED','8:0912545084f45499d02d81af7dae34a3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.12','auth-team','run/liquibase/changelog/V17.12__create_command_queue_table.sql','2023-04-21 03:14:34',184,'EXECUTED','8:3fc787d7bce04fb15aa810cded960994','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.13','auth-team','run/liquibase/changelog/V17.13__add_missing_indices_oidc_tables.sql','2023-04-21 03:14:34',185,'EXECUTED','8:64b134ec05ac414a1d66109a0a5dc830','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.14','auth-team','run/liquibase/changelog/V17.14__add_created_at_column_oidc_entity_tables.sql','2023-04-21 03:14:34',186,'EXECUTED','8:73ab44573fa767ed98ece4eb15552f41','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.15','auth-team','run/liquibase/changelog/V17.15__create_batch_command_queue_table.sql','2023-04-21 03:14:34',187,'EXECUTED','8:c6f7c86e8b71d20c7d63a12c4f49cc2a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.16','auth-team','run/liquibase/changelog/V17.16__create_resource_server_permission_table.sql','2023-04-21 03:14:34',188,'EXECUTED','8:e1159a2861c6817bb604de13639ca0cb','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.17','auth-team','run/liquibase/changelog/V17.17__create_resource_server_permission_to_role_join_table.sql','2023-04-21 03:14:34',189,'EXECUTED','8:6562b68a5df0ea660daaeb33c0ca3e31','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.18','auth-team','run/liquibase/changelog/V17.18__update_naming_conventions_for_permission_table_constraints.sql','2023-04-21 03:14:34',190,'EXECUTED','8:19313353e26f59560faec4a6655ff40e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('17.19','auth-team','run/liquibase/changelog/V17.19__create_access_role_table.sql','2023-04-21 03:14:34',191,'EXECUTED','8:84d36f1233790c9d3cbe2772cc379a1f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.1','auth-team','run/liquibase/changelog/V18.1__rename_client_role_table_to_client_access_role.sql','2023-04-21 03:14:34',192,'EXECUTED','8:9dbb2f54e3312d2e8c01022a48a27d94','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.2','auth-team','run/liquibase/changelog/V18.2__create_access_role_resource_server_permission_join_table.sql','2023-04-21 03:14:34',193,'EXECUTED','8:1f1816f03260ccd92aa8362d1a765bf0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.3','auth-team','run/liquibase/changelog/V18.3__create_access_role_client_permission_join_table.sql','2023-04-21 03:14:34',194,'EXECUTED','8:df5c53bd77416b2015ebe8a4a6bf19c3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.4','auth-team','run/liquibase/changelog/V18.4__add_namespace_id_column_access_role_table.sql','2023-04-21 03:14:34',195,'EXECUTED','8:79368cdcc1bffa4ab00c34f11bcfc566','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.5','auth-team','run/liquibase/changelog/V18.5__create_access_role_group_join_table.sql','2023-04-21 03:14:34',196,'EXECUTED','8:15995b1bdbabde4e4f38d1abd7c41c16','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.6','auth-team','run/liquibase/changelog/V18.6__create_user_push_mfa_authentication_table.sql','2023-04-21 03:14:34',197,'EXECUTED','8:0697fbe28be42cafe0683e261795fd13','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.7','auth-team','run/liquibase/changelog/V18.7__add_details_column_open_id_connect_grant_table.sql','2023-04-21 03:14:34',198,'EXECUTED','8:127dc133b469236db5f0be97e1ccc655','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.8','auth-team','run/liquibase/changelog/V18.8__create_oidc_session_metadata_table.sql','2023-04-21 03:14:34',199,'EXECUTED','8:604f1064ee8deafcffb85694c10c988a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.9','auth-team','run/liquibase/changelog/V18.9__create_key_manager_table.sql','2023-04-21 03:14:34',200,'EXECUTED','8:37592413af758e978a1cc0da0295c34d','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.10','auth-team','run/liquibase/changelog/V18.10__create_user_secret_manager_table.sql','2023-04-21 03:14:34',201,'EXECUTED','8:f9092301f3c1eff7af810379bc83c719','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('18.11','auth-team','run/liquibase/changelog/V18.11__alter_open_id_connect_device_code_table_grant_id_column_nullable.sql','2023-04-21 03:14:34',202,'EXECUTED','8:65f4562254a072f7bbbc92f46f5d4654','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.1','auth-team','run/liquibase/changelog/V19.1__alter_requestable_access.sql','2023-04-21 03:14:35',203,'EXECUTED','8:3704575a1474c4249911fc63852b2e53','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.2','auth-team','run/liquibase/changelog/V19.2__drop_resource_table.sql','2023-04-21 03:14:35',204,'EXECUTED','8:9f2a1c709eeb2f24c0f19ac64cb3e335','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.3','auth-team','run/liquibase/changelog/V19.3__update_secret_manager_secret_size.sql','2023-04-21 03:14:35',205,'EXECUTED','8:fa92f372ce49a4587fa70b5c7865e749','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.4','auth-team','run/liquibase/changelog/V19.4__add_user_linked_identity_table.sql','2023-04-21 03:14:35',206,'EXECUTED','8:c2a4632462d1e467bf1aa0a6886d9c8b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.5','auth-team','run/liquibase/changelog/V19.5__add_user_id_to_sessions_table.sql','2023-04-21 03:14:35',207,'EXECUTED','8:60d2aecd4a2643c1e1e5f9fc74802bfc','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.6','auth-team','run/liquibase/changelog/V19.6__add_supportsAccountLinking_to_client_table.sql','2023-04-21 03:14:35',208,'EXECUTED','8:faba30f29b703398838400e3245b902b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.7','auth-team','run/liquibase/changelog/V19.7__alter_approvalworkflowId_requestableaccess_table.sql','2023-04-21 03:14:35',209,'EXECUTED','8:3a66c35d9f22ec5e7f2afe8313d2d610','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.8','auth-team','run/liquibase/changelog/V19.8__drop_client_roles_to_resource_server_permissions_join_table.sql','2023-04-21 03:14:35',210,'EXECUTED','8:ec3e8026d2cc6936fb408be5db74708e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.9','auth-team','run/liquibase/changelog/V19.9__add_member_column_userGroups_table.sql','2023-04-21 03:14:35',211,'EXECUTED','8:e10da84d77528888d24954c01f680d3b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('19.10','auth-team','run/liquibase/changelog/V19.10__add_resourceServerId_column_accessRole_table.sql','2023-04-21 03:14:35',212,'EXECUTED','8:7a2ad013862415abcb4831c49a066780','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.1','auth-team','run/liquibase/changelog/V20.1__create_umrs_role_table.sql','2023-04-21 03:14:35',213,'EXECUTED','8:ea8b2b70433df3c51005ac1523000f4f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.2','auth-team','run/liquibase/changelog/V20.2__alter_requestable_access_add_umrs_role.sql','2023-04-21 03:14:35',214,'EXECUTED','8:fab110f9a57d9ebc5270f49ee7495d2e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.3','auth-team','run/liquibase/changelog/V20.3__create_umrs_user_role_table.sql','2023-04-21 03:14:35',215,'EXECUTED','8:b6c69968c8fecfe194e56ed4afb79bfd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.4','auth-team','run/liquibase/changelog/V20.4__remove_client_access_role_join_table.sql','2023-04-21 03:14:35',216,'EXECUTED','8:166049358c6ba51eb79ec4b6bb433792','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.5','auth-team','run/liquibase/changelog/V20.5__alter_accessRole_unq_key.sql','2023-04-21 03:14:35',217,'EXECUTED','8:06ae705c2afde757947396769f8d1210','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.6','auth-team','run/liquibase/changelog/V20.6__alter_tenant_add_column_archive.sql','2023-04-21 03:14:35',218,'EXECUTED','8:f0ceee903e9b997fde93d622a619705e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.7','auth-team','run/liquibase/changelog/V20.7__add_is_trusted_column_identity_provider_table.sql','2023-04-21 03:14:35',219,'EXECUTED','8:04c6557d5f84ec1a4148c5d07d40645c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.8','auth-team','run/liquibase/changelog/V20.8__add_index_name_column_in_groups_table.sql','2023-04-21 03:14:35',220,'EXECUTED','8:7f2322e8af37a87642434760774c5d05','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.9','auth-team','run/liquibase/changelog/V20.9__add_latest_login_column_tenant_table.sql','2023-04-21 03:14:35',221,'EXECUTED','8:70078dba8adf9a96894aff1636452196','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.10','auth-team','run/liquibase/changelog/V20.10__alter_umrs_role_user_add_expiration.sql','2023-04-21 03:14:35',222,'EXECUTED','8:91a08cb2c63723ccbd3c3b060facfb0f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.11','auth-team','run/liquibase/changelog/V20.11__create_trusted_tenant_table.sql','2023-04-21 03:14:35',223,'EXECUTED','8:1bc5d3530599d92b08f1be85ed9f9fe3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.12','auth-team','run/liquibase/changelog/V20.12__fix_unique_constraint_trusted_tenant_table.sql','2023-04-21 03:14:35',224,'EXECUTED','8:4af3c8d9f36821754f358c47e06402e3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.13','auth-team','run/liquibase/changelog/V20.13__add_archived_date_column_tenant_table.sql','2023-04-21 03:14:35',225,'EXECUTED','8:772e9bac613ec9ea8798c18130dba988','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.14','auth-team','run/liquibase/changelog/V20.14__umrs_role_add_object_identifier.sql','2023-04-21 03:14:35',226,'EXECUTED','8:a595d293c2fa5329ccedbe82efb60174','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.15','auth-team','run/liquibase/changelog/V20.15__add_tenant_status_column_tenant_table.sql','2023-04-21 03:14:35',227,'EXECUTED','8:67ab3008785f51842edd148cff15f7cc','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.16','auth-team','run/liquibase/changelog/V20.16__rename_saml_integrations_table.sql','2023-04-21 03:14:35',228,'EXECUTED','8:61639dc7b507f1915ba55915d398d97c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.17','auth-team','run/liquibase/changelog/V20.17__add_custom_jobs_table.sql','2023-04-21 03:14:35',229,'EXECUTED','8:5cffbaa64c5b32543b1d3e44ae1b7729','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.18','auth-team','run/liquibase/changelog/V20.18__add_email_template_table.sql','2023-04-21 03:14:35',230,'EXECUTED','8:fed1503b3937e661dd036706bba8c0a8','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.19','auth-team','run/liquibase/changelog/V20.19__add_job_log_table.sql','2023-04-21 03:14:35',231,'EXECUTED','8:39ef8f0c9b8d35dfeb1a0287a8facd7f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.20','auth-team','run/liquibase/changelog/V20.20__alter_umrs_role_table_add_description_and_url.sql','2023-04-21 03:14:35',232,'EXECUTED','8:a56e0df05490217d1b7b8c1a6773a93c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.21','auth-team','run/liquibase/changelog/V20.21__add_group_invitation_table.sql','2023-04-21 03:14:35',233,'EXECUTED','8:912ecd682da1bdb6be0d4a2ff3ef71b2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.22','auth-team','run/liquibase/changelog/V20.22__create_umrs_group_role_table.sql','2023-04-21 03:14:35',234,'EXECUTED','8:adf0d4ec3bcfebcc9430f4dfacd6e266','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.23','auth-team','run/liquibase/changelog/V20.23__add_enableEmail_groupInvitation_table.sql','2023-04-21 03:14:35',235,'EXECUTED','8:5731e1252ec4064f39447fd9641075de','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('20.24','auth-team','run/liquibase/changelog/V20.24__drop_data_change_request_table.sql','2023-04-21 03:14:35',236,'EXECUTED','8:80a0c8d8577fdf6dfdd4eab16ef0d6ef','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.1','auth-team','run/liquibase/changelog/V21.1__add_shouldUsePreviouslySelectedConnection_column_client_table.sql','2023-04-21 03:14:35',237,'EXECUTED','8:589e30ed871618d14b56f8122ee7c985','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.2','auth-team','run/liquibase/changelog/V21.2__alter_access_request_add_confirmation_token_column.sql','2023-04-21 03:14:35',238,'EXECUTED','8:0e0045962b14a69ad67facabf1db45f0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.3','auth-team','run/liquibase/changelog/V21.3__alter_requestable_access_add_email_template_columns.sql','2023-04-21 03:14:35',239,'EXECUTED','8:e7bbdc2624714e2b1c5e97ca6c24e87e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.4','auth-team','run/liquibase/changelog/V21.4__alter_approval_workflow_add_email_template_columns.sql','2023-04-21 03:14:35',240,'EXECUTED','8:16980c72524d127e63592c063689b721','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.5','auth-team','run/liquibase/changelog/V21.5__create_default_client_user_group_join_table.sql','2023-04-21 03:14:35',241,'EXECUTED','8:5418c39bd89a827d7525ebbcbec16ed0','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.6','auth-team','run/liquibase/changelog/V21.6__add_saml_cert_notification_to_tenant.sql','2023-04-21 03:14:35',242,'EXECUTED','8:cd9e6d257d58f97e675db9235fafb2e8','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.7','auth-team','run/liquibase/changelog/V21.7__add_cc_bcc_to_emailTemplate_table.sql','2023-04-21 03:14:35',243,'EXECUTED','8:9b66d8901afc5bb8dce06404acdf31f3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.8','auth-team','run/liquibase/changelog/V21.8__alter_email_templates_add_template_category_column.sql','2023-04-21 03:14:35',244,'EXECUTED','8:8bbc3c0c16465b3ca408605b179dd599','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.9','auth-team','run/liquibase/changelog/V21.9__add_confirmationTemplateId_groupInvitation_table.sql','2023-04-21 03:14:35',245,'EXECUTED','8:40614cca622abd423a8269359ce571ff','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.10','auth-team','run/liquibase/changelog/V21.10__add_html_template_table.sql','2023-04-21 03:14:35',246,'EXECUTED','8:77c9071f204b3f30232d46bda47fc2f1','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.11','auth-team','run/liquibase/changelog/V21.11__add_unique_constraint_html_template_table.sql','2023-04-21 03:14:35',247,'EXECUTED','8:7d482472ff2d978d1c8f7df972889535','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.12','auth-team','run/liquibase/changelog/V21.12__alter_secret_manager_table.sql','2023-04-21 03:14:35',248,'EXECUTED','8:ad1e6bccbd185749e9c2c70e8a4b035b','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.13','auth-team','run/liquibase/changelog/V21.13__add_temp_secrets_migration_table.sql','2023-04-21 03:14:35',249,'EXECUTED','8:3c1306cc50372e45b9b5a1b902052e91','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.14','auth-team','run/liquibase/changelog/V21.14__add_unique_name_index_secretManager_table.sql','2023-04-21 03:14:35',250,'EXECUTED','8:a3d7476d99d874fcabfbeca0fa3c914a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.15','auth-team','run/liquibase/changelog/V21.15__create_landing_page_template_table.sql','2023-04-21 03:14:35',251,'EXECUTED','8:c0c52149b581c32b88117fbd26a52cd3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.16','auth-team','run/liquibase/changelog/V21.16__add_user_status_column.sql','2023-04-21 03:14:35',252,'EXECUTED','8:6d9d15913f4d9c53efcea62d22c1fca2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.17','auth-team','run/liquibase/changelog/V21.17__update_email_template_labels.sql','2023-04-21 03:14:35',253,'EXECUTED','8:d4ba42948afb5c13f72585a43eece2dd','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.18','auth-team','run/liquibase/changelog/V21.18__add_universal_session_table.sql','2023-04-21 03:14:35',254,'EXECUTED','8:e4ed3142eafa8258929aeaf1b061652e','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.19','auth-team','run/liquibase/changelog/V21.19__alter_secret_manager_table_lifetime.sql','2023-04-21 03:14:35',255,'EXECUTED','8:7feb996baf4107393cd493d79872f034','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.20','auth-team','run/liquibase/changelog/V21.20__add_config_landing_page_template_table.sql','2023-04-21 03:14:35',256,'EXECUTED','8:41b90cfc09c99b02e8ef5de54e3382c1','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.21','auth-team','run/liquibase/changelog/V21.21__add_notification_expring_data_tenant_table.sql','2023-04-21 03:14:35',257,'EXECUTED','8:00dee61a7e078ed1669d0dfb5b6ac458','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.22','auth-team','run/liquibase/changelog/V21.22__add_cookie_consent_expiry_tenant_table.sql','2023-04-21 03:14:35',258,'EXECUTED','8:74cc76593f4d0456d2f53dbb20f0129f','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('21.23','auth-team','run/liquibase/changelog/V21.23__alter_landing_page_template_table.sql','2023-04-21 03:14:35',259,'EXECUTED','8:0f381fba54b75d7bd9aeb3c9800f58f3','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.1','auth-team','run/liquibase/changelog/V22.1__allow_tenant_settings_to_be_null.sql','2023-04-21 03:14:35',260,'EXECUTED','8:35d0f93ee89ce704c77d534b53419eef','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.2','auth-team','run/liquibase/changelog/V22.2__add_expiryDate_to_userGroups_table.sql','2023-04-21 03:14:35',261,'EXECUTED','8:aaeb4a9f983baba06ab626ffa1ca8bb4','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.3','auth-team','run/liquibase/changelog/V22.3__add_related_columns_to_login_events_table.sql','2023-04-21 03:14:35',262,'EXECUTED','8:8443994a2701f489a8f0fdd9445f846c','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.4','auth-team','run/liquibase/changelog/V22.4__updated_related_colums_in_login_events_table.sql','2023-04-21 03:14:35',263,'EXECUTED','8:e7e96451796ee5293c1324a558b74d81','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.5','auth-team','run/liquibase/changelog/V22.5__add_command_data_in_BatchCommandQueue.sql','2023-04-21 03:14:35',264,'EXECUTED','8:4bc33215a3d3bc34b988c3360666fb1a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.6','auth-team','run/liquibase/changelog/V22.6__add_custom_error_settings_clients_table.sql','2023-04-21 03:14:35',265,'EXECUTED','8:54a586b6b627b79fa31c1f2651b1efb2','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.7','auth-team','run/liquibase/changelog/V22.7__create_permission_secretManager_table.sql','2023-04-21 03:14:35',266,'EXECUTED','8:fa7871370a6b8e22f5b4aabb29a3f9af','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.8','auth-team','run/liquibase/changelog/V22.8__add_missing_pk.sql','2023-04-21 03:14:35',267,'EXECUTED','8:41b3dce2e23b52c71ef50f1931650a81','sql','',NULL,'4.20.0',NULL,NULL,'2046871113'),
('22.9','auth-team','run/liquibase/changelog/V22.9__add_webauth_authentication table.sql','2023-04-21 03:14:35',268,'EXECUTED','8:3150e1dc4c7ea82383abf7f8d46b433a','sql','',NULL,'4.20.0',NULL,NULL,'2046871113');
/*!40000 ALTER TABLE `DATABASECHANGELOG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DATABASECHANGELOGLOCK`
--

DROP TABLE IF EXISTS `DATABASECHANGELOGLOCK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DATABASECHANGELOGLOCK` (
  `ID` int(11) NOT NULL,
  `LOCKED` bit(1) NOT NULL,
  `LOCKGRANTED` datetime DEFAULT NULL,
  `LOCKEDBY` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DATABASECHANGELOGLOCK`
--

LOCK TABLES `DATABASECHANGELOGLOCK` WRITE;
/*!40000 ALTER TABLE `DATABASECHANGELOGLOCK` DISABLE KEYS */;
INSERT INTO `DATABASECHANGELOGLOCK` VALUES
(1,'\0',NULL,NULL);
/*!40000 ALTER TABLE `DATABASECHANGELOGLOCK` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DefaultClientUserGroup`
--

DROP TABLE IF EXISTS `DefaultClientUserGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DefaultClientUserGroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(3) NOT NULL,
  `clientId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_DefaultClientUserGroup_clientId_groupId` (`groupId`,`clientId`),
  KEY `FK_DefaultClientUserGroup_clientId` (`clientId`),
  CONSTRAINT `FK_DefaultClientUserGroup_clientId` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_DefaultClientUserGroup_groupId` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DefaultClientUserGroup`
--

LOCK TABLES `DefaultClientUserGroup` WRITE;
/*!40000 ALTER TABLE `DefaultClientUserGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `DefaultClientUserGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmailTemplate`
--

DROP TABLE IF EXISTS `EmailTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmailTemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantId` int(11) NOT NULL,
  `messageTemplate` text DEFAULT NULL,
  `messageSubject` varchar(1024) DEFAULT NULL,
  `messageFrom` varchar(512) DEFAULT NULL,
  `name` varchar(512) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `cc` varchar(512) DEFAULT NULL,
  `bcc` varchar(512) DEFAULT NULL,
  `categoryLabel` varchar(255) DEFAULT NULL,
  `isSystemTemplate` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmailTemplate`
--

LOCK TABLES `EmailTemplate` WRITE;
/*!40000 ALTER TABLE `EmailTemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmailTemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmailVerification`
--

DROP TABLE IF EXISTS `EmailVerification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmailVerification` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `emailToken` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `identityIssuer` varchar(255) DEFAULT NULL,
  `redirectUri` varchar(510) NOT NULL,
  `expires` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Users_email_identityIssuer` (`identityIssuer`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmailVerification`
--

LOCK TABLES `EmailVerification` WRITE;
/*!40000 ALTER TABLE `EmailVerification` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmailVerification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GroupAccessRole`
--

DROP TABLE IF EXISTS `GroupAccessRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupAccessRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(3) NOT NULL,
  `accessRoleId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_GroupAccessRole_groupId_accessRoleId` (`groupId`,`accessRoleId`),
  KEY `FK_GroupAccessRole_accessRoleId` (`accessRoleId`),
  CONSTRAINT `FK_GroupAccessRole_accessRoleId` FOREIGN KEY (`accessRoleId`) REFERENCES `AccessRole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_GroupAccessRole_groupId` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GroupAccessRole`
--

LOCK TABLES `GroupAccessRole` WRITE;
/*!40000 ALTER TABLE `GroupAccessRole` DISABLE KEYS */;
/*!40000 ALTER TABLE `GroupAccessRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GroupInvitation`
--

DROP TABLE IF EXISTS `GroupInvitation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupInvitation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `groupId` int(11) NOT NULL,
  `identityIssuer` varchar(1024) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(255) NOT NULL,
  `statusDetails` varchar(1024) DEFAULT NULL,
  `tenantId` int(11) NOT NULL,
  `requestedByUserId` int(11) NOT NULL,
  `emailTemplateId` int(11) DEFAULT NULL,
  `confirmationRequired` tinyint(1) NOT NULL DEFAULT 0,
  `confirmationToken` varchar(255) NOT NULL,
  `expirationInMinutes` int(11) DEFAULT NULL,
  `redirectUri` varchar(510) NOT NULL,
  `enableEmail` tinyint(1) NOT NULL DEFAULT 0,
  `confirmationTemplateId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_GroupInvitation_groupId` (`groupId`),
  KEY `FK_GroupInvitation_requestedByUserId` (`requestedByUserId`),
  KEY `FK_GroupInvitation_tenantId` (`tenantId`),
  CONSTRAINT `FK_GroupInvitation_groupId` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_GroupInvitation_requestedByUserId` FOREIGN KEY (`requestedByUserId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_GroupInvitation_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GroupInvitation`
--

LOCK TABLES `GroupInvitation` WRITE;
/*!40000 ALTER TABLE `GroupInvitation` DISABLE KEYS */;
/*!40000 ALTER TABLE `GroupInvitation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GroupRole`
--

DROP TABLE IF EXISTS `GroupRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupId` int(11) NOT NULL,
  `roleId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roleID_groupID_const_UNIQUE` (`roleId`,`groupId`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `FK_GroupRole_groupId` (`groupId`),
  CONSTRAINT `FK_GroupRole_groupId` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_GroupRole_roleId` FOREIGN KEY (`roleId`) REFERENCES `Role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GroupRole`
--

LOCK TABLES `GroupRole` WRITE;
/*!40000 ALTER TABLE `GroupRole` DISABLE KEYS */;
/*!40000 ALTER TABLE `GroupRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Groups`
--

DROP TABLE IF EXISTS `Groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Groups` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `tenantID` int(3) NOT NULL,
  `description` text DEFAULT NULL,
  `namespaceId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Groups_Name_TenantID_NamespaceId` (`name`,`tenantID`,`namespaceId`),
  KEY `groupconst` (`tenantID`),
  KEY `FK_Groups_namespaceId` (`namespaceId`),
  KEY `IX_Groups_name` (`name`),
  CONSTRAINT `FK_Groups_namespaceId` FOREIGN KEY (`namespaceId`) REFERENCES `Namespace` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `groupconst` FOREIGN KEY (`tenantID`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Groups`
--

LOCK TABLES `Groups` WRITE;
/*!40000 ALTER TABLE `Groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `Groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HtmlTemplate`
--

DROP TABLE IF EXISTS `HtmlTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `HtmlTemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantId` int(11) NOT NULL,
  `template` text DEFAULT NULL,
  `name` varchar(512) DEFAULT NULL,
  `type` varchar(512) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_HtmlTemplate_name_tenantId` (`name`,`tenantId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HtmlTemplate`
--

LOCK TABLES `HtmlTemplate` WRITE;
/*!40000 ALTER TABLE `HtmlTemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `HtmlTemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IdentityProvider`
--

DROP TABLE IF EXISTS `IdentityProvider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IdentityProvider` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `displayName` varchar(255) DEFAULT NULL,
  `tenantId` int(3) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  `type` varchar(255) NOT NULL,
  `mfaType` varchar(32) DEFAULT NULL,
  `mfaSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`mfaSettings`)),
  `icon` mediumtext DEFAULT NULL,
  `sortOrder` int(2) DEFAULT NULL,
  `verifyEmail` tinyint(1) DEFAULT NULL,
  `loginTooltip` varchar(255) DEFAULT NULL,
  `issuer` varchar(255) NOT NULL,
  `userAlertSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`userAlertSettings`)),
  `secrets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`secrets`)),
  `externalSecretId` varchar(255) DEFAULT NULL,
  `isShareable` tinyint(1) DEFAULT NULL,
  `isTrusted` tinyint(1) DEFAULT NULL,
  `notifiedSamlCertExpiration` tinyint(1) NOT NULL DEFAULT 0,
  `notifiedSamlCertExpirationDate` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_IdentityProvider_name_tenantId` (`name`,`tenantId`),
  KEY `IX_IdentityProvider_tenantId` (`tenantId`),
  CONSTRAINT `FK_IdentityProvider_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IdentityProvider`
--

LOCK TABLES `IdentityProvider` WRITE;
/*!40000 ALTER TABLE `IdentityProvider` DISABLE KEYS */;
/*!40000 ALTER TABLE `IdentityProvider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Interaction`
--

DROP TABLE IF EXISTS `Interaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Interaction` (
  `interactionId` varchar(255) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`interactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Interaction`
--

LOCK TABLES `Interaction` WRITE;
/*!40000 ALTER TABLE `Interaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `Interaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Job`
--

DROP TABLE IF EXISTS `Job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(512) DEFAULT NULL,
  `jobType` varchar(512) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `cron` varchar(512) DEFAULT NULL,
  `tenantId` int(11) NOT NULL,
  `customScript` text DEFAULT NULL,
  `customOptions` text DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 0,
  `latestStatus` varchar(512) DEFAULT NULL,
  `createdByUserId` int(11) NOT NULL,
  `jobLogType` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`jobLogType`)),
  `createdAt` datetime DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `nextRunSchedule` DATETIME,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Job`
--

LOCK TABLES `Job` WRITE;
/*!40000 ALTER TABLE `Job` DISABLE KEYS */;
/*!40000 ALTER TABLE `Job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `JobLog`
--

DROP TABLE IF EXISTS `JobLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `JobLog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobId` int(11) NOT NULL,
  `status` varchar(512) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `createdAt` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JobLog`
--

LOCK TABLES `JobLog` WRITE;
/*!40000 ALTER TABLE `JobLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `JobLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KeyManager`
--

DROP TABLE IF EXISTS `KeyManager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `KeyManager` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `status` varchar(32) NOT NULL,
  `key` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KeyManager`
--

LOCK TABLES `KeyManager` WRITE;
/*!40000 ALTER TABLE `KeyManager` DISABLE KEYS */;
/*!40000 ALTER TABLE `KeyManager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LandingPageTemplate`
--

DROP TABLE IF EXISTS `LandingPageTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LandingPageTemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isSystemTemplate` tinyint(1) NOT NULL DEFAULT 0,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LandingPageTemplate`
--

LOCK TABLES `LandingPageTemplate` WRITE;
/*!40000 ALTER TABLE `LandingPageTemplate` DISABLE KEYS */;
/*!40000 ALTER TABLE `LandingPageTemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LocalSecret`
--

DROP TABLE IF EXISTS `LocalSecret`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LocalSecret` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `secret` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LocalSecret`
--

LOCK TABLES `LocalSecret` WRITE;
/*!40000 ALTER TABLE `LocalSecret` DISABLE KEYS */;
/*!40000 ALTER TABLE `LocalSecret` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LoginEvents`
--

DROP TABLE IF EXISTS `LoginEvents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LoginEvents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trackingId` varchar(32) DEFAULT NULL,
  `eventType` varchar(32) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `userId` int(11) DEFAULT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `providerId` int(11) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `createdOn` datetime NOT NULL DEFAULT current_timestamp(),
  `userName` varchar(255) DEFAULT NULL,
  `clientName` varchar(255) DEFAULT NULL,
  `identityProviderName` varchar(255) DEFAULT NULL,
  `companyName` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `familyName` varchar(255) DEFAULT NULL,
  `givenName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_LoginEvents_trackingId` (`trackingId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LoginEvents`
--

LOCK TABLES `LoginEvents` WRITE;
/*!40000 ALTER TABLE `LoginEvents` DISABLE KEYS */;
/*!40000 ALTER TABLE `LoginEvents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Namespace`
--

DROP TABLE IF EXISTS `Namespace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Namespace` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `namespaceParentId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Namespace_Name_Id` (`name`,`id`),
  KEY `FK_Namespace_tenantId` (`tenantId`),
  KEY `FK_Namespace_namespaceParentId` (`namespaceParentId`),
  CONSTRAINT `FK_Namespace_namespaceParentId` FOREIGN KEY (`namespaceParentId`) REFERENCES `Namespace` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `FK_Namespace_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Namespace`
--

LOCK TABLES `Namespace` WRITE;
/*!40000 ALTER TABLE `Namespace` DISABLE KEYS */;
/*!40000 ALTER TABLE `Namespace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OpenIdConnectAccessToken`
--

DROP TABLE IF EXISTS `OpenIdConnectAccessToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OpenIdConnectAccessToken` (
  `accessToken` varchar(255) NOT NULL,
  `grantId` varchar(500) DEFAULT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`accessToken`),
  KEY `IX_OpenIdConnectAccessToken_grantId` (`grantId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OpenIdConnectAccessToken`
--

LOCK TABLES `OpenIdConnectAccessToken` WRITE;
/*!40000 ALTER TABLE `OpenIdConnectAccessToken` DISABLE KEYS */;
/*!40000 ALTER TABLE `OpenIdConnectAccessToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OpenIdConnectDeviceCode`
--

DROP TABLE IF EXISTS `OpenIdConnectDeviceCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OpenIdConnectDeviceCode` (
  `deviceCode` varchar(255) NOT NULL,
  `userCode` varchar(500) NOT NULL,
  `grantId` varchar(500) DEFAULT NULL,
  `isConsumed` tinyint(1) DEFAULT 0,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `tenantId` int(11) NOT NULL,
  PRIMARY KEY (`deviceCode`),
  KEY `IX_OpenIdConnectDeviceCode_grantId` (`grantId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OpenIdConnectDeviceCode`
--

LOCK TABLES `OpenIdConnectDeviceCode` WRITE;
/*!40000 ALTER TABLE `OpenIdConnectDeviceCode` DISABLE KEYS */;
/*!40000 ALTER TABLE `OpenIdConnectDeviceCode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OpenIdConnectGrant`
--

DROP TABLE IF EXISTS `OpenIdConnectGrant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OpenIdConnectGrant` (
  `grantId` varchar(500) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `userId` int(11) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `tenantId` int(11) NOT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`grantId`),
  UNIQUE KEY `UQ_OpenIdConnectGrant_grantId` (`grantId`),
  KEY `FK_OpenIdConnectGrant_tenantId` (`tenantId`),
  KEY `IX_OpenIdConnectGrant_grantId` (`grantId`),
  KEY `FK_OpenIdConnectGrant_clientId` (`clientId`),
  KEY `FK_OpenIdConnectGrant_userId` (`userId`),
  CONSTRAINT `FK_OpenIdConnectGrant_clientId` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_OpenIdConnectGrant_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_OpenIdConnectGrant_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OpenIdConnectGrant`
--

LOCK TABLES `OpenIdConnectGrant` WRITE;
/*!40000 ALTER TABLE `OpenIdConnectGrant` DISABLE KEYS */;
/*!40000 ALTER TABLE `OpenIdConnectGrant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OpenIdConnectSession`
--

DROP TABLE IF EXISTS `OpenIdConnectSession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OpenIdConnectSession` (
  `sessionId` varchar(255) NOT NULL,
  `uid` varchar(500) NOT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `grantId` varchar(500) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `userId` int(11) DEFAULT NULL,
  PRIMARY KEY (`sessionId`),
  KEY `IX_OpenIdConnectSession_grantId` (`grantId`),
  KEY `IX_OpenIdConnectSession_accountId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OpenIdConnectSession`
--

LOCK TABLES `OpenIdConnectSession` WRITE;
/*!40000 ALTER TABLE `OpenIdConnectSession` DISABLE KEYS */;
/*!40000 ALTER TABLE `OpenIdConnectSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OpenIdConnectSessionMetadata`
--

DROP TABLE IF EXISTS `OpenIdConnectSessionMetadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OpenIdConnectSessionMetadata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sid` varchar(256) DEFAULT NULL,
  `sessionUid` varchar(256) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `tenantId` int(11) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `IX_OpenIdConnectSessionMetadata_sid` (`sid`),
  KEY `IX_OpenIdConnectSessionMetadata_sessionUid` (`sessionUid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OpenIdConnectSessionMetadata`
--

LOCK TABLES `OpenIdConnectSessionMetadata` WRITE;
/*!40000 ALTER TABLE `OpenIdConnectSessionMetadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `OpenIdConnectSessionMetadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Permission`
--

DROP TABLE IF EXISTS `Permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Permission` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `createdOn` timestamp NOT NULL DEFAULT current_timestamp(),
  `clientId` int(3) NOT NULL,
  `tenantId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Permission_name_clientId` (`name`,`clientId`),
  KEY `client_FK_idx` (`clientId`),
  KEY `IX_Permission_tenantId` (`tenantId`),
  CONSTRAINT `FK_Permission_resourceServerId` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Permission_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Permission`
--

LOCK TABLES `Permission` WRITE;
/*!40000 ALTER TABLE `Permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `Permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RefreshToken`
--

DROP TABLE IF EXISTS `RefreshToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RefreshToken` (
  `refreshToken` varchar(500) NOT NULL,
  `grantId` varchar(500) NOT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `isConsumed` tinyint(1) DEFAULT 0,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`refreshToken`),
  UNIQUE KEY `refreshToken_UNIQUE` (`refreshToken`),
  KEY `IX_RefreshToken_grantId` (`grantId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefreshToken`
--

LOCK TABLES `RefreshToken` WRITE;
/*!40000 ALTER TABLE `RefreshToken` DISABLE KEYS */;
/*!40000 ALTER TABLE `RefreshToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RequestableAccess`
--

DROP TABLE IF EXISTS `RequestableAccess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RequestableAccess` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accessType` varchar(45) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `groupId` int(11) DEFAULT NULL,
  `approvalWorkflowId` int(11) DEFAULT NULL,
  `tenantId` int(11) NOT NULL,
  `umrsRoleId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `clientId` int(11) DEFAULT NULL,
  `uri` varchar(255) DEFAULT NULL,
  `invitationEmailTemplateId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_RequestableAccess_name_groupId` (`name`,`groupId`),
  KEY `FK_RequestableAccess_tenantId` (`tenantId`),
  KEY `FK_RequestableAccess_groupId` (`groupId`),
  KEY `FK_RequestableAccess_approvalWorkflowId` (`approvalWorkflowId`),
  KEY `FK_RequestableAccess_clientId` (`clientId`),
  KEY `FK_RequestableAccess_umrsRoleId` (`umrsRoleId`),
  KEY `FK_invitationEmailTemplateId_emailTemplateId` (`invitationEmailTemplateId`),
  CONSTRAINT `FK_RequestableAccess_approvalWorkflowId` FOREIGN KEY (`approvalWorkflowId`) REFERENCES `ApprovalWorkflow` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RequestableAccess_clientId` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RequestableAccess_groupId` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RequestableAccess_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_RequestableAccess_umrsRoleId` FOREIGN KEY (`umrsRoleId`) REFERENCES `UmrsRole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_invitationEmailTemplateId_emailTemplateId` FOREIGN KEY (`invitationEmailTemplateId`) REFERENCES `EmailTemplate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RequestableAccess`
--

LOCK TABLES `RequestableAccess` WRITE;
/*!40000 ALTER TABLE `RequestableAccess` DISABLE KEYS */;
/*!40000 ALTER TABLE `RequestableAccess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ResourceServerClients`
--

DROP TABLE IF EXISTS `ResourceServerClients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ResourceServerClients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `resource_server_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clientID_resourceServerID_const_UNIQUE` (`client_id`,`resource_server_id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `resource_server_client_id_FK` (`resource_server_id`),
  CONSTRAINT `client_id_resource_server_FK` FOREIGN KEY (`client_id`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `resource_server_client_id_FK` FOREIGN KEY (`resource_server_id`) REFERENCES `ResourceServers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ResourceServerClients`
--

LOCK TABLES `ResourceServerClients` WRITE;
/*!40000 ALTER TABLE `ResourceServerClients` DISABLE KEYS */;
/*!40000 ALTER TABLE `ResourceServerClients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ResourceServerPermission`
--

DROP TABLE IF EXISTS `ResourceServerPermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ResourceServerPermission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `resourceServerId` int(3) NOT NULL,
  `tenantId` int(3) NOT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ResourceServerPermission_name_resourceServerId` (`name`,`resourceServerId`),
  KEY `IX_ResourceServerPermission_resourceServerId` (`resourceServerId`),
  KEY `FK_ResourceServerPermission_tenantId` (`tenantId`),
  CONSTRAINT `FK_ResourceServerPermission_resourceServerId` FOREIGN KEY (`resourceServerId`) REFERENCES `ResourceServers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ResourceServerPermission_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ResourceServerPermission`
--

LOCK TABLES `ResourceServerPermission` WRITE;
/*!40000 ALTER TABLE `ResourceServerPermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `ResourceServerPermission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ResourceServerPermissionAccessRole`
--

DROP TABLE IF EXISTS `ResourceServerPermissionAccessRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ResourceServerPermissionAccessRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resourceServerPermissionId` int(3) NOT NULL,
  `accessRoleId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_RSPR_resourceServerPermissionId_accessRoleId` (`resourceServerPermissionId`,`accessRoleId`),
  KEY `FK_ ResourceServerPermissionRole_accessRoleId` (`accessRoleId`),
  CONSTRAINT `FK_ ResourceServerPermissionRole_accessRoleId` FOREIGN KEY (`accessRoleId`) REFERENCES `AccessRole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ResourceServerPermissionAccessRole_resourceServerPermissionId` FOREIGN KEY (`resourceServerPermissionId`) REFERENCES `ResourceServerPermission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ResourceServerPermissionAccessRole`
--

LOCK TABLES `ResourceServerPermissionAccessRole` WRITE;
/*!40000 ALTER TABLE `ResourceServerPermissionAccessRole` DISABLE KEYS */;
/*!40000 ALTER TABLE `ResourceServerPermissionAccessRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ResourceServers`
--

DROP TABLE IF EXISTS `ResourceServers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ResourceServers` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  `tenantID` int(3) NOT NULL,
  `createdOn` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `resourceServerName_tenantId_UNIQUE` (`name`,`tenantID`),
  UNIQUE KEY `resourceServerIdentifier_tenantId_UNIQUE` (`identifier`,`tenantID`),
  KEY `resourceServer_tenantID_FK` (`tenantID`),
  CONSTRAINT `resourceServer_tenantID_FK` FOREIGN KEY (`tenantID`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ResourceServers`
--

LOCK TABLES `ResourceServers` WRITE;
/*!40000 ALTER TABLE `ResourceServers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ResourceServers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Role` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `tenantId` int(3) NOT NULL,
  `clientId` int(3) NOT NULL,
  `isClientRole` tinyint(1) DEFAULT NULL,
  `namespaceId` int(11) DEFAULT NULL,
  `createdOn` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Role_TenantID_ClientId_Name_NamespaceId` (`tenantId`,`clientId`,`name`,`namespaceId`),
  KEY `role_clientId_FK` (`clientId`),
  KEY `FK_Role_namespaceId` (`namespaceId`),
  CONSTRAINT `FK_Role_namespaceId` FOREIGN KEY (`namespaceId`) REFERENCES `Namespace` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION,
  CONSTRAINT `role_clientId_FK` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_tenantID_FK` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Role`
--

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;
/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RolePermission`
--

DROP TABLE IF EXISTS `RolePermission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RolePermission` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `roleId` int(3) NOT NULL,
  `permissionId` int(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roleId_permissionId_UNIQUE` (`roleId`,`permissionId`),
  KEY `role_id_FK_idx` (`roleId`),
  KEY `permission_id_FK` (`permissionId`),
  CONSTRAINT `permission_id_FK` FOREIGN KEY (`permissionId`) REFERENCES `Permission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_id_FK` FOREIGN KEY (`roleId`) REFERENCES `Role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RolePermission`
--

LOCK TABLES `RolePermission` WRITE;
/*!40000 ALTER TABLE `RolePermission` DISABLE KEYS */;
/*!40000 ALTER TABLE `RolePermission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SamlIntegration`
--

DROP TABLE IF EXISTS `SamlIntegration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SamlIntegration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  `tenantID` int(11) NOT NULL,
  `clientID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `saml_integration_clientID_FK` (`clientID`),
  KEY `saml_integration_tenantId_FK` (`tenantID`),
  CONSTRAINT `saml_integration_clientID_FK` FOREIGN KEY (`clientID`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `saml_integration_tenantId_FK` FOREIGN KEY (`tenantID`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SamlIntegration`
--

LOCK TABLES `SamlIntegration` WRITE;
/*!40000 ALTER TABLE `SamlIntegration` DISABLE KEYS */;
/*!40000 ALTER TABLE `SamlIntegration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SecretManager`
--

DROP TABLE IF EXISTS `SecretManager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SecretManager` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `createdByUserId` int(3) DEFAULT NULL,
  `username` varchar(128) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `encryptionKeyId` int(3) NOT NULL,
  `secret` mediumtext DEFAULT NULL,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  `updatedAt` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `externalSecretId` varchar(255) DEFAULT NULL,
  `ownershipLevel` varchar(255) DEFAULT NULL,
  `ownershipId` int(3) NOT NULL,
  `managerProvider` varchar(255) DEFAULT NULL,
  `lifetimeInDays` int(3) DEFAULT NULL,
  `secretRotationNotificationAt` datetime DEFAULT NULL,
  `secretRotationAt` datetime DEFAULT NULL,
  `secretRotationHasBeenNotified` tinyint(1) NOT NULL DEFAULT 0,
  `options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`options`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `secretManager_name_UNIQUE` (`name`),
  KEY `FK_secretManager_createdByUserId` (`createdByUserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SecretManager`
--

LOCK TABLES `SecretManager` WRITE;
/*!40000 ALTER TABLE `SecretManager` DISABLE KEYS */;
/*!40000 ALTER TABLE `SecretManager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SecretsMigration`
--

DROP TABLE IF EXISTS `SecretsMigration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SecretsMigration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oldId` varchar(255) DEFAULT NULL,
  `newId` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SecretsMigration`
--

LOCK TABLES `SecretsMigration` WRITE;
/*!40000 ALTER TABLE `SecretsMigration` DISABLE KEYS */;
/*!40000 ALTER TABLE `SecretsMigration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SharedSecret`
--

DROP TABLE IF EXISTS `SharedSecret`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SharedSecret` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `secretId` int(3) NOT NULL,
  `sharedLevel` varchar(255) DEFAULT NULL,
  `sharedLevelId` int(3) DEFAULT NULL,
  `customOptions` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_SharedSecret_secretId` (`secretId`),
  CONSTRAINT `FK_SharedSecret_secretId` FOREIGN KEY (`secretId`) REFERENCES `SecretManager` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SharedSecret`
--

LOCK TABLES `SharedSecret` WRITE;
/*!40000 ALTER TABLE `SharedSecret` DISABLE KEYS */;
/*!40000 ALTER TABLE `SharedSecret` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tenant`
--

DROP TABLE IF EXISTS `Tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tenant` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `tenantId` varchar(255) NOT NULL,
  `secrets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`secrets`)),
  `tileConfig` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tileConfig`)),
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `loginEventSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`loginEventSettings`)),
  `userAlertSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`userAlertSettings`)),
  `notification` varchar(4096) DEFAULT NULL,
  `emailSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`emailSettings`)),
  `emailSecrets` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`emailSecrets`)),
  `activeX509CertificateFingerprint` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `createdByUserId` int(11) DEFAULT NULL,
  `ownerUserId` int(11) DEFAULT NULL,
  `updatedAt` timestamp NULL DEFAULT NULL,
  `visibility` varchar(255) DEFAULT 'public',
  `isArchived` tinyint(1) NOT NULL DEFAULT 0,
  `latestLogin` timestamp NULL DEFAULT NULL,
  `archivedDate` timestamp NULL DEFAULT NULL,
  `tenantStatus` varchar(255) DEFAULT NULL,
  `notifiedSamlCertExpiration` tinyint(1) NOT NULL DEFAULT 0,
  `notifiedSamlCertExpirationDate` timestamp NULL DEFAULT NULL,
  `notificationExpirationDate` timestamp NULL DEFAULT NULL,
  `cookieConsentSettings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`cookieConsentSettings`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Tenant_tenantId` (`tenantId`),
  UNIQUE KEY `UQ_Tenant_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tenant`
--

LOCK TABLES `Tenant` WRITE;
/*!40000 ALTER TABLE `Tenant` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TenantErrorPage`
--

DROP TABLE IF EXISTS `TenantErrorPage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TenantErrorPage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_TenantErrorPage_tenantID` (`tenantID`),
  CONSTRAINT `FK_TenantErrorPage_tenantID` FOREIGN KEY (`tenantID`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TenantErrorPage`
--

LOCK TABLES `TenantErrorPage` WRITE;
/*!40000 ALTER TABLE `TenantErrorPage` DISABLE KEYS */;
/*!40000 ALTER TABLE `TenantErrorPage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TenantLoginPage`
--

DROP TABLE IF EXISTS `TenantLoginPage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TenantLoginPage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantID` int(11) NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `tenantLoginPage_tenantId_UNIQUE` (`tenantID`),
  CONSTRAINT `login_page_tenantID_FK` FOREIGN KEY (`tenantID`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TenantLoginPage`
--

LOCK TABLES `TenantLoginPage` WRITE;
/*!40000 ALTER TABLE `TenantLoginPage` DISABLE KEYS */;
/*!40000 ALTER TABLE `TenantLoginPage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TenantUser`
--

DROP TABLE IF EXISTS `TenantUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TenantUser` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `userId` int(3) NOT NULL,
  `tenantId` int(3) NOT NULL,
  `picture` mediumtext DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `nickname` varchar(255) DEFAULT NULL,
  `givenName` varchar(255) DEFAULT NULL,
  `familyName` varchar(255) DEFAULT NULL,
  `isBlocked` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId_tenantId_UNIQUE_CONST` (`userId`,`tenantId`),
  KEY `tenantId_CONST` (`tenantId`),
  CONSTRAINT `tenantId_CONST` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userId_CONST` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TenantUser`
--

LOCK TABLES `TenantUser` WRITE;
/*!40000 ALTER TABLE `TenantUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `TenantUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TrustedTenant`
--

DROP TABLE IF EXISTS `TrustedTenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TrustedTenant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sourceTenantId` int(11) NOT NULL,
  `targetTenantId` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_TrustedTenant_sourceTenantId_targetTenantId` (`sourceTenantId`,`targetTenantId`),
  KEY `FK_TrustedTenant_sourceTenantId` (`sourceTenantId`),
  KEY `FK_TrustedTenant_targetTenantId` (`targetTenantId`),
  CONSTRAINT `FK_TrustedTenant_sourceTenantId` FOREIGN KEY (`sourceTenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_TrustedTenant_targetTenantId` FOREIGN KEY (`targetTenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TrustedTenant`
--

LOCK TABLES `TrustedTenant` WRITE;
/*!40000 ALTER TABLE `TrustedTenant` DISABLE KEYS */;
/*!40000 ALTER TABLE `TrustedTenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UmrsRole`
--

DROP TABLE IF EXISTS `UmrsRole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UmrsRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenantId` int(11) NOT NULL,
  `resourceServerId` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(1024) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_UmrsRole_resourceServerId_name` (`resourceServerId`,`name`),
  KEY `FK_UmrsRole_tenant` (`tenantId`),
  CONSTRAINT `FK_UmrsRole_resourceServer` FOREIGN KEY (`resourceServerId`) REFERENCES `ResourceServers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UmrsRole_tenant` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UmrsRole`
--

LOCK TABLES `UmrsRole` WRITE;
/*!40000 ALTER TABLE `UmrsRole` DISABLE KEYS */;
/*!40000 ALTER TABLE `UmrsRole` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UmrsRoleGroup`
--

DROP TABLE IF EXISTS `UmrsRoleGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UmrsRoleGroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `umrsRoleId` int(11) NOT NULL,
  `groupId` int(11) NOT NULL,
  `expiresAt` datetime DEFAULT NULL,
  `resourceId` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_umrsRoleGroup_umrsRoleId` (`umrsRoleId`),
  KEY `FK_umrsRoleGroup_groupId` (`groupId`),
  CONSTRAINT `FK_umrsRoleGroup_groupId` FOREIGN KEY (`groupId`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_umrsRoleGroup_umrsRoleId` FOREIGN KEY (`umrsRoleId`) REFERENCES `UmrsRole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UmrsRoleGroup`
--

LOCK TABLES `UmrsRoleGroup` WRITE;
/*!40000 ALTER TABLE `UmrsRoleGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `UmrsRoleGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UmrsRoleUser`
--

DROP TABLE IF EXISTS `UmrsRoleUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UmrsRoleUser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `umrsRoleId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `expiresAt` datetime DEFAULT NULL,
  `resourceId` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `FK_umrsRoleUser_umrsRoleId` (`umrsRoleId`),
  KEY `FK_umrsRoleUser_userId` (`userId`),
  CONSTRAINT `FK_umrsRoleUser_umrsRoleId` FOREIGN KEY (`umrsRoleId`) REFERENCES `UmrsRole` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_umrsRoleUser_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UmrsRoleUser`
--

LOCK TABLES `UmrsRoleUser` WRITE;
/*!40000 ALTER TABLE `UmrsRoleUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `UmrsRoleUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UniversalSession`
--

DROP TABLE IF EXISTS `UniversalSession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UniversalSession` (
  `sessionId` varchar(512) NOT NULL,
  `protocol` varchar(128) DEFAULT NULL,
  `expiresAt` int(11) DEFAULT NULL,
  `tenantId` int(11) NOT NULL,
  `clientId` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `data` mediumtext DEFAULT NULL,
  PRIMARY KEY (`sessionId`),
  UNIQUE KEY `UQ_ UniversalSession_sessionId` (`sessionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UniversalSession`
--

LOCK TABLES `UniversalSession` WRITE;
/*!40000 ALTER TABLE `UniversalSession` DISABLE KEYS */;
/*!40000 ALTER TABLE `UniversalSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `lastLogin` timestamp NULL DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `displayName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `givenName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `middleName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `familyName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `identityIssuer` varchar(1024) DEFAULT NULL,
  `picture` mediumtext DEFAULT NULL,
  `totpSecret` varchar(32) DEFAULT NULL,
  `strikeCount` int(11) DEFAULT NULL,
  `lastStrike` datetime DEFAULT NULL,
  `lockedOut` tinyint(1) DEFAULT NULL,
  `emailVerified` tinyint(1) DEFAULT NULL,
  `externalGroups` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`externalGroups`)),
  `_userProfileClaims` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`_userProfileClaims`)),
  `_providerClaims` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`_providerClaims`)),
  `_customClaims` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`_customClaims`)),
  `upn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `commonName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `company` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `department` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amr` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`amr`)),
  `isBlocked` tinyint(1) DEFAULT 0,
  `passwordHash` varchar(512) DEFAULT NULL,
  `userStatus` varchar(255) DEFAULT 'Active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_Users_email_identityIssuer` (`identityIssuer`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserAlert`
--

DROP TABLE IF EXISTS `UserAlert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserAlert` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `userId` int(11) NOT NULL,
  `alertType` varchar(32) NOT NULL,
  `alert` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`alert`)),
  `status` varchar(32) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `statusDetails` varchar(1024) DEFAULT NULL,
  `createdOn` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserAlert`
--

LOCK TABLES `UserAlert` WRITE;
/*!40000 ALTER TABLE `UserAlert` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserAlert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserGroups`
--

DROP TABLE IF EXISTS `UserGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserGroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(3) NOT NULL,
  `group_id` int(3) NOT NULL,
  `expiryDate` datetime DEFAULT NULL,
  `role` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_UserGroups_userId_groupId` (`user_id`,`group_id`),
  KEY `IX_UserGroups_groupId` (`group_id`),
  KEY `IX_UserGroups_userId` (`user_id`),
  CONSTRAINT `FK_UserGroups_groupId` FOREIGN KEY (`group_id`) REFERENCES `Groups` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_UserGroups_userId` FOREIGN KEY (`user_id`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserGroups`
--

LOCK TABLES `UserGroups` WRITE;
/*!40000 ALTER TABLE `UserGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserLinkedClientIdentity`
--

DROP TABLE IF EXISTS `UserLinkedClientIdentity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserLinkedClientIdentity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sourceUserId` int(3) NOT NULL,
  `linkedUserId` int(3) NOT NULL,
  `clientId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_UserClientIdentity_sourceUserId` (`sourceUserId`),
  KEY `FK_UserClientIdentity_linkedUserId` (`linkedUserId`),
  CONSTRAINT `FK_UserClientIdentity_linkedUserId` FOREIGN KEY (`linkedUserId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UserClientIdentity_sourceUserId` FOREIGN KEY (`sourceUserId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserLinkedClientIdentity`
--

LOCK TABLES `UserLinkedClientIdentity` WRITE;
/*!40000 ALTER TABLE `UserLinkedClientIdentity` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserLinkedClientIdentity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserLoginProviderTokenData`
--

DROP TABLE IF EXISTS `UserLoginProviderTokenData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserLoginProviderTokenData` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `userId` int(3) NOT NULL,
  `clientId` int(3) NOT NULL,
  `tenantId` int(3) NOT NULL,
  `providerId` int(3) NOT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `expiresAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `UQ_UserLoginProviderTokenData_tenantId_userId_clientId` (`tenantId`,`clientId`,`userId`,`providerId`),
  KEY `FK_UserLoginProviderTokenData_userId` (`userId`),
  KEY `FK_UserLoginProviderTokenData_clientId` (`clientId`),
  KEY `FK_UserLoginProviderTokenData_providerId` (`providerId`),
  CONSTRAINT `FK_UserLoginProviderTokenData_clientId` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UserLoginProviderTokenData_providerId` FOREIGN KEY (`providerId`) REFERENCES `IdentityProvider` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UserLoginProviderTokenData_tenantId` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_UserLoginProviderTokenData_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserLoginProviderTokenData`
--

LOCK TABLES `UserLoginProviderTokenData` WRITE;
/*!40000 ALTER TABLE `UserLoginProviderTokenData` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserLoginProviderTokenData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserPushMfaAuthentication`
--

DROP TABLE IF EXISTS `UserPushMfaAuthentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserPushMfaAuthentication` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `userId` int(3) NOT NULL,
  `status` varchar(32) NOT NULL,
  `challenge` varchar(32) DEFAULT NULL,
  `statusDetails` varchar(1024) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp(),
  `deviceId` varchar(64) NOT NULL,
  `deviceRegistration` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`deviceRegistration`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `UQ_UserPushMfaAuthentication_challenge` (`challenge`),
  KEY `IX_UserPushMfaAuthentication_deviceId_user` (`deviceId`),
  KEY `FK_UserPushMfaAuthentication_userId` (`userId`),
  CONSTRAINT `FK_UserPushMfaAuthentication_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserPushMfaAuthentication`
--

LOCK TABLES `UserPushMfaAuthentication` WRITE;
/*!40000 ALTER TABLE `UserPushMfaAuthentication` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserPushMfaAuthentication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserSession`
--

DROP TABLE IF EXISTS `UserSession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserSession` (
  `sessionId` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `data` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `expiresAt` int(11) unsigned NOT NULL,
  PRIMARY KEY (`sessionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserSession`
--

LOCK TABLES `UserSession` WRITE;
/*!40000 ALTER TABLE `UserSession` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserTrustedDevices`
--

DROP TABLE IF EXISTS `UserTrustedDevices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserTrustedDevices` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `userId` int(3) NOT NULL,
  `created` datetime NOT NULL,
  `expires` datetime NOT NULL,
  `deviceCode` varchar(128) NOT NULL,
  `deviceFingerprint` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `deviceCode_UNIQUE` (`deviceCode`),
  KEY `userId_FK_idx` (`userId`),
  CONSTRAINT `userId_FK` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserTrustedDevices`
--

LOCK TABLES `UserTrustedDevices` WRITE;
/*!40000 ALTER TABLE `UserTrustedDevices` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserTrustedDevices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WSFederationUserSession`
--

DROP TABLE IF EXISTS `WSFederationUserSession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `WSFederationUserSession` (
  `sessionId` varchar(255) NOT NULL,
  `sessionCreated` timestamp NOT NULL DEFAULT current_timestamp(),
  `sessionExpired` timestamp NULL DEFAULT NULL,
  `wtrealm` varchar(1024) DEFAULT NULL,
  `wctx` varchar(1024) DEFAULT NULL,
  `wreply` varchar(1024) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `tenantId` int(11) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `identityProviderId` int(11) DEFAULT NULL,
  PRIMARY KEY (`sessionId`),
  KEY `wsfederationUserSession_clientId_FK` (`clientId`),
  KEY `wsfederationUserSession_tenantId_FK` (`tenantId`),
  CONSTRAINT `wsfederationUserSession_clientId_FK` FOREIGN KEY (`clientId`) REFERENCES `Client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wsfederationUserSession_tenantId_FK` FOREIGN KEY (`tenantId`) REFERENCES `Tenant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WSFederationUserSession`
--

LOCK TABLES `WSFederationUserSession` WRITE;
/*!40000 ALTER TABLE `WSFederationUserSession` DISABLE KEYS */;
/*!40000 ALTER TABLE `WSFederationUserSession` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WebauthnAuthentication`
--

DROP TABLE IF EXISTS `WebauthnAuthentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `WebauthnAuthentication` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `userId` int(3) NOT NULL,
  `status` varchar(32) NOT NULL,
  `statusDetails` varchar(1024) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT current_timestamp(),
  `updatedAt` timestamp NULL DEFAULT current_timestamp(),
  `deviceId` varchar(64) NOT NULL,
  `deviceRegistration` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`deviceRegistration`)),
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `IX_WebauthnAuthentication_deviceId` (`deviceId`),
  KEY `FK_WebauthnAuthentication_userId` (`userId`),
  CONSTRAINT `FK_WebauthnAuthentication_userId` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WebauthnAuthentication`
--

LOCK TABLES `WebauthnAuthentication` WRITE;
/*!40000 ALTER TABLE `WebauthnAuthentication` DISABLE KEYS */;
/*!40000 ALTER TABLE `WebauthnAuthentication` ENABLE KEYS */;
UNLOCK TABLES;


SET FOREIGN_KEY_CHECKS=1;
