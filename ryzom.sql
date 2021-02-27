DROP DATABASE IF EXISTS nel;
DROP DATABASE IF EXISTS nel_ams;
DROP DATABASE IF EXISTS nel_ams_lib;
DROP DATABASE IF EXISTS nel_tool;
DROP DATABASE IF EXISTS ring_open;

CREATE USER IF NOT EXISTS 'shard';
GRANT ALL ON nel.* TO shard@localhost;
GRANT ALL ON nel_ams.* TO shard@localhost;
GRANT ALL ON nel_ams_lib.* TO shard@localhost;
GRANT ALL ON nel_tool.* TO shard@localhost;
GRANT ALL ON ring_open.* TO shard@localhost;

FLUSH PRIVILEGES;

CREATE DATABASE `nel`;

use `nel`;

DROP TABLE IF EXISTS `domain`;
CREATE TABLE `domain` (
  `domain_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `domain_name` varchar(32) NOT NULL DEFAULT '',
  `status` enum('ds_close','ds_dev','ds_restricted','ds_open') NOT NULL DEFAULT 'ds_dev',
  `patch_version` int(10) unsigned NOT NULL DEFAULT 0,
  `backup_patch_url` varchar(255) DEFAULT NULL,
  `patch_urls` text DEFAULT NULL,
  `login_address` varchar(255) NOT NULL DEFAULT '',
  `session_manager_address` varchar(255) NOT NULL DEFAULT '',
  `ring_db_name` varchar(255) NOT NULL DEFAULT '',
  `web_host` varchar(255) NOT NULL DEFAULT '',
  `web_host_php` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`domain_id`),
  UNIQUE KEY `name_idx` (`domain_name`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission` (
  `PermissionId` int(11) NOT NULL AUTO_INCREMENT,
  `UId` int(10) unsigned NOT NULL DEFAULT 0,
  `DomainId` int(11) NOT NULL DEFAULT -1,
  `ShardId` int(10) NOT NULL DEFAULT -1,
  `AccessPrivilege` set('OPEN','DEV','RESTRICTED') NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY (`PermissionId`),
  KEY `UIDIndex` (`UId`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `UId` int(10) NOT NULL AUTO_INCREMENT,
  `Login` varchar(64) NOT NULL DEFAULT '',
  `State` enum('Offline','Online') NOT NULL DEFAULT 'Offline',
  `Privilege` varchar(255) NOT NULL DEFAULT '',
  `ExtendedPrivilege` varchar(128) NOT NULL DEFAULT '',
  `GMId` int(4) NOT NULL DEFAULT 0,
  `Password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`UId`),
  KEY `LoginIndex` (`Login`),
  KEY `GMId` (`GMId`)
) DEFAULT CHARSET=utf8mb4 COMMENT='contains all users information for login system';

CREATE DATABASE `nel_tool`;
use `nel_tool`;

DROP TABLE IF EXISTS `neltool_annotations`;
CREATE TABLE `neltool_annotations` (
  `annotation_id` int(11) NOT NULL AUTO_INCREMENT,
  `annotation_domain_id` int(11) DEFAULT NULL,
  `annotation_shard_id` int(11) DEFAULT NULL,
  `annotation_data` varchar(255) NOT NULL DEFAULT '',
  `annotation_user_name` varchar(32) NOT NULL DEFAULT '',
  `annotation_date` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`annotation_id`),
  UNIQUE KEY `annotation_shard_id` (`annotation_shard_id`),
  UNIQUE KEY `annotation_domain_id` (`annotation_domain_id`)
) DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_annotations` WRITE;
INSERT INTO `neltool_annotations` VALUES (1,NULL,1,'Welcome to the Shard Admin Website!','vl',1272378352);
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_applications`;
CREATE TABLE `neltool_applications` (
  `application_id` int(11) NOT NULL AUTO_INCREMENT,
  `application_name` varchar(64) NOT NULL DEFAULT '',
  `application_uri` varchar(255) NOT NULL DEFAULT '',
  `application_restriction` varchar(64) NOT NULL DEFAULT '',
  `application_order` int(11) NOT NULL DEFAULT 0,
  `application_visible` int(11) NOT NULL DEFAULT 0,
  `application_icon` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`application_id`)
) DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_applications` WRITE;
INSERT INTO `neltool_applications` VALUES
(1,'Main','index.php','',100,1,'imgs/icon_main.gif'),
(2,'Logout','index.php?mode=logout','',999999,1,'imgs/icon_logout.gif'),
(3,'Admin','tool_administration.php','tool_admin',1500,1,'imgs/icon_admin.gif'),
(4,'Prefs','tool_preferences.php','tool_preferences',1000,1,'imgs/icon_preferences.gif'),
(5,'Admin/Users','','tool_admin_user',1502,0,''),
(6,'Admin/Applications','','tool_admin_application',1501,0,''),
(7,'Admin/Domains','','tool_admin_domain',1504,0,''),
(8,'Admin/Shards','','tool_admin_shard',1505,0,''),
(9,'Admin/Groups','','tool_admin_group',1503,0,''),
(10,'Admin/Logs','','tool_admin_logs',1506,0,''),
(11,'Main/Start','','tool_main_start',101,0,''),
(12,'Main/Stop','','tool_main_stop',102,0,''),
(13,'Main/Restart','','tool_main_restart',103,0,''),
(14,'Main/Kill','','tool_main_kill',104,0,''),
(15,'Main/Abort','','tool_main_abort',105,0,''),
(16,'Main/Execute','','tool_main_execute',108,0,''),
(18,'Notes','tool_notes.php','tool_notes',900,1,'imgs/icon_notes.gif'),
(19,'Player Locator','tool_player_locator.php','tool_player_locator',200,1,'imgs/icon_player_locator.gif'),
(20,'Player Locator/Display Players','','tool_player_locator_display_players',201,0,''),
(21,'Player Locator/Locate','','tool_player_locator_locate',202,0,''),
(22,'Main/LockDomain','','tool_main_lock_domain',110,0,''),
(23,'Main/LockShard','','tool_main_lock_shard',111,0,''),
(24,'Main/WS','','tool_main_ws',112,0,''),
(25,'Main/ResetCounters','','tool_main_reset_counters',113,0,''),
(26,'Main/ServiceAutoStart','','tool_main_service_autostart',114,0,''),
(27,'Main/ShardAutoStart','','tool_main_shard_autostart',115,0,''),
(28,'Main/WS/Old','','tool_main_ws_old',112,0,''),
(29,'Graphs','tool_graphs.php','tool_graph',500,1,'imgs/icon_graphs.gif'),
(30,'Notes/Global','','tool_notes_global',901,0,''),
(31,'Log Analyser','tool_log_analyser.php','tool_las',400,1,'imgs/icon_log_analyser.gif'),
(32,'Guild Locator','tool_guild_locator.php','tool_guild_locator',300,1,'imgs/icon_guild_locator.gif'),
(33,'Player Locator/UserID Check','','tool_player_locator_userid_check',203,0,''),
(34,'Player Locator/CSR Relocate','','tool_player_locator_csr_relocate',204,0,''),
(35,'Guild Locator/Guilds Update','','tool_guild_locator_manage_guild',301,0,''),
(36,'Guild Locator/Members Update','','tool_guild_locator_manage_members',302,0,''),
(37,'Entities','tool_event_entities.php','tool_event_entities',350,1,'imgs/icon_entity.gif'),
(38,'Admin/Restarts','','tool_admin_restart',1507,0,''),
(39,'Main/EasyRestart','','tool_main_easy_restart',116,0,'');
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_domains`;
CREATE TABLE `neltool_domains` (
  `domain_id` int(11) NOT NULL AUTO_INCREMENT,
  `domain_name` varchar(128) NOT NULL DEFAULT '',
  `domain_as_host` varchar(128) NOT NULL DEFAULT '',
  `domain_as_port` int(11) NOT NULL DEFAULT 0,
  `domain_rrd_path` varchar(255) NOT NULL DEFAULT '',
  `domain_las_admin_path` varchar(255) NOT NULL DEFAULT '',
  `domain_las_local_path` varchar(255) NOT NULL DEFAULT '',
  `domain_application` varchar(128) NOT NULL DEFAULT '',
  `domain_sql_string` varchar(128) NOT NULL DEFAULT '',
  `domain_hd_check` int(11) NOT NULL DEFAULT 0,
  `domain_mfs_web` text DEFAULT NULL,
  `domain_cs_sql_string` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`domain_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_group_applications`;
CREATE TABLE `neltool_group_applications` (
  `group_application_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_application_group_id` int(11) NOT NULL DEFAULT 0,
  `group_application_application_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`group_application_id`),
  KEY `group_application_group_id` (`group_application_group_id`),
  KEY `group_application_application_id` (`group_application_application_id`)
) DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_group_applications` WRITE;
INSERT INTO `neltool_group_applications` VALUES (879,1,10),(878,1,8),(877,1,7),(876,1,9),(875,1,5),(874,1,6),(873,1,3),(872,1,4),(871,1,30),(870,1,18),(869,1,29),(868,1,31),(867,1,37),(866,1,36),(865,1,35),(864,1,32),(863,1,34),(862,1,33),(861,1,21),(860,1,20),(859,1,19),(858,1,39),(857,1,27),(856,1,26),(843,3,10),(842,3,8),(841,3,7),(840,3,9),(839,3,5),(838,3,6),(837,3,3),(836,3,4),(835,3,30),(834,3,18),(833,3,29),(832,3,31),(831,3,37),(830,3,36),(829,3,35),(828,3,32),(827,3,34),(826,3,33),(825,3,21),(824,3,20),(823,3,19),(822,3,39),(821,3,27),(820,3,26),(597,4,36),(596,4,35),(595,4,32),(594,4,21),(593,4,20),(592,4,19),(591,4,24),(590,4,23),(589,4,14),(588,4,12),(632,2,18),(631,2,37),(630,2,32),(629,2,21),(628,2,20),(627,2,19),(626,2,24),(625,2,23),(624,2,22),(623,2,16),(622,2,15),(621,2,14),(620,2,13),(819,3,25),(855,1,25),(619,2,12),(818,3,28),(854,1,28),(817,3,24),(718,5,18),(717,5,37),(716,5,32),(715,5,21),(714,5,20),(713,5,19),(712,5,27),(711,5,26),(710,5,24),(709,5,23),(708,5,22),(707,5,16),(706,5,15),(705,5,14),(816,3,23),(609,6,35),(608,6,32),(607,6,21),(606,6,20),(605,6,19),(604,6,24),(603,6,23),(602,6,14),(601,6,12),(600,6,11),(815,3,22),(814,3,16),(853,1,24),(704,5,13),(703,5,12),(852,1,23),(587,4,11),(618,2,11),(702,5,11),(612,7,19),(851,1,22),(813,3,15),(812,3,14),(598,4,18),(599,4,4),(610,6,18),(611,6,4),(613,7,20),(614,7,21),(615,7,32),(616,7,35),(617,7,4),(633,2,4),(811,3,13),(810,3,12),(850,1,16),(849,1,15),(848,1,14),(847,1,13),(846,1,12),(719,5,4),(720,8,11),(721,8,12),(722,8,13),(723,8,14),(724,8,15),(725,8,16),(726,8,22),(727,8,23),(728,8,24),(729,8,25),(730,8,26),(731,8,27),(732,8,19),(733,8,20),(734,8,21),(735,8,37),(736,8,4),(737,9,29),(738,9,4),(809,3,11),(845,1,11),(844,3,38),(880,1,38),(909,10,18),(908,10,29),(907,10,37),(906,10,36),(905,10,35),(904,10,32),(903,10,34),(902,10,33),(901,10,21),(900,10,20),(899,10,19),(898,10,23),(897,10,13),(910,10,30),(965,11,29),(964,11,37),(963,11,32),(962,11,34),(961,11,33),(960,11,21),(959,11,20),(958,11,19);
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_group_domains`;
CREATE TABLE `neltool_group_domains` (
  `group_domain_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_domain_group_id` int(11) NOT NULL DEFAULT 0,
  `group_domain_domain_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`group_domain_id`),
  KEY `group_domain_group_id` (`group_domain_group_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_group_shards`;
CREATE TABLE `neltool_group_shards` (
  `group_shard_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_shard_group_id` int(11) NOT NULL DEFAULT 0,
  `group_shard_shard_id` int(11) NOT NULL DEFAULT 0,
  `group_shard_domain_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`group_shard_id`),
  KEY `group_shard_group_id` (`group_shard_group_id`),
  KEY `group_shard_domain_id` (`group_shard_domain_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_groups`;
CREATE TABLE `neltool_groups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(32) NOT NULL DEFAULT 'NewGroup',
  `group_level` int(11) NOT NULL DEFAULT 0,
  `group_default` int(11) NOT NULL DEFAULT 0,
  `group_active` int(11) NOT NULL DEFAULT 0,
  `group_default_domain_id` tinyint(3) unsigned DEFAULT NULL,
  `group_default_shard_id` smallint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_groups` WRITE;
INSERT INTO `neltool_groups` VALUES
(1,'AdminGroup',0,0,1,20,300),
(2,'DeveloperGroup',0,1,1,20,300),
(3,'AdminDebugGroup',10,0,1,20,300),
(4,'SupportSGMGroup',0,0,1,NULL,NULL),
(6,'SupportGMGroup',0,0,1,NULL,NULL),
(7,'SupportReadOnlyGroup',0,0,1,NULL,NULL),
(8,'DeveloperLevelDesigners',0,0,1,20,300),
(9,'DeveloperReadOnlyGroup',0,0,1,20,300);
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_locks`;
CREATE TABLE `neltool_locks` (
  `lock_id` int(11) NOT NULL AUTO_INCREMENT,
  `lock_domain_id` int(11) DEFAULT NULL,
  `lock_shard_id` int(11) DEFAULT NULL,
  `lock_user_name` varchar(32) NOT NULL DEFAULT '',
  `lock_date` int(11) NOT NULL DEFAULT 0,
  `lock_update` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`lock_id`),
  UNIQUE KEY `lock_shard_id` (`lock_shard_id`),
  UNIQUE KEY `lock_domain_id` (`lock_domain_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_logs`;
CREATE TABLE `neltool_logs` (
  `logs_id` int(11) NOT NULL AUTO_INCREMENT,
  `logs_user_name` varchar(32) NOT NULL DEFAULT '0',
  `logs_date` int(11) NOT NULL DEFAULT 0,
  `logs_data` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`logs_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_notes`;
CREATE TABLE `neltool_notes` (
  `note_id` int(11) NOT NULL AUTO_INCREMENT,
  `note_user_id` int(11) NOT NULL DEFAULT 0,
  `note_title` varchar(128) NOT NULL DEFAULT '',
  `note_data` text NOT NULL,
  `note_date` int(11) NOT NULL DEFAULT 0,
  `note_active` int(11) NOT NULL DEFAULT 0,
  `note_global` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`note_id`)
) DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_notes` WRITE;
INSERT INTO `neltool_notes` VALUES (2,1,'Welcome','Welcome to the shard administration website!\r\n\r\nThis website is used to monitor and restart shards.\r\n\r\nIt also gives some player characters information.',1272378065,1,1),(3,1,'Shard Start','# At the same time : NS and TS\r\n[1 min] : all MS, you can boot them all at the same time\r\n[1 min] : IOS\r\n[3 mins] : GMPS\r\n[3 mins] : EGS\r\n[5 mins] : AI Fyros\r\n[1 min 30] : AI Zorai\r\n[1 min 30] : AI Matis\r\n[1 min 30] : AI TNP\r\n[1 min 30] : AI NPE\r\n[1 min 30] : AI Tryker\r\n[1 min 30] : All FS and SBS at the same time\r\n[30 secs] : WS (atm the WS starts in OPEN mode by default, so be fast before CSR checkage, fix for that inc soon)\r\n\r\nNOTE: you can check the uptime for those timers in the right column of the admin tool: UpTime\r\n',1158751126,1,0),(5,1,'shutting supplementary','the writing wont change when lock the ws\r\n\r\nuntick previous boxes as you shut down\r\n\r\nwait 5 between the ws and the egs ie egs is 5 past rest is 10 past',1153395380,1,0),(4,1,'Shard Stop','1. Broadcast to warn players\r\n\r\n2. 10 mins before shutdown, lock the WS\r\n\r\n3. At the right time shut down WS\r\n\r\n4. Shut down EGS\r\nOnly the EGS. Wait 5 reals minutes. Goal is to give enough time to egs, in order to save all the info he has to, and letting him sending those message to all services who need it.\r\n\r\n5. Shut down the rest, et voil&agrave;, you&#039;re done.',1153314198,1,0),(6,1,'Start (EGS to high?)','If [EGS] is to high on startup:\r\n\r\n[shut down egs]\r\n[5 mins]\r\n\r\n[IOS] &amp; [GPMS] (shut down at same time)\r\n\r\nAfter the services are down follow &quot;UP&quot; process with timers again.\r\n\r\nIOS\r\n[3 mins]\r\nGPMS\r\n[3 mins]\r\nEGS\r\n[5 mins]\r\nbla bla...',1153395097,1,0),(7,1,'opening if the egs is too high on reboot','&lt;kadael&gt; here my note on admin about egs to high on startup\r\n&lt;kadael&gt; ---\r\n&lt;kadael&gt; If [EGS] is to high on startup:\r\n&lt;kadael&gt; [shut down egs]\r\n&lt;kadael&gt; [5 mins]\r\n&lt;kadael&gt; [IOS] &amp; [GPMS] (at same time shut down )\r\n&lt;kadael&gt; after the services are down follow &quot;UP&quot; process with timers again.\r\n&lt;kadael&gt; IOS\r\n&lt;kadael&gt; [3 mins]\r\n&lt;kadael&gt; GPMS\r\n&lt;kadael&gt; [3 mins]\r\n&lt;kadael&gt; EGS\r\n&lt;kadael&gt; [5 mins]\r\n&lt;kadael&gt; bla bla...\r\n&lt;kadael&gt; ---',1153395362,1,0),(10,1,'Ring points','Commande pour donner tout les points ring &agrave; tout le monde :\r\n\r\nDans le DSS d&#039;un Shard Ring entrer : DefaultCharRingAccess f7:j7:l6:d7:p13:g9:a9',1155722296,1,0),(9,1,'Start (EGS to high?)','If [EGS] is to high on startup: \r\n  \r\n [shut down egs] \r\n [5 mins] \r\n  \r\n [IOS] &amp; [GPMS] (shut down at same time) \r\n  \r\n After the services are down follow &quot;UP&quot; process with timers again. \r\n  \r\n IOS \r\n [3 mins] \r\n GPMS \r\n [3 mins] \r\n EGS \r\n [5 mins] \r\n bla bla...',1153929658,1,0);
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_restart_groups`;
CREATE TABLE `neltool_restart_groups` (
  `restart_group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `restart_group_name` varchar(50) DEFAULT NULL,
  `restart_group_list` varchar(50) DEFAULT NULL,
  `restart_group_order` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`restart_group_id`),
  UNIQUE KEY `restart_group_id` (`restart_group_id`),
  KEY `restart_group_id_2` (`restart_group_id`)
) DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_restart_groups` WRITE;
INSERT INTO `neltool_restart_groups` VALUES (1,'Low Level','rns,ts,ms','1'),(3,'Mid Level','ios,gpms,egs','2'),(4,'High Level','ais','3'),(5,'Front Level','fes,sbs,dss,rws','4');
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_restart_messages`;
CREATE TABLE `neltool_restart_messages` (
  `restart_message_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `restart_message_name` varchar(20) DEFAULT NULL,
  `restart_message_value` varchar(128) DEFAULT NULL,
  `restart_message_lang` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`restart_message_id`),
  UNIQUE KEY `restart_message_id` (`restart_message_id`),
  KEY `restart_message_id_2` (`restart_message_id`)
) DEFAULT CHARSET=utf8mb4;

LOCK TABLES `neltool_restart_messages` WRITE;
INSERT INTO `neltool_restart_messages` VALUES (5,'reboot','The shard is about to go down. Please find a safe location and log out.','en'),(4,'reboot','Le serveur va redemarrer dans $minutes$ minutes. Merci de vous deconnecter en lieu sur.','fr'),(6,'reboot','Der Server wird heruntergefahren. Findet eine sichere Stelle und logt aus.','de'),(10,'reboot','Arret du serveur dans $minutes+1$ minutes','fr');
UNLOCK TABLES;

DROP TABLE IF EXISTS `neltool_restart_sequences`;
CREATE TABLE `neltool_restart_sequences` (
  `restart_sequence_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `restart_sequence_domain_id` int(10) unsigned NOT NULL DEFAULT 0,
  `restart_sequence_shard_id` int(10) unsigned NOT NULL DEFAULT 0,
  `restart_sequence_user_name` varchar(50) DEFAULT NULL,
  `restart_sequence_step` int(10) unsigned NOT NULL DEFAULT 0,
  `restart_sequence_date_start` int(11) DEFAULT NULL,
  `restart_sequence_date_end` int(11) DEFAULT NULL,
  `restart_sequence_timer` int(11) unsigned DEFAULT 0,
  PRIMARY KEY (`restart_sequence_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_shards`;
CREATE TABLE `neltool_shards` (
  `shard_id` int(11) NOT NULL AUTO_INCREMENT,
  `shard_name` varchar(128) NOT NULL DEFAULT '',
  `shard_as_id` varchar(255) NOT NULL DEFAULT '0',
  `shard_domain_id` int(11) NOT NULL DEFAULT 0,
  `shard_lang` char(2) NOT NULL DEFAULT 'en',
  `shard_restart` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`shard_id`),
  KEY `shard_domain_id` (`shard_domain_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_stats_hd_datas`;
CREATE TABLE `neltool_stats_hd_datas` (
  `hd_id` int(11) NOT NULL AUTO_INCREMENT,
  `hd_domain_id` int(11) NOT NULL DEFAULT 0,
  `hd_server` varchar(32) NOT NULL DEFAULT '',
  `hd_device` varchar(64) NOT NULL DEFAULT '',
  `hd_size` varchar(16) NOT NULL DEFAULT '',
  `hd_used` varchar(16) NOT NULL DEFAULT '',
  `hd_free` varchar(16) NOT NULL DEFAULT '',
  `hd_percent` int(11) NOT NULL DEFAULT 0,
  `hd_mount` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`hd_id`),
  KEY `hd_domain_id` (`hd_domain_id`),
  KEY `hd_server` (`hd_server`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_stats_hd_times`;
CREATE TABLE `neltool_stats_hd_times` (
  `hd_domain_id` int(11) NOT NULL DEFAULT 0,
  `hd_last_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`hd_domain_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_user_applications`;
CREATE TABLE `neltool_user_applications` (
  `user_application_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_application_user_id` int(11) NOT NULL DEFAULT 0,
  `user_application_application_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_application_id`),
  KEY `user_application_user_id` (`user_application_user_id`),
  KEY `user_application_application_id` (`user_application_application_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_user_domains`;
CREATE TABLE `neltool_user_domains` (
  `user_domain_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_domain_user_id` int(11) NOT NULL DEFAULT 0,
  `user_domain_domain_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_domain_id`),
  KEY `user_domain_user_id` (`user_domain_user_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_user_shards`;
CREATE TABLE `neltool_user_shards` (
  `user_shard_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_shard_user_id` int(11) NOT NULL DEFAULT 0,
  `user_shard_shard_id` int(11) NOT NULL DEFAULT 0,
  `user_shard_domain_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_shard_id`),
  KEY `user_shard_user_id` (`user_shard_user_id`),
  KEY `user_shard_domain_id` (`user_shard_domain_id`)
) DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `neltool_users`;
CREATE TABLE `neltool_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(32) NOT NULL DEFAULT '',
  `user_password` varchar(64) NOT NULL DEFAULT '',
  `user_group_id` int(11) NOT NULL DEFAULT 0,
  `user_created` int(11) NOT NULL DEFAULT 0,
  `user_active` int(11) NOT NULL DEFAULT 0,
  `user_logged_last` int(11) NOT NULL DEFAULT 0,
  `user_logged_count` int(11) NOT NULL DEFAULT 0,
  `user_menu_style` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_login` (`user_name`),
  KEY `user_group_id` (`user_group_id`),
  KEY `user_active` (`user_active`)
) DEFAULT CHARSET=utf8mb4;

CREATE DATABASE `ring_open`;
use `ring_open`;

DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `char_id` int(10) unsigned NOT NULL DEFAULT 0,
  `char_name` varchar(20) NOT NULL DEFAULT '',
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `guild_id` int(10) unsigned NOT NULL DEFAULT 0,
  `best_combat_level` int(10) unsigned NOT NULL DEFAULT 0,
  `home_mainland_session_id` int(10) unsigned NOT NULL DEFAULT 0,
  `ring_access` varchar(63) NOT NULL DEFAULT '',
  `race` enum('r_fyros','r_matis','r_tryker','r_zorai') NOT NULL DEFAULT 'r_fyros',
  `civilisation` enum('c_neutral','c_fyros','c_matis','c_tryker','c_zorai') NOT NULL DEFAULT 'c_neutral',
  `cult` enum('c_neutral','c_kami','c_karavan') NOT NULL DEFAULT 'c_neutral',
  `current_session` int(11) unsigned NOT NULL DEFAULT 0,
  `rrp_am` int(11) unsigned NOT NULL DEFAULT 0,
  `rrp_masterless` int(11) unsigned NOT NULL DEFAULT 0,
  `rrp_author` int(11) unsigned NOT NULL DEFAULT 0,
  `newcomer` tinyint(1) NOT NULL DEFAULT 1,
  `creation_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_played_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`char_id`),
  UNIQUE KEY `char_name_idx` (`char_name`,`home_mainland_session_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `guild_idx` (`guild_id`),
  KEY `guild_id_idx` (`guild_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `folder`;
CREATE TABLE `folder` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` int(10) unsigned NOT NULL DEFAULT 0,
  `title` varchar(40) NOT NULL DEFAULT '',
  `comments` text NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `owner_idx` (`owner`),
  KEY `title_idx` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `folder_access`;
CREATE TABLE `folder_access` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `folder_id` int(10) unsigned NOT NULL DEFAULT 0,
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `folder_id_idx` (`folder_id`),
  KEY `user_idx` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=FIXED;

DROP TABLE IF EXISTS `guild_invites`;
CREATE TABLE `guild_invites` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned NOT NULL DEFAULT 0,
  `guild_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `guild_id_idx` (`guild_id`),
  KEY `session_id_idx` (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=FIXED;

DROP TABLE IF EXISTS `guilds`;
CREATE TABLE `guilds` (
  `guild_id` int(10) unsigned NOT NULL DEFAULT 0,
  `guild_name` varchar(50) NOT NULL DEFAULT '',
  `shard_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`guild_id`),
  KEY `shard_id_idx` (`shard_id`),
  KEY `guild_name_idx` (`guild_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `journal_entry`;
CREATE TABLE `journal_entry` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned NOT NULL DEFAULT 0,
  `author` int(10) unsigned NOT NULL DEFAULT 0,
  `type` enum('jet_credits','jet_notes') NOT NULL DEFAULT 'jet_notes',
  `text` text NOT NULL,
  `time_stamp` datetime NOT NULL DEFAULT '2005-09-07 12:41:33',
  PRIMARY KEY (`Id`),
  KEY `session_id_idx` (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `known_users`;
CREATE TABLE `known_users` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `owner` int(10) unsigned NOT NULL DEFAULT 0,
  `targer_user` int(10) unsigned NOT NULL DEFAULT 0,
  `targer_character` int(10) unsigned NOT NULL DEFAULT 0,
  `relation_type` enum('rt_friend','rt_banned','rt_friend_dm') NOT NULL DEFAULT 'rt_friend',
  `comments` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`Id`),
  KEY `user_index` (`owner`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `mfs_erased_mail_series`;
CREATE TABLE `mfs_erased_mail_series` (
  `erased_char_id` int(11) unsigned NOT NULL DEFAULT 0,
  `erased_char_name` varchar(32) NOT NULL DEFAULT '',
  `erased_series` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `erase_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`erased_series`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `mfs_guild_thread`;
CREATE TABLE `mfs_guild_thread` (
  `thread_id` int(11) NOT NULL AUTO_INCREMENT,
  `guild_id` int(11) unsigned NOT NULL DEFAULT 0,
  `topic` varchar(255) NOT NULL DEFAULT '',
  `author_name` varchar(32) NOT NULL DEFAULT '',
  `last_post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_count` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`thread_id`),
  KEY `guild_index` (`guild_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `mfs_guild_thread_message`;
CREATE TABLE `mfs_guild_thread_message` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `thread_id` int(11) unsigned NOT NULL DEFAULT 0,
  `author_name` varchar(32) NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `content` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `mfs_mail`;
CREATE TABLE `mfs_mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_name` varchar(32) NOT NULL DEFAULT '',
  `subject` varchar(250) NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` enum('ms_new','ms_read','ms_erased') NOT NULL DEFAULT 'ms_new',
  `dest_char_id` int(11) unsigned NOT NULL DEFAULT 0,
  `erase_series` int(11) unsigned NOT NULL DEFAULT 0,
  `content` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dest_index` (`dest_char_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `outlands`;
CREATE TABLE `outlands` (
  `session_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `island_name` text NOT NULL,
  `billing_instance_id` int(11) unsigned NOT NULL DEFAULT 0,
  `anim_session_id` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `player_rating`;
CREATE TABLE `player_rating` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `scenario_id` int(10) unsigned NOT NULL DEFAULT 0,
  `session_id` int(10) unsigned NOT NULL DEFAULT 0,
  `rate_fun` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rate_difficulty` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rate_accessibility` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rate_originality` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `rate_direction` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `author` int(10) unsigned NOT NULL DEFAULT 0,
  `rating` int(10) NOT NULL DEFAULT 0,
  `comments` text NOT NULL,
  `time_stamp` datetime NOT NULL DEFAULT '2005-09-07 12:41:33',
  PRIMARY KEY (`Id`),
  KEY `session_id_idx` (`scenario_id`),
  KEY `author_idx` (`author`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `ring_users`;
CREATE TABLE `ring_users` (
  `user_id` int(10) unsigned NOT NULL DEFAULT 0,
  `user_name` varchar(20) NOT NULL DEFAULT '',
  `user_type` enum('ut_character','ut_pioneer') NOT NULL DEFAULT 'ut_character',
  `current_session` int(10) unsigned NOT NULL DEFAULT 0,
  `current_activity` enum('ca_none','ca_play','ca_edit','ca_anim') NOT NULL DEFAULT 'ca_none',
  `current_status` enum('cs_offline','cs_logged','cs_online') NOT NULL DEFAULT 'cs_offline',
  `public_level` enum('ul_none','ul_public') NOT NULL DEFAULT 'ul_none',
  `account_type` enum('at_normal','at_gold') NOT NULL DEFAULT 'at_normal',
  `content_access_level` varchar(20) NOT NULL DEFAULT '',
  `description` text NOT NULL DEFAULT '',
  `lang` enum('lang_en','lang_fr','lang_de') NOT NULL DEFAULT 'lang_en',
  `cookie` varchar(30) NOT NULL DEFAULT '',
  `current_domain_id` int(10) NOT NULL DEFAULT -1,
  `pioneer_char_id` int(11) unsigned NOT NULL DEFAULT 0,
  `current_char` int(11) NOT NULL DEFAULT 0,
  `add_privileges` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name_idx` (`user_name`),
  KEY `cookie_idx` (`cookie`),
  KEY `current_session_idx` (`current_session`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `scenario`;
CREATE TABLE `scenario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `md5` varchar(64) NOT NULL DEFAULT '',
  `title` varchar(32) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `author` varchar(32) NOT NULL DEFAULT '',
  `rrp_total` int(11) unsigned NOT NULL DEFAULT 0,
  `anim_mode` enum('am_dm','am_autonomous') NOT NULL DEFAULT 'am_dm',
  `language` varchar(11) NOT NULL DEFAULT '',
  `orientation` enum('so_newbie_training','so_story_telling','so_mistery','so_hack_slash','so_guild_training','so_other') NOT NULL DEFAULT 'so_other',
  `level` enum('sl_a','sl_b','sl_c','sl_d','sl_e','sl_f') NOT NULL DEFAULT 'sl_a',
  `allow_free_trial` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `scenario_desc`;
CREATE TABLE `scenario_desc` (
  `session_id` int(10) unsigned NOT NULL DEFAULT 0,
  `parent_scenario` int(10) unsigned NOT NULL DEFAULT 0,
  `description` text NOT NULL,
  `relation_to_parent` enum('rtp_same','rtp_variant','rtp_different') NOT NULL DEFAULT 'rtp_same',
  `title` varchar(40) NOT NULL DEFAULT '',
  `num_player` int(10) unsigned NOT NULL DEFAULT 0,
  `content_access_level` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`session_id`),
  UNIQUE KEY `title_idx` (`title`),
  KEY `parent_idx` (`parent_scenario`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `session_log`;
CREATE TABLE `session_log` (
  `id` int(11) NOT NULL DEFAULT 0,
  `scenario_id` int(11) unsigned NOT NULL DEFAULT 0,
  `rrp_scored` int(11) unsigned NOT NULL DEFAULT 0,
  `scenario_point_scored` int(11) unsigned NOT NULL DEFAULT 0,
  `time_taken` int(11) unsigned NOT NULL DEFAULT 0,
  `participants` text NOT NULL,
  `launch_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `owner` varchar(32) NOT NULL DEFAULT '0',
  `guild_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `session_participant`;
CREATE TABLE `session_participant` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(10) unsigned NOT NULL DEFAULT 0,
  `char_id` int(10) unsigned NOT NULL DEFAULT 0,
  `status` enum('sps_play_subscribed','sps_play_invited','sps_edit_invited','sps_anim_invited','sps_playing','sps_editing','sps_animating') NOT NULL DEFAULT 'sps_play_subscribed',
  `kicked` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `session_rated` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`Id`),
  KEY `session_idx` (`session_id`),
  KEY `user_idx` (`char_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=FIXED;

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `session_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_type` enum('st_edit','st_anim','st_outland','st_mainland') NOT NULL DEFAULT 'st_edit',
  `title` varchar(40) NOT NULL DEFAULT '',
  `owner` int(10) unsigned NOT NULL DEFAULT 0,
  `plan_date` datetime NOT NULL DEFAULT '2005-09-21 12:41:33',
  `start_date` datetime NOT NULL DEFAULT '2005-08-31 00:00:00',
  `description` text NOT NULL,
  `orientation` enum('so_newbie_training','so_story_telling','so_mistery','so_hack_slash','so_guild_training','so_other') NOT NULL DEFAULT 'so_other',
  `level` enum('sl_a','sl_b','sl_c','sl_d','sl_e','sl_f') NOT NULL DEFAULT 'sl_a',
  `rule_type` enum('rt_strict','rt_liberal') NOT NULL DEFAULT 'rt_strict',
  `access_type` enum('at_public','at_private') NOT NULL DEFAULT 'at_private',
  `state` enum('ss_planned','ss_open','ss_locked','ss_closed') NOT NULL DEFAULT 'ss_planned',
  `host_shard_id` int(11) NOT NULL DEFAULT 0,
  `subscription_slots` int(11) unsigned NOT NULL DEFAULT 0,
  `reserved_slots` int(10) unsigned NOT NULL DEFAULT 0,
  `free_slots` int(10) unsigned NOT NULL DEFAULT 0,
  `estimated_duration` enum('et_short','et_medium','et_long') NOT NULL DEFAULT 'et_short',
  `final_duration` int(10) unsigned NOT NULL DEFAULT 0,
  `folder_id` int(10) unsigned NOT NULL DEFAULT 0,
  `lang` varchar(20) NOT NULL DEFAULT '',
  `icone` varchar(70) NOT NULL DEFAULT '',
  `anim_mode` enum('am_dm','am_autonomous') NOT NULL DEFAULT 'am_dm',
  `race_filter` set('rf_fyros','rf_matis','rf_tryker','rf_zorai') NOT NULL DEFAULT '',
  `religion_filter` set('rf_kami','rf_karavan','rf_neutral') NOT NULL DEFAULT '',
  `guild_filter` enum('gf_only_my_guild','gf_any_player') DEFAULT 'gf_only_my_guild',
  `shard_filter` set('sf_shard00','sf_shard01','sf_shard02','sf_shard03','sf_shard04','sf_shard05','sf_shard06','sf_shard07','sf_shard08','sf_shard09','sf_shard10','sf_shard11','sf_shard12','sf_shard13','sf_shard14','sf_shard15','sf_shard16','sf_shard17','sf_shard18','sf_shard19','sf_shard20','sf_shard21','sf_shard22','sf_shard23','sf_shard24','sf_shard25','sf_shard26','sf_shard27','sf_shard28','sf_shard29','sf_shard30','sf_shard31') NOT NULL DEFAULT 'sf_shard00,sf_shard01,sf_shard02,sf_shard03,sf_shard04,sf_shard05,sf_shard06,sf_shard07,sf_shard08,sf_shard09,sf_shard10,sf_shard11,sf_shard12,sf_shard13,sf_shard14,sf_shard15,sf_shard16,sf_shard17,sf_shard18,sf_shard19,sf_shard20,sf_shard21,sf_shard22,sf_shard23,sf_shard24,sf_shard25,sf_shard26,sf_shard27,sf_shard28,sf_shard29,sf_shard30,sf_shard31',
  `level_filter` set('lf_a','lf_b','lf_c','lf_d','lf_e','lf_f') NOT NULL DEFAULT 'lf_a,lf_b,lf_c,lf_d,lf_e,lf_f',
  `subscription_closed` tinyint(1) NOT NULL DEFAULT 0,
  `newcomer` tinyint(1) unsigned zerofill NOT NULL DEFAULT 0,
  PRIMARY KEY (`session_id`),
  KEY `owner_idx` (`owner`),
  KEY `folder_idx` (`folder_id`),
  KEY `state_type_idx` (`state`,`session_type`)
) ENGINE=MyISAM AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `shard`;
CREATE TABLE `shard` (
  `shard_id` int(10) NOT NULL DEFAULT 0,
  `WSOnline` tinyint(1) NOT NULL DEFAULT 0,
  `MOTD` text NOT NULL,
  `OldState` enum('ds_close','ds_dev','ds_restricted','ds_open') NOT NULL DEFAULT 'ds_restricted',
  `RequiredState` enum('ds_close','ds_dev','ds_restricted','ds_open') NOT NULL DEFAULT 'ds_dev',
  PRIMARY KEY (`shard_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 ROW_FORMAT=FIXED;

CREATE DATABASE `nel_ams`;
use `nel_ams`;

DROP TABLE IF EXISTS `ams_user`;
CREATE TABLE `ams_user` (
  `UId` int(10) NOT NULL AUTO_INCREMENT,
  `Login` varchar(64) NOT NULL DEFAULT '',
  `Password` varchar(106) DEFAULT NULL,
  `Email` varchar(255) NOT NULL DEFAULT '',
  `Permission` int(3) NOT NULL DEFAULT 1,
  `FirstName` varchar(255) NOT NULL DEFAULT '',
  `LastName` varchar(255) NOT NULL DEFAULT '',
  `Gender` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `Country` char(2) NOT NULL DEFAULT '',
  `ReceiveMail` int(1) NOT NULL DEFAULT 1,
  `Language` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`UId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;


LOCK TABLES `ams_user` WRITE;
INSERT INTO `ams_user` VALUES (1,'admin','$6$gKDt67FCRzWjZfHx$hswdz5NOvKd2QLdosybxoYA/hwvrQP4QAeyYhuH50985a4vXNASC6MozvBmG7Sxg3FGts0cs1SfLCOrry5tfv0','localhost@localhost',1,'','',0,'',1,'en'),(2,'testuser','$6$YQFNKpCy6fwvBthq$mZ/PqZbeBNADf0KmbwP.2u0HigQga1R6mMlyUTn1ecto/DUQf2mJ5EJ5IaM/XzPqad4i0oOnGmgmDk5fJHCiy0','testuser@shard01.ryzomcore.local',1,'','',0,'',1,'en');
UNLOCK TABLES;

CREATE DATABASE `nel_ams_lib`;
use `nel_ams_lib`;

DROP TABLE IF EXISTS `ams_querycache`;
CREATE TABLE `ams_querycache` (
  `SID` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(64) NOT NULL,
  `query` varchar(512) NOT NULL,
  `db` varchar(80) NOT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `assigned`;
CREATE TABLE `assigned` (
  `Ticket` int(10) unsigned NOT NULL,
  `User` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Ticket`,`User`),
  KEY `fk_assigned_ticket_idx` (`Ticket`),
  KEY `fk_assigned_ams_user_idx` (`User`),
  CONSTRAINT `fk_assigned_ams_user` FOREIGN KEY (`User`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_assigned_ticket` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `email`;
CREATE TABLE `email` (
  `MailId` int(11) NOT NULL AUTO_INCREMENT,
  `Recipient` varchar(50) DEFAULT NULL,
  `Subject` varchar(60) DEFAULT NULL,
  `Body` varchar(400) DEFAULT NULL,
  `Status` varchar(45) DEFAULT NULL,
  `Attempts` varchar(45) DEFAULT '0',
  `UserId` int(10) unsigned DEFAULT NULL,
  `MessageId` varchar(45) DEFAULT NULL,
  `TicketId` int(10) unsigned DEFAULT NULL,
  `Sender` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`MailId`),
  KEY `fk_email_ticket_user2` (`UserId`),
  KEY `fk_email_ticket1` (`TicketId`),
  KEY `fk_email_support_group1` (`Sender`),
  CONSTRAINT `fk_email_support_group1` FOREIGN KEY (`Sender`) REFERENCES `support_group` (`SGroupId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_email_ticket1` FOREIGN KEY (`TicketId`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_email_ticket_user2` FOREIGN KEY (`UserId`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `forwarded`;
CREATE TABLE `forwarded` (
  `Group` int(10) unsigned NOT NULL,
  `Ticket` int(10) unsigned NOT NULL,
  KEY `fk_forwarded_support_group1` (`Group`),
  KEY `fk_forwarded_ticket1` (`Ticket`),
  CONSTRAINT `fk_forwarded_support_group1` FOREIGN KEY (`Group`) REFERENCES `support_group` (`SGroupId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_forwarded_ticket1` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `in_group`;
CREATE TABLE `in_group` (
  `Ticket_Group` int(10) unsigned NOT NULL,
  `Ticket` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Ticket_Group`,`Ticket`),
  KEY `fk_in_group_ticket_group_idx` (`Ticket_Group`),
  KEY `fk_in_group_ticket_idx` (`Ticket`),
  CONSTRAINT `fk_in_group_ticket` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_in_group_ticket_group` FOREIGN KEY (`Ticket_Group`) REFERENCES `ticket_group` (`TGroupId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `in_support_group`;
CREATE TABLE `in_support_group` (
  `User` int(10) unsigned NOT NULL,
  `Group` int(10) unsigned NOT NULL,
  KEY `fk_in_support_group_ticket_user1` (`User`),
  KEY `fk_in_support_group_support_group1` (`Group`),
  CONSTRAINT `fk_in_support_group_support_group1` FOREIGN KEY (`Group`) REFERENCES `support_group` (`SGroupId`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_in_support_group_ticket_user1` FOREIGN KEY (`User`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `plugins`;
CREATE TABLE `plugins` (
  `Id` int(10) NOT NULL AUTO_INCREMENT,
  `FileName` varchar(255) NOT NULL,
  `Name` varchar(56) NOT NULL,
  `Type` varchar(12) NOT NULL,
  `Owner` varchar(25) NOT NULL,
  `Permission` varchar(5) NOT NULL,
  `Status` int(11) NOT NULL DEFAULT 0,
  `Weight` int(11) NOT NULL DEFAULT 0,
  `Info` text DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `plugins` WRITE;
INSERT INTO `plugins` VALUES (1,'API_key_management','API_key_management','automatic','','admin',0,0,'{\"PluginName\":\"API Key Management\",\"Description\":\"Provides public access to the API\'s by generating access tokens.\",\"Version\":\"1.0.0\",\"Type\":\"automatic\",\"TemplatePath\":\"..\\/..\\/..\\/private_php\\/ams\\/plugins\\/API_key_management\\/templates\\/index.tpl\",\"\":null}'),(2,'Achievements','Achievements','Manual','','admin',0,0,'{\"PluginName\":\"Achievements\",\"Description\":\"Returns the achievements of a user with respect to the character\",\"Version\":\"1.0.0\",\"TemplatePath\":\"..\\/..\\/..\\/private_php\\/ams\\/plugins\\/Achievements\\/templates\\/index.tpl\",\"Type\":\"Manual\",\"\":null}'),(3,'Domain_Management','Domain_Management','Manual','','admin',1,0,'{\"PluginName\":\"Domain Management\",\"Description\":\"Plug-in for Domain Management.\",\"Version\":\"1.0.0\",\"TemplatePath\":\"..\\/..\\/..\\/private_php\\/ams\\/plugins\\/Domain_Management\\/templates\\/index.tpl\",\"Type\":\"Manual\",\"\":null}');
UNLOCK TABLES;

DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `idSettings` int(11) NOT NULL AUTO_INCREMENT,
  `Setting` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Value` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idSettings`),
  UNIQUE KEY `idSettings` (`idSettings`),
  KEY `idSettings_2` (`idSettings`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `settings` WRITE;
INSERT INTO `settings` VALUES (1,'userRegistration','0'),(2,'Domain_Auto_Add','1');
UNLOCK TABLES;

DROP TABLE IF EXISTS `support_group`;
CREATE TABLE `support_group` (
  `SGroupId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(22) NOT NULL,
  `Tag` varchar(7) NOT NULL,
  `GroupEmail` varchar(45) DEFAULT NULL,
  `IMAP_MailServer` varchar(60) DEFAULT NULL,
  `IMAP_Username` varchar(45) DEFAULT NULL,
  `IMAP_Password` varchar(90) DEFAULT NULL,
  PRIMARY KEY (`SGroupId`),
  UNIQUE KEY `Name_UNIQUE` (`Name`),
  UNIQUE KEY `Tag_UNIQUE` (`Tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `TagId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Value` varchar(60) NOT NULL,
  PRIMARY KEY (`TagId`),
  UNIQUE KEY `Value_UNIQUE` (`Value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `tagged`;
CREATE TABLE `tagged` (
  `Ticket` int(10) unsigned NOT NULL,
  `Tag` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Ticket`,`Tag`),
  KEY `fk_tagged_tag_idx` (`Tag`),
  CONSTRAINT `fk_tagged_tag` FOREIGN KEY (`Tag`) REFERENCES `tag` (`TagId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tagged_ticket` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket`;
CREATE TABLE `ticket` (
  `TId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Title` varchar(120) NOT NULL,
  `Status` int(11) DEFAULT 0,
  `Queue` int(11) DEFAULT 0,
  `Ticket_Category` int(10) unsigned NOT NULL,
  `Author` int(10) unsigned NOT NULL,
  `Priority` int(3) DEFAULT 0,
  PRIMARY KEY (`TId`),
  KEY `fk_ticket_ticket_category_idx` (`Ticket_Category`),
  KEY `fk_ticket_ams_user_idx` (`Author`),
  CONSTRAINT `fk_ticket_ams_user` FOREIGN KEY (`Author`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_ticket_category` FOREIGN KEY (`Ticket_Category`) REFERENCES `ticket_category` (`TCategoryId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_attachments`;
CREATE TABLE `ticket_attachments` (
  `idticket_attachments` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_TId` int(10) unsigned NOT NULL,
  `Filename` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Filesize` int(10) NOT NULL,
  `Uploader` int(10) unsigned NOT NULL,
  `Path` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idticket_attachments`),
  UNIQUE KEY `idticket_attachments_UNIQUE` (`idticket_attachments`),
  KEY `fk_ticket_attachments_ticket1_idx` (`ticket_TId`),
  KEY `fk_ticket_attachments_ticket_user1_idx` (`Uploader`),
  CONSTRAINT `fk_ticket_attachments_ticket1` FOREIGN KEY (`ticket_TId`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_attachments_ticket_user1` FOREIGN KEY (`Uploader`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_category`;
CREATE TABLE `ticket_category` (
  `TCategoryId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) NOT NULL,
  PRIMARY KEY (`TCategoryId`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `ticket_category` WRITE;
INSERT INTO `ticket_category` VALUES (2,'Hacking'),(3,'Ingame-Bug'),(5,'Installation'),(1,'Uncategorized'),(4,'Website-Bug');
UNLOCK TABLES;

DROP TABLE IF EXISTS `ticket_content`;
CREATE TABLE `ticket_content` (
  `TContentId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Content` text DEFAULT NULL,
  PRIMARY KEY (`TContentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_group`;
CREATE TABLE `ticket_group` (
  `TGroupId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Title` varchar(80) NOT NULL,
  PRIMARY KEY (`TGroupId`),
  UNIQUE KEY `Title_UNIQUE` (`Title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_info`;
CREATE TABLE `ticket_info` (
  `TInfoId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Ticket` int(10) unsigned NOT NULL,
  `ShardId` int(11) DEFAULT NULL,
  `UserPosition` varchar(65) DEFAULT NULL,
  `ViewPosition` varchar(65) DEFAULT NULL,
  `ClientVersion` varchar(65) DEFAULT NULL,
  `PatchVersion` varchar(65) DEFAULT NULL,
  `ServerTick` varchar(40) DEFAULT NULL,
  `ConnectState` varchar(40) DEFAULT NULL,
  `LocalAddress` varchar(70) DEFAULT NULL,
  `Memory` varchar(60) DEFAULT NULL,
  `OS` varchar(120) DEFAULT NULL,
  `Processor` varchar(120) DEFAULT NULL,
  `CPUID` varchar(50) DEFAULT NULL,
  `CpuMask` varchar(50) DEFAULT NULL,
  `HT` varchar(35) DEFAULT NULL,
  `NeL3D` varchar(120) DEFAULT NULL,
  `PlayerName` varchar(45) DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `TimeInGame` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TInfoId`),
  KEY `fk_ticket_info_ticket1` (`Ticket`),
  CONSTRAINT `fk_ticket_info_ticket1` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_log`;
CREATE TABLE `ticket_log` (
  `TLogId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Query` varchar(255) NOT NULL,
  `Ticket` int(10) unsigned NOT NULL,
  `Author` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`TLogId`),
  KEY `fk_ticket_log_ticket1` (`Ticket`),
  KEY `fk_ticket_log_ticket_user1` (`Author`),
  CONSTRAINT `fk_ticket_log_ticket1` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_log_ticket_user1` FOREIGN KEY (`Author`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_reply`;
CREATE TABLE `ticket_reply` (
  `TReplyId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Ticket` int(10) unsigned NOT NULL,
  `Author` int(10) unsigned NOT NULL,
  `Content` int(10) unsigned NOT NULL,
  `Timestamp` timestamp NULL DEFAULT NULL,
  `Hidden` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`TReplyId`),
  KEY `fk_ticket_reply_ticket_idx` (`Ticket`),
  KEY `fk_ticket_reply_ams_user_idx` (`Author`),
  KEY `fk_ticket_reply_content_idx` (`Content`),
  CONSTRAINT `fk_ticket_reply_ams_user` FOREIGN KEY (`Author`) REFERENCES `ticket_user` (`TUserId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_reply_ticket` FOREIGN KEY (`Ticket`) REFERENCES `ticket` (`TId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ticket_reply_ticket_content` FOREIGN KEY (`Content`) REFERENCES `ticket_content` (`TContentId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `ticket_user`;
CREATE TABLE `ticket_user` (
  `TUserId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Permission` int(3) NOT NULL DEFAULT 1,
  `ExternId` int(10) unsigned NOT NULL,
  PRIMARY KEY (`TUserId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `ticket_user` WRITE;
INSERT INTO `ticket_user` VALUES (1,3,1),(2,1,2);
UNLOCK TABLES;

DROP TABLE IF EXISTS `updates`;
CREATE TABLE `updates` (
  `s.no` int(10) NOT NULL AUTO_INCREMENT,
  `PluginId` int(10) DEFAULT NULL,
  `UpdatePath` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `UpdateInfo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`s.no`),
  KEY `PluginId` (`PluginId`),
  CONSTRAINT `updates_ibfk_1` FOREIGN KEY (`PluginId`) REFERENCES `plugins` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

USE `nel_tool`;

INSERT INTO `neltool_users` VALUES (
	1,                                          -- user_id
	'admin',                                    -- user_name
	'21232f297a57a5a743894a0e4a801fc3',         -- user_password
	1,                                          -- user_group_id
	0,                                          -- user_created
	1,                                          -- user_active
	0,                                          -- user_logged_last
	0,                                          -- user_logged_count
	0                                           -- user_menu_style
);

INSERT INTO `neltool_domains` VALUES (
	1,                                                                        -- domain_id
	'ryzom_open',                                                             -- domain_name
	'localhost',                                                              -- domain_as_host
	46700,                                                                    -- domain_as_port
	'/home/ryzom/code/ryzom/server/save_shard/rrd_graphs',                    -- domain_rrd_path
	'',                                                                       -- domain_las_admin_path
	'',                                                                       -- domain_las_local_path
	'ryzom_open',                                                             -- domain_application
	'mysql://shard@localhost/ring_open',                                      -- domain_sql_string
	0,                                                                        -- domain_hd_check
	'',                                                                       -- domain_mfs_web
	'mysql://shard@localhost/atrium_forums'                                   -- domain_cs_sql_string
);

INSERT INTO `neltool_shards` VALUES (
	1,           -- shard_id
	'open',      -- shard_name
	'open',      -- shard_as_id
	1,           -- shard_domain_id
	'en',        -- shard_lang
	0            -- shard_restart
);


INSERT INTO `neltool_group_domains` VALUES (1,1,1);
INSERT INTO `neltool_group_shards` VALUES (1,1,1,1);

USE `nel`;

INSERT INTO `user` VALUES (
	1,                                          -- UId
	'testuser',                                 -- Login
	'Offline',                                  -- State
	':DEV:',                                    -- Privilege
	'',                                         -- ExtendedPrivilege
	0,                                          -- GMId
	ENCRYPT('testuser', '$6$YQFNKpCy6fwvBthq$') -- Password
);

INSERT INTO `domain` VALUES (
	1,                                          -- domain_id
	'ryzom_open',                               -- domain_name
	'ds_open',                                  -- status (ds_close, *ds_dev, ds_restricted, ds_open)
	1,                                          -- patch_version
	'http://localhost:23001',                   -- backup_patch_url (if patch_urls fails)
	'http://localhost:8081/patch',              -- patch_urls (space separated)
	'localhost:49998',                          -- login_address
	'localhost:49999',                          -- session_manager_address
	'ring_open',                                -- ring_db_name
	'localhost:30000',                          -- web_host
	'localhost:40916',                          -- web_host_php
	'Open Domain'                               -- description
);

INSERT INTO `permission` VALUES (
	1,                                          -- PermissionId
	1,                                          -- UId
	1,                                          -- DomainId !
	-1,                                         -- ShardId
	'OPEN'                                      -- AccessPrivilege (*OPEN, DEV, RESTRICTED)
);

USE `ring_open`;

INSERT INTO `shard` VALUES (
	1001,                                       -- shard_id
	0,                                          -- WSOnline
	'Shard up',                                 -- MOTD
	'ds_open',                                  -- OldState (ds_close, ds_dev, *ds_restricted, ds_open)
	'ds_open'                                   -- RequiredState (ds_close, *ds_dev, ds_restricted, ds_open)
);

INSERT INTO `sessions` VALUES (
	1001,                                       -- session_id
	'st_mainland',                              -- session_type (*st_edit, st_anim, st_outland, st_mainland)
	'docky shard mainland',                     -- title
	0,                                          -- owner
	'2005-09-21 12:41:33',                      -- plan_date
	'2005-08-31 00:00:00',                      -- start_date
	'',                                         -- description
	'so_other',                                 -- orientation (so_newbie_training, so_story_telling, so_mistery, so_hack_slash, so_guild_training, *so_other)
	'sl_a',                                     -- level (*sl_a, sl_b, sl_c, sl_d, sl_e, sl_f)
	'rt_strict',                                -- rule_type (*rt_strict, rt_liberal)
	'at_public',                                -- access_type (at_public, *at_private)
	'ss_planned',                               -- state (*ss_planned, ss_open, ss_locked, ss_closed)
	0,                                          -- host_shard_id
	0,                                          -- subscription_slots
	0,                                          -- reserved_slots
	0,                                          -- free_slots
	'et_short',                                 -- estimated_duration (*et_short, et_medium, et_long)
	0,                                          -- final_duration
	0,                                          -- folder_id
	'lang_en',                                  -- lang
	'',                                         -- icone
	'am_dm',                                    -- anim_mode (*am_dm, am_autonomous)
	'rf_fyros,rf_matis,rf_tryker,rf_zorai',     -- race_filter (rf_fyros, ...)
	'rf_kami,rf_karavan,rf_neutral',            -- religion_filter (rf_kami, ...)
	'gf_any_player',                            -- guild_filter (*gf_only_my_guild, gf_any_player)
	'',                                         -- shard_filter (sf_shard00, sf_shard01, ...)
	'lf_a,lf_b,lf_c,lf_d,lf_e,lf_f',            -- level_filter (lf_a, lf_b, ...)
	0,                                          -- subscription_closed
	0                                           -- newcomer
);
