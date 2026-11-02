USE SteamDB;


#indie game calc minigame
-- 1. Create the Minigame Score Table
CREATE TABLE IF NOT EXISTS player_scores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_name VARCHAR(50),
    best_score INT
);
INSERT IGNORE INTO player_scores (id, player_name, best_score) VALUES (1, 'Player 1', 0);

#indie game calc
DELIMITER //
DROP PROCEDURE IF EXISTS CookIndieGame //
CREATE PROCEDURE CookIndieGame(IN ingred_1 VARCHAR(50), IN ingred_2 VARCHAR(50), IN dish_price INT)
BEGIN
    DECLARE final_score INT;
    DECLARE current_high_score INT;

    -- Calculate the viability score
    -- We use COALESCE to ensure if the AVG is NULL (no games found), it defaults to 50.
    SELECT 
        ROUND(
            -- 50% weight from Critic Scores (AVG automatically ignores NULLs)
            COALESCE(AVG(a.metacritic_score), 50) * 0.5 +  
            
            -- 30% weight from 2025 Player Reviews (Weighted Vote Score)
            COALESCE(AVG(CAST(r.weighted_vote_score AS DECIMAL(5,4))) * 100, 50) * 0.3 + 
            
            -- 20% weight: Bonus if the player's price is cheaper than the market average
            (CASE 
                WHEN dish_price <= COALESCE(AVG(a.mat_initial_price), 1000) THEN 20 
                ELSE 5 
            END)
        , 0)
    INTO final_score
    FROM applications a
    JOIN application_genres ag1 ON a.appid = ag1.appid
    JOIN genres g1 ON ag1.genre_id = g1.id
    JOIN application_genres ag2 ON a.appid = ag2.appid
    JOIN genres g2 ON ag2.genre_id = g2.id
    LEFT JOIN reviews r ON a.appid = r.appid
    WHERE g1.name = ingred_1 
      AND g2.name = ingred_2;
      
    -- Cap the score between 0 and 100
    IF final_score > 100 THEN SET final_score = 100; END IF;
    IF final_score < 0 THEN SET final_score = 0; END IF;

    -- Track High Score
    SELECT best_score INTO current_high_score FROM player_scores WHERE id = 1;
    IF final_score > current_high_score THEN
        UPDATE player_scores SET best_score = final_score WHERE id = 1;
        SET current_high_score = final_score;
    END IF;

    -- Send back to Godot
    SELECT final_score AS score, current_high_score AS high_score;
END //
DELIMITER ;

#add to library/ favorite 
-- 2. Create the User Library / Favorites Table
CREATE TABLE IF NOT EXISTS favorite_games (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appid INT UNIQUE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appid) REFERENCES applications(appid) ON DELETE CASCADE
);

#save the favorite games



#insert game
DELIMITER //
DROP PROCEDURE IF EXISTS InsertGame //
CREATE PROCEDURE InsertGame(
    IN p_appid INT, IN p_name VARCHAR(255), IN p_price INT, IN p_is_free VARCHAR(10)
)
BEGIN
    INSERT INTO applications (appid, name, mat_initial_price, is_free, type)
    VALUES (p_appid, p_name, p_price, p_is_free, 'game');
    
    SELECT 'Game Added Successfully' AS message, p_appid AS appid;
END //
DELIMITER ;


#delete game
DELIMITER //
DROP PROCEDURE IF EXISTS DeleteGame //
CREATE PROCEDURE DeleteGame(IN p_appid INT)
BEGIN
    -- Delete from junction tables first
    DELETE FROM application_genres WHERE appid = p_appid;
    DELETE FROM application_platforms WHERE appid = p_appid;
    DELETE FROM application_publishers WHERE appid = p_appid;
    DELETE FROM favorite_games WHERE appid = p_appid;
    
    -- Finally, delete the master record
    DELETE FROM applications WHERE appid = p_appid;
    
    SELECT 'Game completely wiped from database' AS message;
