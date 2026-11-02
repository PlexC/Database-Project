USE SteamDB;

-- 1. Wipe any partial broken data
TRUNCATE TABLE reviews;

-- 2. Turn off security guards, Strict Mode, and Server Timeouts
SET FOREIGN_KEY_CHECKS = 0;
SET SESSION sql_mode = '';       
SET net_read_timeout = 3600;
SET net_write_timeout = 3600;

-- 3. Load the data (This might take 1 to 5 minutes to finish, just let it run!)
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reviews.csv'
INTO TABLE reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'                   
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 4. Turn Strict Mode, Timeouts, and security guards back to normal
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
SET FOREIGN_KEY_CHECKS = 1;
SET net_read_timeout = 30;
SET net_write_timeout = 60;