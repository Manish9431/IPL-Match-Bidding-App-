USE ipl;

--  1. Show the percentage of wins of each bidder in the order of highest to lowest percentage.

SELECT
    a1.BIDDER_ID,
    b.Bidder_name,
    a1.won,
    a1.total,
    ROUND((a1.won / a1.total) * 100, 1) AS won_per
FROM (
    SELECT
        BIDDER_ID,
        COUNT(BIDDER_ID) AS total,
        COUNT(IF(BID_STATUS = "Won", 1, NULL)) AS won
    FROM IPL_BIDDING_DETAILS
    GROUP BY BIDDER_ID
) a1
JOIN ipl.ipl_bidder_details b 
ON a1.BIDDER_ID = b.BIDDER_ID
ORDER BY won_per DESC;




-- 2. Display the number of matches conducted at each stadium with stadium name, city from the database.
select * from  ipl_stadium;

select i_s.STADIUM_NAME,
	   i_s.CITY, 
       count(i_ms.STADIUM_ID) as count_of_matches from  ipl_stadium as i_s
right join ipl_match_schedule as i_ms
on i_s.STADIUM_ID = i_ms.STADIUM_ID
group by i_s.STADIUM_ID
order by count_of_matches desc;


-- 3. In a given stadium, what is the percentage of wins by a team which has won the toss?
select stadium_name,toss_match_win, total,round((toss_match_win/total)*100,2) as per_win  from 

(select i_s.STADIUM_NAME as stadium_name,
        count(if(MATCH_WINNER = TOSS_WINNER, 1, null)) as toss_match_win, 
        count(*) as total  from ipl_match as i_m
        
inner join ipl_match_schedule i_m_s
inner join ipl_stadium i_s
on i_m.MATCH_ID = i_m_s.MATCH_ID AND i_m_s.STADIUM_ID = i_s.STADIUM_ID
group by i_s.STADIUM_ID) a1;

-- 4. Show the total bids along with bid team and team name.
select b_d.BID_TEAM,
	   i_t.TEAM_NAME,
       count(*) as total_bids 
from ipl.ipl_bidding_details b_d
join ipl.ipl_team as i_t
on b_d.BID_TEAM = i_t.TEAM_ID
group by b_d.BID_TEAM;


-- 5. Show the team id who won the match as per the win details.
-- select *, 
-- 		trim(left(substr(WIN_DETAILS,6),position(' ' in substr(win_details,6)))) as remarks, 
--         position(' ' in substr(win_details,6))  from ipl.ipl_match;

select TEAM_ID, TEAM_NAME,WIN_DETAILS   from IPL_MATCH A 
inner join IPL_TEAM B
on trim(left(substr(WIN_DETAILS,6),position(' ' in substr(win_details,6)))) = B.REMARKS;    -- on remrks = remarks 


-- 6. Display total matches played, total matches won and total matches lost by team along with its team name.
select a.TEAM_ID, 
		b.TEAM_NAME, 	
        sum(MATCHES_PLAYED) as total_played, 
        sum(a.MATCHES_WON) as WON, 
        sum(a.MATCHES_LOST) as LOST
from ipl.ipl_team_standings a
join ipl.ipl_team b
on a.TEAM_ID = b.TEAM_ID
group by a.TEAM_ID;

-- 7. Display the bowlers for Mumbai Indians team.
SELECT  a.TEAM_ID,
		a.PLAYER_ID,
		b.PLAYER_NAME,
        a.PLAYER_ROLE, 
        a.REMARKS, 
        b.PERFORMANCE_DTLS
FROM ipl.ipl_team_players a
join ipl.ipl_player b
on a.PLAYER_ID = b.PLAYER_ID
where a.PLAYER_ROLE like "%Bowler%" and  a.REMARKS like "%MI%"; 


-- 8. How many all-rounders are there in each team, Display the teams with more than 4 all-rounder in descending order. 
SELECT b.TEAM_NAME,
	   a.PLAYER_ROLE, 
       count(a.TEAM_ID) as Total
FROM ipl.ipl_team_players a
inner join ipl.ipl_team b
on a.TEAM_ID = b.TEAM_ID
where a.PLAYER_ROLE = 'All-Rounder' 
group by b.TEAM_NAME
having total > 4
order by Total desc;






