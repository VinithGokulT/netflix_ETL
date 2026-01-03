select * from netflix_show where title = 'blood & water'

select * from casting -- title and cast of the movie

select * from country --title and country where produced

select  * from genre where listed_in like '%Horror%'-- title and listed_in (shows)
--netflix data analysis

/*1  for each director count the no of movies and tv shows created by them in separate columns 
for directors who have created tv shows and movies both */


select director, 
	sum (case when type = 'Movie' then 1 else 0 end) "no_of_movies",
	sum (case when type = 'TV Show' then 1 else 0 end) "no_of_tvShows"
		from netflix_show
			group by director
			having 
				sum (case when type = 'Movie' then 1 else 0 end) >0 and
				sum (case when type = 'TV Show' then 1 else 0 end)> 0


--2 which country has highest number of comedy movies 
select country, count(1) no_of_comedy_movies from 
	netflix_show n 
	join genre g on n.title = g.title
	join country c on n.title = c.title
		where listed_in = 'Comedies'
		and type = 'Movie'
		group by country order by 2 desc limit 1



--3 for each year (as per date added to netflix), which director has maximum number of movies released

select director, added_year, no_of_movies_released
from
(	select director, added_year, count(1) no_of_movies_released,
	row_number()over(partition by added_year order by count(1) desc) ranking
		from netflix_show
		where director is not null
		and director != 'nan'
		and added_year is not null
		group by director, added_year 
)
where ranking = 1


--4 what is average duration of movies in each genre

select  
	listed_in as genre, 
	Round(avg(duration_time)::numeric,2) average_duration
from netflix_show n 
join genre g 
	on n.title = g.title
where type = 'Movie' 
	and duration_time is not null
group by listed_in

--5  find the list of directors who have created horror and comedy movies both.
-- display director names along with number of comedy and horror movies directed by them 
select director,
	sum(case when listed_in = 'Comedies' then 1 else 0 end) no_of_comedy_movies,
	sum(case when listed_in like '%Horror%' then 1 else 0 end) no_of_horror_movies
from netflix_show n 
join genre g on n.title = g.title
join country c on n.title = c.title
where listed_in in ('Comedies', 'Horror Movies')
	and type = 'Movie'
	and director !='nan'
	group by director
	having sum(case when listed_in = 'Comedies' then 1 else 0 end) >1
	and sum(case when listed_in like '%Horror%' then 1 else 0 end) >1


