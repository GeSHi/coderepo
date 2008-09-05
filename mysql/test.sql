ALTER TABLE `xcart_sessions_data` ADD COLUMN `last_updated` TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE `xcart_sessions_data` ADD INDEX `last_updated` (`last_updated`);

-- Some standard SELECT ...
SELECT *
FROM `geshi_downloads`
WHERE `download_id` = 1
OR `download_id` = 2
LIMIT 0, 1000