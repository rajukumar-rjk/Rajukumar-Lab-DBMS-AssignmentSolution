drop table if exists supplier;
create table supplier (
    supp_id int primary key auto_increment,
    supp_name varchar(100),
    supp_city varchar(50),
    supp_phone bigint
);

drop table if exists customer;
create table customer (
    cus_id int primary key auto_increment,
    cus_name varchar(60),
    cus_phone bigint,
    cus_city varchar(50),
    cus_gender varchar(1)
);

drop table if exists category;
create table category (
    cat_id int primary key not null unique,
    cat_name varchar(60)
);

drop table if exists product;
create table product
(
    pro_id  int          primary key auto_increment,
    pro_name varchar(100) null,
    pro_desc varchar(255) null,
    cat_id   int          null,
    constraint product_category_cat_id_fk
        foreign key (cat_id) references category (cat_id)
);

drop table if exists product_details;
create table product_details(
    prod_id int auto_increment primary key ,
    pro_id int not null,
    supp_id int not null,
    price float not null,
    constraint product_details_product_pro_id_fk
        foreign key (pro_id) references product (pro_id),
    constraint product_details_supplier_prod_id_fk
        foreign key (supp_id) references supplier (supp_id)
);

drop table if exists `order`;
create table `order`(
    ord_id int auto_increment primary key,
    ord_amount float not null,
    ord_date date not null,
    cus_id int not null,
    prod_id int not null,
    constraint order_customer_fk_cus_id
        foreign key (cus_id) references customer (cus_id),
    constraint order_prod_details_fk_prod_id
        foreign key (prod_id) references product_details (prod_id)
);

drop table if exists rating;
create table rating(
    rat_id int auto_increment primary key ,
    cus_id int not null,
    supp_id int not null,
    rat_ratstars int not null,
    constraint rating_customer_fk_cust_id
        foreign key (cus_id) references customer (cus_id),
    constraint rating_supplier_fk_supp_id
        foreign key (supp_id) references supplier (supp_id)
);

# 2. Insert the data in the table created above
# insert data to - supplier table
insert into
    supplier (supp_id, supp_name, supp_city, supp_phone)
values
    (1,	'Rajesh Retails', 'Delhi', 1234567890),
    (2,	'Appario Ltd.', 'Mumbai', 2589631470),
    (3,	'Knome products', 'Banglore', 9785462315),
    (4,	'Bansal Retails', 'Kochi', 8975463285),
    (5,	'Mittal Ltd.',	'Lucknow', 7898456532);

# insert data to - customer table
insert into
    customer (cus_id, cus_name, cus_phone, cus_city, cus_gender)
values
    (1,	'AAKASH', 9999999999, 'DELHI', 'M'),
    (2,	'AMAN', 9785463215, 'NOIDA', 'M'),
    (3,	'NEHA', 9999999999, 'MUMBAI', 'F'),
    (4,	'MEGHA', 9994562399, 'KOLKATA', 'F'),
    (5,	'PULKIT', 7895999999, 'LUCKNOW', 'M');

# insert data to - category table
insert into
    category (cat_id, cat_name)
values
    (1,	'BOOKS'),
    (2,	'GAMES'),
    (3,	'GROCERIES'),
    (4,	'ELECTRONICS'),
    (5,	'CLOTHES');

# insert data to - product table
insert into
    product (pro_id, pro_name, pro_desc, cat_id)
values
    (1,	'GTA V', 'DFJDJFDJFDJFDJFJF', 2),
    (2,	'TSHIRT', 'DFDFJDFJDKFD', 5),
    (3,	'ROG LAPTOP', 'DFNTTNTNTERND', 4),
    (4,	'OATS', 'REURENTBTOTH',	3),
    (5,	'HARRY POTTER',	'NBEMCTHTJTH', 1);

# insert data to - product details table
insert into
    product_details (prod_id, pro_id, supp_id, price)
value
    (1,	1,	2,	1500),
    (2,	3,	5,	30000),
    (3,	5,	1,	3000),
    (4,	2,	3,	2500),
    (5,	4,	1,	1000);

# insert data to - order table
insert into
    `order` (ord_id, ord_amount, ord_date, cus_id, prod_id)
values
    (20,	1500,	'2021-10-12',	3,	5),
    (25,	30500,	'2021-09-16',	5,	2),
    (26,	2000,	'2021-10-05',	1,	1),
    (30,	3500,	'2021-08-16',	4,	3),
    (50,	2000,	'2021-10-06',	2,	1);

# insert data to - rating table
insert into
    rating (rat_id, cus_id, supp_id, rat_ratstars)
values
    (1,	2,	2,	4),
    (2,	3,	4,	3),
    (3,	5,	1,	5),
    (4,	1,	3,	2),
    (5,	4,	5,	4);


# 3) Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
select customer.cus_gender, count(customer.cus_id) as total
from customer
    join `order` on customer.cus_id = `order`.cus_id and ord_amount >= 3000
group by cus_gender;


# 4) Display all the orders along with the product name ordered by a customer having Customer_Id=2.
select o.ord_id, o.ord_amount, o.ord_date, p.pro_name
from `order` o
    join product_details pd on o.prod_id = pd.prod_id
    join product p on pd.pro_id = p.pro_id
where o.cus_id = 2;

# 5) Display the Supplier details who can supply more than one product.
select s.supp_id, s.supp_name, s.supp_city, s.supp_phone
from supplier s
    join product_details pd on s.supp_id = pd.supp_id
having count(pd.prod_id) > 1;

# 6) Find the category of the product whose order amount is minimum.
select c.cat_id, c.cat_name, min(o.ord_amount) as amount
from category c
    join product p on c.cat_id = p.cat_id
    join product_details pd on p.pro_id = pd.pro_id
    left join `order` o on pd.prod_id = o.prod_id
group by c.cat_id order by amount ;

# 7) Display the Id and Name of the Product ordered after “2021-10-05”.
select p.pro_id, p.pro_name
from product p
    join product_details pd on p.pro_id = pd.pro_id
    join `order` o on pd.prod_id = o.prod_id
where o.ord_date > '2021-10-05';

# 8) Display customer name and gender whose names start or end with character 'A'.
select cus_name, cus_gender from customer where cus_name like 'a%' or cus_name like '%a';

# 9) Create a stored procedure to display the Rating for a Supplier
# if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier”
# if rating >2 “Average Supplier” else “Supplier should not be considered”.

delimiter $$
    create procedure supplier_rating()
    begin
        select s.supp_id, s.supp_name,
            case
                when rat_ratstars >4 then 'Genuine Supplier'
                when rat_ratstars >2
                         and rat_ratstars <=4 then 'Average Supplier'
                else 'Supplier should not be considered'
            end as rating
        from rating
            join supplier s on rating.supp_id = s.supp_id;
    end $$
delimiter ;

call supplier_rating();
