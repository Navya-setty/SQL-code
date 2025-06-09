use db5;

create table db5.unvi_rank(
name varchar(255),
scores_teaching varchar(255),
scores_research varchar(255),
scores_citations varchar(255),
scores_industry_income varchar(255),
scores_international_outlook varchar(255),
record_type varchar(255),
member_level varchar(255),
location varchar(255),
stats_number_students varchar(255),
stats_student_staff_ratio varchar(255),
stats_pc_intl_students varchar(255),
stats_female_male_ratio varchar(255),
subjects_offered text,
closed varchar(255),
unaccredited varchar(255),
overall_score varchar(255)
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/world_university_rankings.csv" 
into table db5.unvi_rank
fields terminated by ","
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select count(distinct(subjects_offered)) from db5.unvi_rank;
select * from db5.unvi_rank;

create table db5.ev(
region varchar(255),
category varchar(255),
parameter varchar(255),
mode varchar(255),
powertrain varchar(255),
year varchar(255),
unit varchar(255),
value varchar(255)
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dataEV.csv" 
into table db5.ev
fields terminated by ","
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select distinct(region) from db5.ev;
select distinct(location) from db5.unvi_rank;

SET SQL_SAFE_UPDATES = 0;

update db5.unvi_rank
set location= "USA"
where location= "United States";

SET SQL_SAFE_UPDATES = 1;

select * from db5.unvi_rank;
SET SQL_SAFE_UPDATES = 0;
UPDATE db5.unvi_rank
SET stats_pc_intl_students = REPLACE(stats_pc_intl_students, '%', '');
SET SQL_SAFE_UPDATES = 1;
select * from db5.unvi_rank;

create table db5.unvi_rank1(
name varchar(255),
scores_teaching float(50),
scores_research float(50),
scores_citations float(50),
scores_industry_income float(50),
scores_international_outlook float(50),
record_type varchar(255),
member_level varchar(255),
location varchar(255),
stats_number_students float(50),
stats_student_staff_ratio float(50),
stats_pc_intl_students float(50),
stats_female_male_ratio varchar(255),
subjects_offered text,
closed varchar(255),
unaccredited varchar(255),
overall_score float(50)
);

select * from db5.unvi_rank;

SET SQL_SAFE_UPDATES = 0;
update db5.unvi_rank
set overall_score= substring_index(overall_score,"–",-1);
SET SQL_SAFE_UPDATES = 1;

select * from db5.unvi_rank where overall_score like "%–%";

select * from db5.unvi_rank;

SET SQL_SAFE_UPDATES = 0;
update db5.unvi_rank
set scores_teaching= replace(scores_teaching,"n/a","0");
update db5.unvi_rank
set scores_research= replace(scores_research,"n/a","0");
update db5.unvi_rank
set scores_citations= replace(scores_citations,"n/a","0");
update db5.unvi_rank
set scores_industry_income= replace(scores_industry_income,"n/a","0");
update db5.unvi_rank
set scores_international_outlook= replace(scores_international_outlook,"n/a","0");
update db5.unvi_rank
set overall_score= replace(overall_score,"n/a","0");
SET SQL_SAFE_UPDATES = 1;

SET SQL_SAFE_UPDATES = 0;
update db5.unvi_rank
set stats_number_students= replace(stats_number_students,",","");
SET SQL_SAFE_UPDATES = 1;


select * from db5.unvi_rank limit 5 offset 2120; 


insert into db5.unvi_rank1 select name,
scores_teaching,
scores_research,
scores_citations,
scores_industry_income,
scores_international_outlook,
record_type,
member_level,
location,
stats_number_students,
stats_student_staff_ratio,
case 
	when stats_pc_intl_students="" then 0
    else CAST(stats_pc_intl_students AS float)
end as stats_pc_intl_students,
stats_female_male_ratio,
subjects_offered,
closed,
unaccredited,
overall_score
 from db5.unvi_rank;
 
 select * from db5.unvi_rank1;
 select location, count(name) as num_of_unvi from db5.unvi_rank1 group by location order by location;
 
 select location, count(name) as num_of_unvi from db5.unvi_rank1 group by location order by num_of_unvi desc;
 
select * from db5.unvi_rank1;

select location, avg(case when overall_score !=0 then overall_score else null end) as avg_overall_score from db5.unvi_rank1 group by location order by avg_overall_score desc; 

select u.name, u.location, u.overall_score as max_overall_score from db5.unvi_rank1 as u join (select location, max(overall_score) as max_score from db5.unvi_rank1 group by location) as m on u.location= m.location and u.overall_score= m.max_score;

select u.name, u.location, u.overall_score as min_overall_score from db5.unvi_rank1 as u join (select location, min(case when overall_score !=0 then overall_score else null end) as min_score from db5.unvi_rank1 group by location) as m on u.location= m.location and u.overall_score= m.min_score;

select u.name, u.location, u.stats_number_students as min_number_students from db5.unvi_rank1 as u join (select location, min(case when stats_number_students !=0 then stats_number_students else null end) as min_number from db5.unvi_rank1 group by location) as m on u.location= m.location and u.stats_number_students= m.min_number;

select u.name, u.location, u.stats_number_students as max_number_students from db5.unvi_rank1 as u join (select location, max(stats_number_students) as max_number from db5.unvi_rank1 group by location) as m on u.location= m.location and u.stats_number_students= m.max_number;

select u.name, u.location, u.stats_number_students as max_avg_number_students from db5.unvi_rank1 as u join (select location, avg(case when stats_number_students !=0 then stats_number_students else null end) as max_students from db5.unvi_rank1 group by location) as m on u.location= m.location and u.stats_number_students>m.max_students order by location;

select u.name, u.location, u.stats_number_students as min_avg_number_students from db5.unvi_rank1 as u join (select location, avg(case when stats_number_students !=0 then stats_number_students else null end) as min_students from db5.unvi_rank1 group by location) as m on u.location= m.location and u.stats_number_students<m.min_students order by location;

select u.name, u.location, u.overall_score as max_overall_score from db5.unvi_rank1 as u join (select location, avg(case when overall_score !=0 then overall_score else null end) as max_score from db5.unvi_rank1 group by location) as m on u.location= m.location and u.overall_score>m.max_score order by location;

select u.name, u.location, u.overall_score as min_overall_score from db5.unvi_rank1 as u join (select location, avg(case when overall_score !=0 then overall_score else null end) as min_score from db5.unvi_rank1 group by location) as m on u.location= m.location and case when u.overall_score !=0 then u.overall_score else null end <m.min_score order by location;

with ranked_data as(select name, location, overall_score, rank() over(partition by location order by overall_score desc) as rank_score from db5.unvi_rank1)
select * from ranked_data where rank_score=1 order by location;

select location, max(stats_pc_intl_students) max_intl_students from db5.unvi_rank1 group by location order by max_intl_students desc;

select location, avg(stats_pc_intl_students) from db5.unvi_rank1 group by location;

select name, location, stats_pc_intl_students from db5.unvi_rank1 order by stats_pc_intl_students desc;

select subjects_offered, count(name)as num_unvi_offering, sum(stats_number_students) as sum_of_students from db5.unvi_rank1 group by subjects_offered order by sum_of_students desc;

select location, subjects_offered, count(name) as num_unvi_offering,sum(stats_number_students) as sum_of_students from db5.unvi_rank1 group by location,subjects_offered order by num_unvi_offering desc;

select name, max(stats_student_staff_ratio) as max_studet_to_staff from db5.unvi_rank1 group by name order by max_studet_to_staff desc limit 1;

select name, min(stats_student_staff_ratio) as min_studet_to_staff from db5.unvi_rank1 group by name order by min_studet_to_staff limit 1;

select name, max(scores_research) as max_scores_research from db5.unvi_rank1 group by name order by max_scores_research desc limit 1;

select name, min(scores_research) as min_scores_research from db5.unvi_rank1 group by name order by min_scores_research limit 1;

select * from db5.ev;

create table db5.ev1(
region varchar(255),
category varchar(255),
parameter varchar(255),
mode varchar(255),
powertrain varchar(255),
year varchar(255),
unit varchar(255),
value float(50)
);

insert into db5.ev1 select * from db5.ev;

select unit, parameter, avg(value) as average_value from db5.ev1 group by parameter, unit;

select region,parameter, avg(value) as average_value from db5.ev1 group by region, parameter order by average_value desc;

with ev_unit_rank as(select e.region, e.parameter, e.mode, e.unit, e.value, u.name, u.overall_score, u.stats_number_students from db5.unvi_rank1 u join db5.ev1 e on u.location= e.region)
select count(*) from ev_unit_rank;

select e.region, e.parameter, e.mode, e.unit, e.value, u.name, u.overall_score, u.stats_number_students, e.value from db5.unvi_rank1 u join db5.ev1 e on u.location= e.region;