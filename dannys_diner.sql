create database dannys_diner;
use dannys_diner;
create table sales(customer_id int,order_date date,product_id int);
alter table sales
modify column customer_id varchar(2);
describe sales;

insert into sales values('A', '2021-01-01', '1');
insert into sales values('A', '2021-01-01', '2');
insert into sales values('A', '2021-01-07', '2');
insert into sales values('A', '2021-01-10', '3');
insert into sales values('A', '2021-01-11', '3');
insert into sales values('A', '2021-01-11', '3');
insert into sales values('B', '2021-01-01', '2');
insert into sales values('B', '2021-01-02', '2');
insert into sales values('B', '2021-01-04', '1');
insert into sales values('B', '2021-01-11', '1');
insert into sales values('B', '2021-01-16', '3');
insert into sales values('B', '2021-02-01', '3');
insert into sales values('C', '2021-01-01', '3');
insert into sales values('C', '2021-01-01', '3');
insert into sales values('C', '2021-01-07', '3');
select * from sales;
truncate table sales;
create table menu(product_id int,product_name VARCHAR(5),price int);
insert into menu values('1', 'sushi', '10');
insert into menu values('2', 'curry', '15');
insert into menu values('3', 'ramen', '12');
select * from menu;
create table members(customer_id varchar(2),join_date date);
insert into members values('A', '2021-01-07');
insert into members values('B', '2021-01-09');
select * from members;



#1.WHAT IS THE TOTAL AMOUNT EACH CUSTOMER SPENT AT THE RESTAURANT?
select s.customer_id,sum(m.price) as total_amount from sales as s inner join menu as m on s.product_id=m.product_id group by s.customer_id;

#2.HOW MANY DAYS HAS EACH CUSTOMER VISITED THE RESTAURANT?
select s.customer_id,count(distinct s.order_date) as visiting_days from sales as s group by s.customer_id;

#3.WHAT WAS THE FIRST ITEM FROM THE MENU PURCHASED BY EACH CUSTOMER?
with order_details as (select s.customer_id,s.order_date,m.product_name,dense_rank()over(partition by s.customer_id order by s.order_date ) as rankorder
from sales as s inner join menu as m on s.product_id=m.product_id ) 
select customer_id,product_name from order_details 
where rankorder=1
group by customer_id, product_name
order by customer_id;

#4.WHAT IS THE MOST PURCHASED ITEMON THE MENU AND HOW MANY TIMES WAS IT PURCHASED BY ALL CUSTOMERS?
select m.product_name,count(s.product_id) as most_purchased from sales as s inner join menu as m on s.product_id=m.product_id 
group by m.product_name
order by most_purchased desc
limit 1 ;

#5.WHICH ITEM WAS THE MOST POPUALAR FOR EACH CUSTOMER?
with order_count as(
select s.customer_id,m.product_name,count(s.product_id) as count,dense_rank() over(partition by s.customer_id order by count(s.product_id) desc) as max_order from sales as s inner join menu as m on s.product_id=m.product_id group by s.customer_id,m.product_name)
 select customer_id,product_name,count from order_count
 where max_order=1;

#6.WHICH ITEM WAS PURCHASED FIRST BY THE CUSTOMER AFTER THEY BECAME A MEMBER?
with answer as (select after_order.customer_id,after_order.join_date,after_order.order_date,after_order.product_name, dense_rank() over(partition by after_order.customer_id order by after_order.order_date) as ranking  from(
select s.customer_id,m.product_name,ms.join_date,s.order_date
from sales as s inner join menu as m on s.product_id=m.product_id inner join members as ms on s.customer_id=ms.customer_id
where join_date<order_date) after_order)
select customer_id,product_name from 
answer
where ranking=1;

#7.WHICH ITEM WAS PURCHASED JUST BEFORE THE CUSTOMER BECAME A MEMBER?
with answer as 
(select re.customer_id,re.product_name,re.join_date,re.order_date,rank() over(partition by re.customer_id order by re.order_date desc) as ranking from
(select s.customer_id,m.product_name,ms.join_date,s.order_date 
from sales as s inner join menu as m on s.product_id=m.product_id inner join members as ms on s.customer_id=ms.customer_id
where ms.join_date>s.order_date
order by s.customer_id,s.order_date,ms.join_date) re)
select customer_id ,product_name from answer 
where ranking=1
group by customer_id ,product_name;

#8.WHAT IS THE TOTAL ITEMS AND AMOUNT SPENTN FRO EACH MEMBER BEFORE THEY BECAME A MEMBER?
with answer as (select s.customer_id,m.product_name,ms.join_date,s.order_date,m.price 
from sales as s inner join menu as m on s.product_id=m.product_id inner join members as ms on s.customer_id=ms.customer_id
where ms.join_date>s.order_date
order by s.customer_id)
select customer_id,count(product_name) as total_count ,sum(price) as total_amount 
from answer 
group by customer_id
order by customer_id;

#9.IF EACH $1 SPENT EQUATES TO 10 POINTS AND SUSHI HAS A 2X POINTS MULTIPLIER HOW MANY POINTS WOULD EACH CUSTOMER HAVE?
select a.customer_id,sum(points) from
 (select s.customer_id,
(case m.product_name
	when "sushi" then m.price*20
	else m.price*10
end) as points
 from sales as s inner join menu as m on s.product_id =m.product_id) a
 group by a.customer_id;



#10.INT HE FIRST WEEK AFTER A CUSTOMER JOINS THE PROGRAM INCLUDING THEIR JOIN DATE THEY EARN 2X POINTS ON ALL TIMES, NOT JUST SUSHI - HOW MANY POINTS DO CUSTOMER A AND B HAVE AT THE END OF JANUARY?

with answer as
(select re.customer_id,re.product_name,re.price,re.join_date,re.order_date,re.valid_date,
(case 
when re.product_name="sushi" then re.price*20
when month(re.order_date)not  in ('1')  then price*0
when re.order_date  between re.join_date and re.valid_date and month(re.order_date) in ('1') then re.price*20
else re.price*10 
end) as points from
(select s.customer_id,ms.join_date,s.order_date,(ms.join_date+6)as valid_date,m.product_name,m.price 
from sales as s inner join menu as m on s.product_id=m.product_id inner join members as ms on s.customer_id=ms.customer_id
order by s.customer_id,order_date) re)

select customer_id,sum(points) from answer
group by customer_id
order by customer_id;

#BONUS QUESTIONS
#1----
select r.customer_id,r.order_date,r.product_name,r.price ,
(case 
when r.join_date is null then "N"
when r.join_date<=r.order_date then "Y"
else "N"
end) as membership from
(select s.customer_id,s.order_date,ms.join_date,m.product_name,m.price
from sales as s inner join menu as m on s.product_id=m.product_id left join members as ms on s.customer_id=ms.customer_id
order by s.customer_id,s.order_date) r
order by r.customer_id,r.order_date;

#2----
select re.customer_id,re.order_date,re.product_name,re.price,re.membership,
(case
when membership="N" then "null"
else rank() over(partition by re.customer_id,re.membership order by re.order_date)
end) as ranking from
(select r.customer_id,r.order_date,r.product_name,r.price ,
(case 
when r.join_date is null then "N"
when r.join_date<=r.order_date then "Y"
else "N"
end) as membership from
(select s.customer_id,s.order_date,ms.join_date,m.product_name,m.price
from sales as s inner join menu as m on s.product_id=m.product_id left join members as ms on s.customer_id=ms.customer_id
order by s.customer_id,s.order_date) r
order by r.customer_id,r.order_date) re;








