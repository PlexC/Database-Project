USE SteamDB;

-- 1. Disable safety checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Wipe the tables (so you don't get duplicate data)
TRUNCATE TABLE application_genres;
TRUNCATE TABLE application_platforms;
TRUNCATE TABLE application_publishers;
TRUNCATE TABLE applications;

-- 3. Re-enable safety checks
SET FOREIGN_KEY_CHECKS = 1;

-- 4. Import the Cleaned Applications (WITH the advanced ETL logic)
LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/applications.csv' 
INTO TABLE applications 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(appid, name, type, is_free, release_date, required_age, short_description, supported_languages, header_image, background, @metacritic_score, @recommendations_total, mat_supports_windows, mat_supports_mac, mat_supports_linux, @mat_initial_price, @mat_final_price, @mat_discount_percent, mat_currency, @mat_achievement_count, mat_pc_os_min, mat_pc_processor_min, mat_pc_memory_min, mat_pc_graphics_min, mat_pc_os_rec, mat_pc_processor_rec, mat_pc_memory_rec, mat_pc_graphics_rec, created_at, updated_at)
SET 
    metacritic_score = NULLIF(@metacritic_score, ''),
    recommendations_total = NULLIF(@recommendations_total, ''),
    mat_initial_price = NULLIF(@mat_initial_price, ''),
    mat_final_price = NULLIF(@mat_final_price, ''),
    mat_discount_percent = NULLIF(@mat_discount_percent, ''),
    mat_achievement_count = NULLIF(@mat_achievement_count, '');

-- 5. Re-import the Junction Tables
LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_genres.csv'
INTO TABLE application_genres CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_platforms.csv'
INTO TABLE application_platforms CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'H:/Other computers/My Laptop/SteamDataSet/datasets/steam_dataset_2025_csv/application_publishers.csv'
INTO TABLE application_publishers CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;