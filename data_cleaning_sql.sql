select * from netflix_raw_data

--1. to find any duplicates 
select show_id, count(1) no_of_shows
from netflix_raw_data
group by show_id
having count(1)>1

--2.

select * 
from netflix_raw_data
where concat(upper(title),type) in 
	(
	select concat(upper(title),type)
	from netflix_raw_data
	group by title,type
	having count(1)>1
	)
	order by title 


-- creating new tables
--1. netflix table

select show_id, type, title, extract(year from cast(date_added as date)) as date_added, release_year,
rating, case when duration is null then rating else rating end as duartion, description
into netflix
from netflix_raw_data

select * from netflix

--2.genre table

select
	show_id,
	trim(regexp_split_to_table(listed_in,',')) as genre
into netflix_genre
from netflix_raw_data
--cross apply string_split(listed_in,',') 
--this mysql function which splits the string into multiple rows and cross apply- will apply this new table to original table

select * from netflix_genre

--3.
select show_id, director
into netflix_director
from netflix_raw_data

select show_id, country
into netflix_country
from netflix_raw_data



select nr.show_id, nr.country
from netflix_raw_data nr
join 
	(
	select country, director
	from netflix_director nd
	join netflix_country nc on nd.show_id=nc.show_id
	group by country, director
	) m on nr.director = m.director
	where nr.country is null
 