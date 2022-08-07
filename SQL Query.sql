
-- create database avocado;

use avocado;

-- selecting all columns in the table

select count(*) as total_records
from avocado;

-- filtering by region

select * 
from avocado 
where region like 'orlando';

--grouping by region

select region,
	AVG(averageprice) as price
from avocado
group by region;

-- conditioned column

with regional_average as(
			select  region,
				AVG(averageprice) as price
				from avocado
				group by region
			)
select region, 
       case
	  when price > (select avg(averageprice) 
			from avocado
			)
	  then 'expensive'
	  else 'inexpensive'
       end price_category
from regional_average;

GO

-- selecting Top 10

select top 10 type, 
	      Small_Bags, 
	      Large_Bags
from avocado 
order by Small_Bags desc, Large_Bags desc;
go

-- creating an unpivoted table

select type, 
       category, 
       amount
from avocado
unpivot(amount for category in (Small_Bags,Large_Bags)
) as unpivot_example;
go


-- creating a pivoted table 
With new_table as 
		(select 
			region, 
			Total_Bags as value,
			year 
		from avocado)
select * from new_table
pivot (sum(value) for year in ("2015","2016","2017","2018")

) as pivoted;

Go


select category, 
	type, 
	value 
from avocado
unpivot(value for category in (small_bags, large_bags, xlarge_bags)) as unpivoted_table;
go

-- merging tables in SQL
select 	ac.date, 
	case 
		when h.holiday is null 
		then 'normal day'
		else h.holiday
	end category 
from holiday h
right join avocado_cleaned ac
on h.date = ac.date;
go

-- average price on normal and holiday

with tab2 as(
select 
	ac.date, 
	averageprice,
	case 
		when h.holiday is null 
		then 'normal day'
		else h.holiday
	end category 
from holiday h
right join avocado_cleaned ac
on h.date = ac.date
)
select category, 
	avg(averageprice) as price 
from tab2
group by category
order by price;
go
