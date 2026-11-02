USE SteamDB;

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