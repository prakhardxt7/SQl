USE ig_clone; 
-- Problem Statement 1
-- Retrieve Information of the top 5 oldest users that joined instagram for rewarding purpose
-- sol. we can get the data of all the 5 oldest users along with dates using order by function according to date of creatiojn
SELECT *
FROM users
ORDER BY created_at
LIMIT 5;

-- Statement 1 Solved

-- Problem Statement 2
-- Retrieve the day name of the week when users registered the most
-- This can be done for holding various ad campaign.
-- sol. just fetch the day name using date time function and count all numbers of rows group by those day names and 
-- order all the day name according to the count in descending order with limit.

SELECT DAYNAME(created_at) AS day_name,
		COUNT(*) as total
        FROM users
        GROUP BY day_name
        ORDER BY total desc limit 2;
 -- Limt is here we took 2 because there is 2 dayname we got with high numbers this operation is first done with limit 5 so we can check any duplication is there or not
 
 -- Statement 2 Solved
 
 
 -- Problem Statement 3
-- Retrive the data of all the inactive users or the users who haven't posted any photo
-- This can be used for email campaign for encouraging the inactive people for posting the photos and staying active
-- 1ST APPROACH IS CHECKING IMAGE URL IS NULL AFTER USING LEFT JOIN
SELECT username FROM users
	LEFT JOIN photos
    ON users.id = photos.user_id
    WHERE image_url is NULL;
    
-- 2ND APPROACH IS CHECKING IMAGE ID IS NULL AFTER USING LEFT JOIN
SELECT username FROM users
	LEFT JOIN photos
    ON users.id = photos.user_id
    WHERE photos.id is NULL;
    
-- Statement 3 Solved



-- Problem Statement 4
-- Finding the username with the most number of likes on single photo.alter
-- sol. We need to join thyree table for fetching the username photoid number of llikes and group by them according to photoid and order by them with count of likes in descending order along with limit sets to 1

SELECT username,photos.id,image_url,count(*) as total
	FROM photos
    JOIN users ON photos.user_id = users.id
    JOIN likes ON photos.id = likes.photo_id
    GROUP BY photos.id
    ORDER BY total DESC LIMIT 1;
    
    
-- Statement 4 solved


-- Problem Statement 5
-- We need to find how many times does an average user posts,basically it is an approach to find the engagement of people in general
-- sol. Avg user post = Total number of photos/total number of users.alter.
SELECT (SELECT COUNT(*) FROM photos)/(SELECT COUNT(*) FROM users) as avg;

-- Statement 5 solved


-- Problem Statement 6
-- Fetch top 5 most used hashtags
-- for this we need two tables tags and photo_tag inner join both and group by tag_name and order by count of tags in descending order with limit 1

SELECT tag_name,count(*) AS total FROM tags
	JOIN photo_tags ON photo_tags.tag_id = tags.id
    GROUP BY tag_name
    ORDER BY total DESC LIMIT 5;
    
    
    
-- Statement 6 solved


-- Problem Statement 7
-- Find the usernames who liked all the photos basically finding the bots
-- sol. we will join two tables i.e users and likes and group them by user id and fetch only those username having conditions of likes = total number of photos

SELECT username, Count(*) AS num_likes 
FROM   users 
       INNER JOIN likes 
               ON users.id = likes.user_id 
GROUP  BY likes.user_id 
HAVING num_likes = (SELECT Count(*) 
                    FROM   photos); 
                    
                    
                    
-- Statement 7 Solved




-- Problem Statement 8
-- Prevent users from following themselves
-- by using triggers we can prevent users from following them own

DELIMITER $$
CREATE TRIGGER prevent_self_follows
BEFORE INSERT ON follows FOR EACH ROW
BEGIN 
	IF NEW.follower_id = NEW.followee_id
    THEN
		SIGNAL SQLSTATE  '45000'
        SET MESSAGE_TEXT = 'YOU CANNOT FOLLOW YOURSELF';
    END IF;
END;
$$


-- Statement 8 solved