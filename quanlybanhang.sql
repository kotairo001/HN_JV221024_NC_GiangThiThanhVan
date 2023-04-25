-- create database quanlybanhang;
use quanlybanhang;
create table customer (
customer_id varchar(4)			primary key,
name varchar(100)				not null,
email varchar(100)				not null unique,
phone varchar(25)				not null unique,
address varchar(255)			not null
);

create table orders(
order_id varchar(4)				primary key,
customer_id varchar(4)			not null,
order_date date					not null,
total_amount double				not null,
foreign key (customer_id) references customer (customer_id)
);

create table products (
product_id varchar(4)			primary key,
name varchar(255)				not null,
description text,
price double					not null,
status bit(1)					not null	
);


create table orders_details (
order_id varchar(4),
product_id varchar(4),
primary key (product_id,order_id),
quantity int(11)				not null,
price double					not null,
foreign key (product_id) references products (product_id),
foreign key (order_id) references orders (order_id)
);

-- Bai 2
insert into customer values 
("C001","Nguyễn Trung Mạnh","manhnt@gmail.com","984756322","Cầu Giấy, Hà Nội"),
("C002","Hồ Hải Nam","namhh@gmail.com","984875926","Ba Vì, Hà Nội"),
("C003","Tô Ngọc Vũ","vutn@gmail.com","904725784","Mộc Châu, Sơn La"),
("C004","Phạm Ngọc Anh","anhpn@gmail.com","984635365","Vinh, Nghệ An"),
("C005","Trương Minh Cường","cuongtm@gmail.com","989735624","Hai Bà Trưng, Hà Nội");

insert into products values 
("P001", "Iphone 13 ProMax", "Bản 512 GB, xanh lá", 22999999,1),
("P002", "Dell Vostro V3510", "Core i5, RAM 8GB", 14999999,1),
("P003", "Macbook Pro M2", "8CPU 10GPU 8GB 265GB", 28999999,1),
("P004", "Apple Watch Ultra", "Titanium Alpine Loop Small", 18999999,1),
("P005", "Airpods 2 2022", "Spatial Audio", 4090000,1);

insert into orders values 
("H001","C001","2023-02-22",52999997),
("H002","C001","2023-03-11",80999997),
("H003","C002","2023-01-22",54359998),
("H004","C003","2023-03-14",102999995),
("H005","C003","2023-03-12",80999997),
("H006","C004","2023-02-01",110449994),
("H007","C004","2023-03-29",79999996),
("H008","C005","2023-02-14",29999998),
("H009","C005","2023-01-10",29999998),
("H010","C005","2023-04-01",149999994);
update orders set total_amount = 28999999 where order_date = "2023-01-10";
update orders set order_date = "2022-03-12" where order_id = "H005" and customer_id = "C003";

insert into orders_details values 
("H001","P002",1,14999999),
("H001","P004",2,18999999),
("H002","P001",1,22999999),
("H002","P003",2,28999999),
("H003","P004",2,18999999),
("H003","P005",4,4090000),
("H004","P002",3,14999999),
("H004","P003",2,28999999),
("H005","P001",1,22999999),
("H005","P003",2,28999999),
("H006","P005",5,4090000),
("H006","P002",6,14999999),
("H007","P004",3,18999999),
("H007","P001",1,22999999),
("H008","P002",2,14999999),
("H009","P003",1,28999999),
("H010","P003",2,28999999),
("H010","P001",4,22999999);

-- Bai 3
-- Bai 3-1
select c.name, c.email, c.phone, c.address from customer c;

-- Bai 3-2
select c.name, c.phone, c.address from customer c
join orders o on c.customer_id = o.customer_id where o.order_date like "2023-03-%" group by c.customer_id;

-- Bai 3-3
select sum(o.total_amount) as Total, month(o.order_date) as Month from orders o group by month(o.order_date);

-- Bai 3-4
select c.name, c.address, c.email, c.phone from customer c
where not exists (select 1 from orders where (c.customer_id = orders.customer_id) and
orders.order_date like "2023-02-%");

-- Bai 3-5
select p.product_id, p.name, sum(od.quantity) as Total from products p
join orders_details od on od.product_id = p.product_id 
join orders o on od.order_id = o.order_id where o.order_date like "2023-03-%" group by p.product_id;

-- Bai 3-6
select c.customer_id, c.name, sum(o.total_amount) as Total from customer c 
join orders o on o.customer_id = c.customer_id where o.order_date like "2023-%-%" group by c.customer_id order by sum(o.total_amount) desc; 

-- Bai 3-7
select c.name, o.total_amount as Total, o.order_date, sum(od.quantity) as "Product Total" from customer c 
join orders o on c.customer_id = o.customer_id
join orders_details od on od.order_id = o.order_id 
group by o.order_id 
having sum(od.quantity)>=5;

-- Bai 4
-- Bai 4-1
create view ORDERS_VIEW as select c.name, c.phone, c.address, sum(o.total_amount) as Total, o.order_date from customer c 
join orders o on o.customer_id = c.customer_id group by o.order_id;

-- Bai 4-2
create view CUSTOMER_VIEW as select c.name, c.address, c.phone, count(o.order_id) as "Total Order" from customer c 
join orders o on o.customer_id = c.customer_id group by c.customer_id;

-- Bai 4-3
create view PRODUCT_VIEW as select p.name, p.description, p.price, sum(od.quantity) as "Total Amount" from products p
join orders_details od on od.product_id = p.product_id group by p.product_id;

-- Bai 4-4
create index CUSTOMER_PHONE_AND_EMAIL on customer(phone,email);

-- Bai 4-5
DELIMITER //
create procedure PROC_SEARCH_CUSTOMER 
(in	cID varchar(4)
)
begin
	select * from customer where customer.customer_id = cID;
end //

-- Bai 4-6
DELIMITER //
create procedure PROC_SEARCH_PRODUCT ()
begin
	select * from product;
end //

-- Bai 4-7
DELIMITER //
create procedure PROC_SEARCH_ORDER 
(in	cID varchar(4)
)
begin
	select o.order_id, p.name, sum(od.quantity) as "total_product_amount", o.total_amount from orders o 
    join orders_details od on od.order_id = o.order_id
    join products p on p.product_id = od.product_id
    where o.customer_id = cID
    group by o.order_id;
end //

-- Bai 4-8
DELIMITER //
create procedure PROC_CREATE_ORDER
(in	new_order_id varchar(4),
	new_customer_id varchar(4),
	new_order_date date,
	new_total_amount double	
)
begin
	insert into orders values (new_order_id,new_customer_id,new_order_date,new_total_amount);
		begin
			select * from orders where orders.order_id = new_order_id;
		end;
    
end //

-- Bai 4-9
DELIMITER //
create procedure PROC_COUNT_PRODUCT
(in	start_date date,
	end_date date
)
begin
	select p.name, sum(od.quantity) as "Total Quantity" from orders_details od
    join products p on p.product_id = od.product_id 
    join orders o on o.order_id = od.order_id
    where o.order_date between start_date and end_date
    group by p.product_id;
    
end //

-- Bai 4-10
DELIMITER //
create procedure PROC_COUNT_PRODUCT_ORDER_BY_DESC 
(in	target_month varchar (2),
	target_year varchar (10)
)
begin
	select p.name, sum(od.quantity) as "Total Quantity" from orders_details od
    join products p on p.product_id = od.product_id 
    join orders o on o.order_id = od.order_id
    where month(o.order_date) = target_month and year(o.order_date) = target_year
    group by p.product_id
    order by sum(od.quantity) desc;
end//