END //
DELIMITER ;


#search/sort(via name letter,  genre, price, author name letter,  publisher name, popularity, reviews)
DELIMITER //
DROP PROCEDURE IF EXISTS SearchGames //
CREATE PROCEDURE SearchGames(
    IN p_search_term VARCHAR(255), 
    IN p_genre VARCHAR(50),  
    IN p_os VARCHAR(20),     
    IN p_sort_type VARCHAR(50) 
)
BEGIN
    SELECT a.appid, a.name, a.mat_initial_price, a.metacritic_score, a.recommendations_total, a.release_date
    FROM applications a
    WHERE a.name LIKE CONCAT('%', p_search_term, '%')
      -- Genre Filter (Skips if empty)
      AND (p_genre = '' OR a.appid IN (
          SELECT ag.appid 
          FROM application_genres ag
          JOIN genres g ON ag.genre_id = g.id
          WHERE g.name = p_genre
      ))
      -- OS Filter (Skips if empty)
      AND (
          p_os = '' 
          OR (p_os = 'windows' AND a.mat_supports_windows = 'True')
          OR (p_os = 'mac' AND a.mat_supports_mac = 'True')
          OR (p_os = 'linux' AND a.mat_supports_linux = 'True')
      )
    ORDER BY 
        CASE WHEN p_sort_type = 'Popularity' THEN a.recommendations_total END DESC,
        CASE WHEN p_sort_type = 'Price' THEN a.mat_initial_price END ASC,
        CASE WHEN p_sort_type = 'Release Date' THEN a.release_date END DESC,
        CASE WHEN p_sort_type = 'Name' THEN a.name END ASC
    LIMIT 50;
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS ToggleFavorite //
CREATE PROCEDURE ToggleFavorite(IN p_appid INT)
BEGIN
    IF EXISTS (SELECT 1 FROM favorite_games WHERE appid = p_appid) THEN
        DELETE FROM favorite_games WHERE appid = p_appid;
        SELECT 'Removed from Library' AS status;
    ELSE
        INSERT INTO favorite_games (appid) VALUES (p_appid);
        SELECT 'Added to Library' AS status;
    END IF;
END //
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS GetLibrary //
CREATE PROCEDURE GetLibrary()
BEGIN
    SELECT a.appid, a.name, a.mat_initial_price, f.added_at
    FROM favorite_games f
    JOIN applications a ON f.appid = a.appid
    ORDER BY f.added_at DESC;
END //
DELIMITER ;


#tag system
DELIMITER //
DROP PROCEDURE IF EXISTS SearchGames //
CREATE PROCEDURE SearchGames(
    IN p_search_term VARCHAR(255), 
    IN p_tag VARCHAR(255),     -- NEW: Filter by Tag (Genre)
    IN p_sort_type VARCHAR(50) 
)
BEGIN
    SELECT a.appid, a.name, a.mat_initial_price, a.metacritic_score, a.recommendations_total
    FROM applications a
    WHERE a.name LIKE CONCAT('%', p_search_term, '%')
      -- If p_tag is empty, skip this filter. If it has text, search the junction table.
      AND (p_tag = '' OR a.appid IN (
          SELECT ag.appid 
          FROM application_genres ag
          JOIN genres g ON ag.genre_id = g.id
          WHERE g.name = p_tag
      ))
    ORDER BY 
        CASE WHEN p_sort_type = 'popularity' THEN a.recommendations_total END DESC,
        CASE WHEN p_sort_type = 'reviews' THEN a.metacritic_score END DESC,
        CASE WHEN p_sort_type = 'price_asc' THEN a.mat_initial_price END ASC,
        CASE WHEN p_sort_type = 'price_desc' THEN a.mat_initial_price END DESC,
        CASE WHEN p_sort_type = 'name' THEN a.name END ASC
    LIMIT 50;
END //
DELIMITER ;
