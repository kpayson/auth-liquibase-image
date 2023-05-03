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
