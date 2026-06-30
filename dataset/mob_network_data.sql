create database sales_project;
use sales_project;

#customers_ntr

create table customers_ntr(customer_id varchar(10) primary key,
customer_name varchar(100),phone_number bigint,email varchar(100),
city varchar(50), state varchar(50),age_group varchar(20), registration_date date);


set global local_infile = 1;
show variables like 'secure_file_priv';

select str_to_date('07-10-2022','%d-%m-%Y'); 
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_mob_network project.csv"
into table customers_ntr
fields terminated by','
lines terminated by '\r\n'
ignore 1 rows
(customer_id, customer_name,phone_number,email,city,state,age_group, @reg_date)
set registration_date = str_to_date(@reg_date,'%d-%m-%Y');

select * from customers_ntr;
desc customers_ntr;

#operators table

create table operator(operator_id varchar(10) primary key,
	operator_name varchar(50),
    founded_year year, headquarters varchar(100),
    customer_base_million decimal(10,2));
    
show variables like 'secure_file_priv';

    load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/operators_mob_network project.csv"
into table operator
fields terminated by','
lines terminated by '\r\n'
ignore 1 rows;
    select*from operator;
    

#PLANS TABLE

CREATE TABLE PLANS(plan_id varchar(10) primary key,
	operator_id varchar(10), 
	plan_name varchar(100),
    validity_dar int, data_gb_per_day decimal (5,2),
    calls varchar(20),
    sms_per_day int,price_rs decimal(10,2),
    plan_type varchar(30)
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/plans_mob_network project.csv"
	into table PLANS
    fields terminated by ','
	lines terminated by '\r\n'
    ignore 1 rows;

select * from plans;

#RECHARGES TABLE

create table recharges(
	recharge_id varchar(10) primary key,
	customer_id varchar(10),
    plan_id varchar(10),
    recharge_date date,
    expiry_date date,
    amount_paid_rs decimal(10,2),
    payment_method varchar(30),
    status varchar(20)
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/recharges_mob_network project.csv"
into table recharges
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

select * from recharges;


# usage

create table usage_details(
	usage_id varchar(10) primary key,
    recharge_id varchar(10),
    customer_id varchar(10),
    data_used_gb decimal(6,2),
    calls_minutes int,
    sms_sent int,
    last_updated date
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/usage_mob_network project.csv"
into table usage_details
fields terminated by ','
lines terminated by '\r\n'
ignore 1 rows;

desc usage_details;

select * from usage_details;
select count(*) from customers_ntr;
select count(*) from operator;
select count(*) from plans;
select count(*) from recharges;
select count(*) from usage_details;

# add foreign key and establish their relatinship between two tables

#plans-> operator

alter table plans
add constraint fk_operator
foreign key(operator_id)
references operator(operator_id);

#recharges-> customers

alter table recharges
add constraint fk_customer
foreign key(customer_id)
references customers_ntr(customer_id);    

#recharge-> plans

alter table recharges
add constraint fk_plan
foreign key (plan_id)
references plans(plan_id);

# usage-> recharges

 alter table usage_details
 add constraint fk_usage_recharge
 foreign key (recharge_id)
 references recharges(recharge_id);
 
 #usage->customers
 
 alter table  usage_details
 add constraint fk_usage_customer
 foreign key (customer_id)
 references customers_ntr(customer_id);
 
 
 show create table plans;
 desc plans;
 show create table recharges;
 desc recharges;
 show create table usage_details;
 desc usage_details;
 desc operator;
 desc customers_ntr;
 
 
 # calculate total revenue 
 select sum(amount_paid_rs) as total_revenue from recharges ;
 
 select status from recharges where status ='expired';
 
 # calculate revenue by operator
 
 select o.operator_name, 
 sum(r.amount_paid_rs) as revenue
 from recharges r
 join plans p on r.plan_id=p.plan_id
 join operator o 
 on p.operator_id=o.operator_id
 group by o.operator_name;
 
 
 # calculate revenue by plan
 select * from plans;
 
 select plan_name, sum(amount_paid_rs) as revenue 
 from recharges r join plans p using(plan_id)
 group by plan_name order by revenue desc;
 
 #calculate by customer
 
 select customer_name, sum(amount_paid_rs) as total_spent 
 from customers_ntr inner join recharges using (customer_id)
 group by 1 order by total_spent desc;
 
 
 select * from customers_ntr;
 select customer_name, city,state from customers_ntr
 where state = 'madhya pradesh';
 