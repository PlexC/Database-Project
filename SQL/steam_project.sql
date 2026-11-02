/*
CREATE TABLE genres (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE categories (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE platforms (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE publishers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE developers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE applications (
    appid INT PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(50),
    is_free VARCHAR(10),
    release_date VARCHAR(50), 
    required_age INT,
    short_description TEXT,
    supported_languages TEXT,
    header_image VARCHAR(255),
    background VARCHAR(255),
    metacritic_score INT,
    recommendations_total INT,
    mat_supports_windows VARCHAR(10),
    mat_supports_mac VARCHAR(10),
    mat_supports_linux VARCHAR(10),
    mat_initial_price INT,
    mat_final_price INT,
    mat_discount_percent INT,
    mat_currency VARCHAR(10),
    mat_achievement_count INT,
    mat_pc_os_min VARCHAR(255),
    mat_pc_processor_min VARCHAR(255),
    mat_pc_memory_min VARCHAR(255),
    mat_pc_graphics_min VARCHAR(255),
    mat_pc_os_rec VARCHAR(255),
    mat_pc_processor_rec VARCHAR(255),
    mat_pc_memory_rec VARCHAR(255),
    mat_pc_graphics_rec VARCHAR(255),
    created_at VARCHAR(100),
    updated_at VARCHAR(100)
);


CREATE TABLE application_genres (
    appid INT,
    genre_id INT,
    PRIMARY KEY (appid, genre_id),
    FOREIGN KEY (appid) REFERENCES applications(appid),
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

CREATE TABLE application_platforms (
    appid INT,
    platform_id INT,
    PRIMARY KEY (appid, platform_id),
    FOREIGN KEY (appid) REFERENCES applications(appid),
    FOREIGN KEY (platform_id) REFERENCES platforms(id)
);

CREATE TABLE application_publishers (
    appid INT,
    publisher_id INT,
    PRIMARY KEY (appid, publisher_id),
    FOREIGN KEY (appid) REFERENCES applications(appid),
    FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/application_categories.csv'
INTO TABLE application_categories
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/application_developers.csv'
INTO TABLE application_developers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

*/

USE SteamDB;


CREATE TABLE IF NOT EXISTS reviews (
    recommendationid VARCHAR(50) PRIMARY KEY,
    appid INT,
    author_steamid VARCHAR(50),
    author_num_games_owned INT,
    author_num_reviews INT,
    author_playtime_forever INT,
    author_playtime_last_two_weeks INT,
    author_playtime_at_review INT,
    author_last_played VARCHAR(50),
    language VARCHAR(50),
    review_text TEXT,
    timestamp_created VARCHAR(50),
    timestamp_updated VARCHAR(50),
    voted_up VARCHAR(10),
    votes_up INT,
    votes_funny INT,
    weighted_vote_score VARCHAR(50), 
    comment_count INT,
    steam_purchase VARCHAR(10),
    received_for_free VARCHAR(10),
    written_during_early_access VARCHAR(10),
    created_at VARCHAR(100),
    updated_at VARCHAR(100)
);
