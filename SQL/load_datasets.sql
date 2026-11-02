SET GLOBAL local_infile = 1;

USE SteamDB;

SET FOREIGN_KEY_CHECKS = 0;
/*
LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/genres.csv'
INTO TABLE genres
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/categories.csv'
INTO TABLE categories
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/platforms.csv'
INTO TABLE platforms
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/publishers.csv'
INTO TABLE publishers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/developers.csv'
INTO TABLE developers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/applications.csv'
INTO TABLE applications
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_genres.csv'
INTO TABLE application_genres
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_platforms.csv'
INTO TABLE application_platforms
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_publishers.csv'
INTO TABLE application_publishers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_developers.csv'
INTO TABLE application_developers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_categories.csv'
INTO TABLE application_categories
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
*/
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reviews.csv'
INTO TABLE reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SET FOREIGN_KEY_CHECKS = 1;