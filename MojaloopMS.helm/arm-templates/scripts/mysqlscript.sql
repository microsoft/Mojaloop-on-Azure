/* Copyright (c) Microsoft Corporation. */
/* Licensed under the MIT License. */

CREATE DATABASE `mcm` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
CREATE DATABASE `account_lookup` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
CREATE DATABASE `central_ledger` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
CREATE USER 'mcm'@'%';
ALTER USER 'mcm'@'%'
IDENTIFIED BY 'mcm' ;
GRANT Alter ON mcm.* TO 'mcm'@'%';
GRANT Create ON mcm.* TO 'mcm'@'%';
GRANT Create view ON mcm.* TO 'mcm'@'%';
GRANT Delete ON mcm.* TO 'mcm'@'%';
GRANT Drop ON mcm.* TO 'mcm'@'%';
GRANT Grant option ON mcm.* TO 'mcm'@'%';
GRANT Index ON mcm.* TO 'mcm'@'%';
GRANT Insert ON mcm.* TO 'mcm'@'%';
GRANT References ON mcm.* TO 'mcm'@'%';
GRANT Select ON mcm.* TO 'mcm'@'%';
GRANT Show view ON mcm.* TO 'mcm'@'%';
GRANT Trigger ON mcm.* TO 'mcm'@'%';
GRANT Update ON mcm.* TO 'mcm'@'%';
GRANT Alter routine ON mcm.* TO 'mcm'@'%';
GRANT Create routine ON mcm.* TO 'mcm'@'%';
GRANT Create temporary tables ON mcm.* TO 'mcm'@'%';
GRANT Execute ON mcm.* TO 'mcm'@'%';
GRANT Lock tables ON mcm.* TO 'mcm'@'%';
CREATE USER 'account_lookup'@'%';
ALTER USER 'account_lookup'@'%'
IDENTIFIED BY 'OdonPianoX' ;
GRANT Alter ON account_lookup.* TO 'account_lookup'@'%';
GRANT Create ON account_lookup.* TO 'account_lookup'@'%';
GRANT Create view ON account_lookup.* TO 'account_lookup'@'%';
GRANT Delete ON account_lookup.* TO 'account_lookup'@'%';
GRANT Drop ON account_lookup.* TO 'account_lookup'@'%';
GRANT Grant option ON account_lookup.* TO 'account_lookup'@'%';
GRANT Index ON account_lookup.* TO 'account_lookup'@'%';
GRANT Insert ON account_lookup.* TO 'account_lookup'@'%';
GRANT References ON account_lookup.* TO 'account_lookup'@'%';
GRANT Select ON account_lookup.* TO 'account_lookup'@'%';
GRANT Show view ON account_lookup.* TO 'account_lookup'@'%';
GRANT Trigger ON account_lookup.* TO 'account_lookup'@'%';
GRANT Update ON account_lookup.* TO 'account_lookup'@'%';
GRANT Alter routine ON account_lookup.* TO 'account_lookup'@'%';
GRANT Create routine ON account_lookup.* TO 'account_lookup'@'%';
GRANT Create temporary tables ON account_lookup.* TO 'account_lookup'@'%';
GRANT Execute ON account_lookup.* TO 'account_lookup'@'%';
GRANT Lock tables ON account_lookup.* TO 'account_lookup'@'%';
CREATE USER 'central_ledger'@'%';
ALTER USER 'central_ledger'@'%'
IDENTIFIED BY 'oyMxgZChuu' ;
GRANT Alter ON central_ledger.* TO 'central_ledger'@'%';
GRANT Create ON central_ledger.* TO 'central_ledger'@'%';
GRANT Create view ON central_ledger.* TO 'central_ledger'@'%';
GRANT Delete ON central_ledger.* TO 'central_ledger'@'%';
GRANT Drop ON central_ledger.* TO 'central_ledger'@'%';
GRANT Grant option ON central_ledger.* TO 'central_ledger'@'%';
GRANT Index ON central_ledger.* TO 'central_ledger'@'%';
GRANT Insert ON central_ledger.* TO 'central_ledger'@'%';
GRANT References ON central_ledger.* TO 'central_ledger'@'%';
GRANT Select ON central_ledger.* TO 'central_ledger'@'%';
GRANT Show view ON central_ledger.* TO 'central_ledger'@'%';
GRANT Trigger ON central_ledger.* TO 'central_ledger'@'%';
GRANT Update ON central_ledger.* TO 'central_ledger'@'%';
GRANT Alter routine ON central_ledger.* TO 'central_ledger'@'%';
GRANT Create routine ON central_ledger.* TO 'central_ledger'@'%';
GRANT Create temporary tables ON central_ledger.* TO 'central_ledger'@'%';
GRANT Execute ON central_ledger.* TO 'central_ledger'@'%';
GRANT Lock tables ON central_ledger.* TO 'central_ledger'@'%';