create database pizza_runner;
use pizza_runner;

#TABLE---- RUNNERS
create table runners(runner_id int, registration_date date);
insert into runners values (1, '2021-01-01');
insert into runners values(2, '2021-01-03');
insert into runners values (3, '2021-01-08');
insert into runners values (4, '2021-01-15');

select * from runners;

#TABLE----CUSTOMER_ORDERS
create table customer_orders(order_id int,customer_id int, pizza_id int, exclusions varchar(5), extras varchar(5),order_time timestamp);
insert into customer_orders values('1', '101', '1', '', '', '2020-01-01 18:05:02');
insert into customer_orders values ('2', '101', '1', '', '', '2020-01-01 19:00:52');
insert into customer_orders values ('3', '102', '1', '', '', '2020-01-02 23:51:23');
insert into customer_orders values ('3', '102', '2', '', 'NULL', '2020-01-02 23:51:;3');
insert into customer_orders values('4', '103', '1', '4', '', '2020-01-04 13:23:46');
insert into customer_orders values ('4', '103', '1', '4', '', '2020-01-04 13:23:46');
insert into customer_orders values('4', '103', '2', '4', '', '2020-01-04 13:23:46');
insert into customer_orders values('5', '104', '1', 'null', '1', '2020-01-08 21:00:29');
insert into customer_orders values ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13');
insert into customer_orders values('7', '105', '2', 'null', '1', '2020-01-08 21:20:29');
insert into customer_orders values ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33');
insert into customer_orders values('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59');
insert into customer_orders values ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49');
insert into customer_orders values('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
  
  select * from customer_orders;
  

  
 
  
  # TABLE ---- RUNNER_ORDERS
  create table runner_orders(order_id int, runner_id int, pickup_time varchar(20), distance varchar(7), duration varchar(10), cancellation varchar(25));
  
  insert into runner_orders values ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', '');
  insert into runner_orders values('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', '');
  insert into runner_orders values('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL);
  insert into runner_orders values('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL);
  insert into runner_orders values('5', '3', '2020-01-08 21:10:57', '10', '15', NULL);
  insert into runner_orders values('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation');
  insert into runner_orders values('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null');
  insert into runner_orders values('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null');
  insert into runner_orders values('9', '2', 'null', 'null', 'null', 'Customer Cancellation');
  insert into runner_orders values('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

  select * from runner_orders;
  
 
  #TABLE ----PIZZA_NAMES
  create table pizza_names( pizza_id int, pizza_name text);
  insert into pizza_names values(1, 'Meatlovers');
  insert into pizza_names values(2, 'Vegetarian');
  
  select * from pizza_names;
  
  #TABLE ----PIZZA_RECIPES
  create table pizza_recipes (pizza_id int,toppings text);
  insert into pizza_recipes values(1, '1, 2, 3, 4, 5, 6, 8, 10');
  insert into pizza_recipes values(2, '4, 6, 7, 9, 11, 12');

 #TABLE ----PIZZA_TOPINGS
 create table pizza_toppings(topping_id int,topping_name text);
 insert into pizza_toppings values(1, 'Bacon');
 insert into pizza_toppings values(2, 'BBQ Sauce');
 insert into pizza_toppings values(3, 'Beef');
 insert into pizza_toppings values  (4, 'Cheese');
 insert into pizza_toppings values (5, 'Chicken');
 insert into pizza_toppings values (6, 'Mushrooms');
 insert into pizza_toppings values(7, 'Onions');
 insert into pizza_toppings values(8, 'Pepperoni');
 insert into pizza_toppings values (9, 'Peppers');
 insert into pizza_toppings values (10, 'Salami');
 insert into pizza_toppings values(11, 'Tomatoes');
 insert into pizza_toppings values(12, 'Tomato Sauce');
  
  select * from pizza_toppings;
  
  show tables;
  select count(pizza_id) from customer_orders;
  
  #-----DATA CLEANING PROCESS ---------
  
   update customer_orders 
  set exclusions=" " where exclusions="";
  update customer_orders
  set extras=" " where extras="";
  
  select * from customer_orders;
  
  update runner_orders
  set pickup_time=null where pickup_time ="null";
  update runner_orders
  set distance=null where distance ="null" ;
  update runner_orders
  set distance=trim("km" from distance) where distance like "%km" ;
  update runner_orders
  set duration=null where duration ="null";
  update runner_orders
  set duration=trim("mins" from duration) where duration like "%mins";
  update runner_orders
  set duration=trim("minute" from duration) where duration like "%minute";
   update runner_orders
  set duration=trim("minutes" from duration) where duration like "%minutes";
  update runner_orders
  set cancellation=" " where  cancellation="";
  
  alter table runner_orders
  modify column pickup_time datetime null,
  modify column distance float,
  modify column duration int ;
  
  #A.PIZZA METRICS
  #1.   HOW MANY PIZZA'S WERE ORDERED?
  select count(pizza_id)  as pizza_count from customer_orders;
   
  #2. HOW MANY UNIQUE CUSTOMER_ORDERS WERE MADE?
  select count(distinct order_id) as total_unique_rders from customer_orders;
  
  #3.HOW MANY SUCCESSFULL DELIVERS WERE MADE BY EACH RUNNER?
 select runner_id,count(order_id) as successfull_orders
 from runner_orders
 where cancellation=" "
 group by runner_id
 order by runner_id;
 
 #4. HOW MANY TYPE OF EACH PIZZA'S ARE DELIVERED?
 select p.pizza_name, count(p.pizza_id) as pizza_count 
 from customer_orders as c inner join runner_orders as r on c.order_id=r.order_id inner join pizza_names as p on c.pizza_id=p.pizza_id
 where r.cancellation=" "
 group by p.pizza_name;
 
 #5.HOW MANY VEGETARIAN AND MEATLOVERS WERE ORDERED BY EACH CUSTOMER
  select customer_id,
  sum(if(pizza_id=1,1,0)) as meat_lovers,
  sum(if(pizza_id=2,1,0)) as vegetarian
  from customer_orders
  group by customer_id;
  
  #6. WHAT WAS THE MAXIMUM NUMBER OF DELIVERS HAPPENED IN A SINGLE ORDER?
  
  with answer as 
  (select c.order_id,count(c.pizza_id) as pizza_count
  from customer_orders as c inner join runner_orders as r on c.order_id=r.order_id
  where r.cancellation=" "
  group by c.order_id)
  
  select max(pizza_count)  as maximum_count from answer;
  
  #7.FOR EACH CUSTOMER HOW MANY DELIVERED PIZZA'S HAD ATLEAST 1 CHANGE AN DHOW MANY HAD NO CHNAGES?
  select c.customer_id,
  sum((case 
	when c.exclusions=" " and c.extras=" "then 1
    else 0
   end)) as no_changes,
  sum((case 
      when c.exclusions!=" " and c.extras!=" "is not null then 1
      else 0 
   end)) as changes
	from customer_orders as c inner join runner_orders as r on c.order_id=r.order_id
    where r.cancellation=" "
    group by c.customer_id;
  
  
  #8.HOW MANY PIZZA'S WERE DELIVERED THAT HAD BOTH EXCLUSIONS AND EXTRAS?
  
select count(c.pizza_id) as custom_pizza_count
 from customer_orders as c inner join runner_orders as r on c.order_id=r.order_id
 where c.exclusions!=" " and c.extras!=" " and r.cancellation=" ";
 

#9.What was the total volume of pizzas that were ordered per each hour of the day?

select hour(order_time) as hours,count(pizza_id) as pizza_count 
from customer_orders 
where  order_time is not null
group by hours 
order by hours; 
  
 #10. WHAT WAS THE VOLUME OF ORDERS FOR EACH DAY OF THE WEEK?
 
 select a.day_of_week,count(a.order_id) as pizza_count from
 (select order_id,
 (case 
	when weekday(order_time)=0 then "monday"
	when weekday(order_time)=1 then "tuesday"
	when weekday(order_time)=2 then "wednesday"
	when weekday(order_time)=3 then "thursday"
	when weekday(order_time)=4 then "friday"
	when weekday(order_time)=5 then "saturday"
	when weekday(order_time)=6 then "sunday"
end) as day_of_week
from customer_orders) a
group by a.day_of_week;


#B.RUNNER AND CUSTOMER EXPERIENCE

#1.HOW MANY RUNNERS SIGNED UP FOR EACH 1 WEEK PERIOD ?(I.E., WEEK STARTS 2021-01-01
select  week(registration_date) as week_number,count(runner_id) as new_runner from runners
group by week_number
order by week_number;

  
  #2. WHAT WAS THE AVERAGE TIME IN MINUTES IT TOOK FOR EACH RUNNER TO ARRIVE AT THE PIZZA RUNNER HQ TO PICKUP THE ORDER?
  select r.runner_id,avg(timestampdiff(minute,c.order_time,r.pickup_time)) as timing 
  from customer_orders as c inner join runner_orders as r on  c.order_id=r.order_id
  group by runner_id
  order by runner_id;
  
  #3.IS THERE ANY RELATIONSHIP BETWEEN THE NUMBERS OF PIZZA'S AND HOW LONG THE ORDER TAKES  TO PREPARE?
  select avg(m.relation) from
  (select r.order_id,r.pizza_count,r.timing,floor((r.timing/r.pizza_count)) as relation from
  (select c.order_id, count(c.pizza_id) as pizza_count,round(avg(timestampdiff(minute,c.order_time,r.pickup_time)),0) as timing 
  from customer_orders as c inner join runner_orders as r on c.order_id=r.order_id
  where r.pickup_time is not null
  group by order_id) r) m;
  
  
  #4. WHAT WAS THE AVERAGE  DISTANCE TRAVELLED FOR EACH CUSTOMER?
 select c.customer_id,floor(avg(r.distance)) as average_distance_travelled
from customer_orders as c inner join runner_orders as r on c.order_id=r.order_id
group by c.customer_id;
  
  
  #5.WHAT WAS THE DIFFERENCE BETWEEN THE LONGEST AND SHORTEST DELIVERY TIMES FOR ALL ORDERS?
  select max(duration)-min(duration) as difference from runner_orders;
  
  #6. WHAT WAS THE AVERAGE SPEED FOR EACH RUNNER FOR EACH DELIVERY AND DO YOU NOTICE ANY TREND FOR THESE VALUES?
  select runner_id,avg(floor(distance*60)/duration) as speed 
  from runner_orders 
  where cancellation=" "
  group by runner_id;
  
  #8.WHAT IS THE SUCCESSFUL DELIVERY PERCENTAGE FOR EACH RUNNER?
  select runner_id,floor( (count(pickup_time)/count(order_id))*100) as success_percentage from runner_orders
  group by runner_id;
  
  select * from pizza_recipes;
  
  
 
  
  
  
  