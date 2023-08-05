create database indian_census;
use indian_census;

#TO SHOW TABLES IN OUR DATABASE INDIAN_CENSUS
show tables;

#TO KNOW THE STRUCTURE OF THE TABLE
describe dataset1;
describe dataset2;

#TO GET THE RECORDS OF A TABLE
select * from dataset1;
select * from dataset2;

# TO GET THE NUMBER OF RECORDS IN THE TABLE
select count(*) from dataset1;
select count(*) from dataset2;

# TO GET THE DATASET FOR ANDHRA PRADESH AND KERALA
select * from dataset1
	where state  in ("Andhra Pradesh","Kerala");

#TO GET THE POPULATION OF INDIA
select SUM(Population) POPULATION from dataset2;

# TO GET THE AVERAGE GROWTH IN PERCENTAGE
select ROUND(avg(Growth)*100,2) AVERAGE_GROWTH from dataset1;

# TO GET THE  AVERAGE GROWTH IN PERCENTAGE OF EVERY STATE
select State, round(avg(Growth)*100,2) AVERAGE_GROWTH 
from dataset1 
group by State;

#TO GET THEAVERAGE SEX RATIO IN PERCENTAG OF EVERY STATE IN DESCENDING ORDER 
select state, round(avg(Sex_Ratio),2) AVERAGE_SEX_RATIO 
from dataset1
group by state
order by avg(sex_ratio) desc;

# TO GET THE AVERAGE LITERACY RATE OF EVERY STATE IN ASCENDING ORDER
select state,round(avg(Literacy),2) AVERAGE_LITERACY 
FROM dataset1
group by state having round(avg(Literacy),2)>90
order by avg(Literacy) asc;

#TO GET ThE TOP 3 STATES SHOWING HIGHEST GROWTH
select state ,round(avg(Growth)*100,2) AVERAGE_GROWTH
from dataset1
group by state
order by avg(Growth)*100 desc
limit 3;

# TO GET THE BOTTOM 3 STATES SHOWING LOWEST SEX_RATIO
select state ,round(avg(Sex_Ratio),0) AVERAGE_SEX_RATIO
from dataset1
group by state
order by AVERAGE_SEX_RATIO asc
limit 3;

# TO GET THE TOP AND BOTTOM 3 STATES BY LITERACY
use indian_census;
drop table  if exists topbottom;
create table topbottom(state varchar(100),literacy float);
insert into topbottom
select state,round(avg(Literacy),0) AVERAGE_LITERACY
FROM dataset1
GROUP BY state
order by AVERAGE_LITERACY desc
limit 3;

insert into topbottom
select state,round(avg(Literacy),0) AVERAGE_LITERACY
FROM dataset1
GROUP BY state
order by AVERAGE_LITERACY asc
limit 3;
select * from topbottom order by literacy desc;

 # TO GET THE TOP AND BOTTOM STATES IN LITERACY RATE USING UNION OPERATOR
create table top(state varchar(100), literacy_rate float);
insert into topbottom
select state,round(avg(Literacy),0) AVERAGE_LITERACY
FROM dataset1
GROUP BY state
order by AVERAGE_LITERACY asc;

select * from
(select state ,literacy_rate
from top 
order by literacy_rate desc
limit 3) a
union 
select * from
(select state ,literacy_rate
from top 
order by literacy_rate asc
limit 3) b;

# TO GET THE STATES THAT THEIR NAME STARTS WITH A
select  distinct state 
from dataset1 
where lower(state) like "a%";

#TO GET THE STATES THAT THEIR NAME STARTS WITH A AND ENDS WITH D
select distinct state 
from dataset1
where lower(state) like "a%" and lower(state) like  "%h";

# TO GET THE STATES THAT THEIR NAME STARTS WITH A OR B 
select distinct state
from dataset1 
where lower(state) like "a%" or  lower(state) like "b%";

#TO GET THE NO OF MALES AND FEMALES
select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,(a.sex_ratio/1000) sex_ratio,b.population from dataset1 a inner join dataset2 b on a.district=b.district) as c) as d 
group by d.state;

# TO GET THE LITERACY RATIO 
select d.state,sum(d.literate_people) total_literate ,sum(d.illiterate_people) total_illiterate  from
(select c.district,c.state, round(c.literacy_ratio*c.population,0) literate_people, round((1-c.literacy_ratio)*c.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 as literacy_ratio,b.population from dataset1 a inner join dataset2 b on a.district=b.district) as c )as d
group by d.state
order by total_literate desc;
 
 # TO GET THE PREVIOUS CENSUS
 select sum( e.total_previous_population) previous_year_population,sum(e.total_current_population) current_year_population from
 (select d.state,sum(d.previous_census) total_previous_population,sum(d.current_census) total_current_population from
 (select c.district,c.state,round(c.population/(1+c.growth),0) previous_census, c.population current_census from
( select a.district, a.state,a.growth growth ,b.population from dataset1 a inner join dataset2 b on a.district=b.district) c) d
group by d.state) e ; 

# TO GET THE POPULATION V/S AREA
select g.area/g.previous_year_population previous_population_vs_area, g.area/current_year_population current_population_vs_area from
(select q.*,p.* from
 (select '1' as id,m.* from
 (select sum( e.total_previous_population) previous_year_population,sum(e.total_current_population) current_year_population from
 (select d.state,sum(d.previous_census) total_previous_population,sum(d.current_census) total_current_population from
 (select c.district,c.state,round(c.population/(1+c.growth),0) previous_census, c.population current_census from
( select a.district, a.state,a.growth growth ,b.population from dataset1 a inner join dataset2 b on a.district=b.district) c) d
group by d.state) e )m) q   
inner join 
(select '1' as id2,n.* from
(select sum(area_km2) area from dataset2) n) p on q.id=p.id2) g ;

#TO GET THE TOP 3 DISTRICTS IN EACH STATE BY LITERACY
select a.* from
(select state,district,literacy, rank() over(partition by state order by literacy desc)  literacy_rank from dataset1) a
where literacy_rank in(1,2,3) order by a.state;




