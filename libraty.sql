
创建数据库
create database text1
  character set utf8
  collate utf8_bin;
图书信息表
create table message(
     book_id char(8) primary key,
     book_category_id char(2) not null,
     book_name varchar(20) not null,
     author varchar(20) not null,
     price decimal(7,3) not null,
     press varchar(10) default '机械工业出版社',
     pubdate date not null,
     store tinyint not null,
     constraint fk_book_category_id foreign key(book_category_id) references bookType(category_id)
     );

insert into message (book_id,book_category_id,book_name,author,price,pubdate,store)
values(20150201,3,'java编程思想','(美)埃克尔',79.8,'2007-04-01',5),
(20150202,3,'PHP和MySQL Web开发','Luke Welling等',95,'2009-04-01',2),
(20150301,3,'Spring源码深度解析','郝佳',69,'2013-09-01',3),
(20160801,5,'中医儿科学','汪受传',136,'2011-04-01',1),
(20170401,5,'小儿推拿秘笈','李德修',24.5,'2011-04-01',4);

update message
set press ='人民邮电出版社' where book_id=20150301;
update message
set press ='人民卫生出版社' where book_id=20160801;
update message
set press ='人民卫生出版社' where book_id=20170401;


图书类别表
create table bookType(
     category_id varchar(2) primary key,
     category varchar(10) not null,
     parent_id char(1) not null
     );

insert into bookType
values(1,'计算机',0),
(2,'医学',0),
(3,'编程语言',1),
(4,'数据库',1),
(5,'儿科学',2);

读者信息表
create table reader(
     card_id char(18) primary key,
     name varchar(10) not null,
     sex enum('男','女'),
     age char(3),
     tel varchar(11) unique,
     balance smallint not null
     );

insert into reader
values(210210199901011111,'张飞','女',18,13566661111,300),
(210210199802012222,'李月','女',19,13566662222,200),
(210210199703013333,'王鹏','男',20,13566663333	,300),
(210210199604014444,'刘鑫','男',21,13566664444	,400),
(210210199505015555,'杨磊','男',22,13566665555	,500);


借阅信息表
create table borrow(
     book_id char(8),
     card_id char(18),
     borrow_date date,
     return_date date,
     status enum('是','否'),
     constraint pk_book_id_card_id primary key(book_id,card_id)
     );

insert into borrow
values(20150201,210210199901011111,'2017-05-05','2017-06-05','是'),
(20160801,210210199902012222,'2017-06-05','2017-07-05','是'),
(20150301,210210199903013333,'2017-08-05','2017-09-05','是'),
(20150202,210210199904014444,'2017-10-15','2017-11-15','否'),
(20170401,210210199902012222,'2017-10-18','2017-11-18','否');







create table bookinfo( 
      book_id int,
      book_name varchar(20)
      )
partition by range(book_id)(
partition p1 values less than (20109999),
partition p2 values less than (20159999),
partition p3 values less than MAXVALUE
      );

insert into bookinfo values(20100005,'t1');
insert into bookinfo values(20140015,'t2');
insert into bookinfo values(20170011,'t3');

select * from bookinfo partition(p1);


创建唯一约束
constraint uk_btname unique(btname);

增加唯一约束
alter table bookType1 add unique(btid);
alter table bookType1 add unique(btname);

增加多个唯一约束
alter table bookType1 add unique(btid,btname);

更改为唯一约束
alter table bookType1 modify btname varchar(60) uniaue;

删除唯一约束
alter table bookType1 drop unique uk_btname;

删除所有唯一约束
alter table bookType1 drop unique;

增加外键
alter table bookinfo add constraint fk_btid foreign key(btid) references booType(btid)
on delete cascade on update cascade;

"on delete cascade" "on update cascade"主表中被引用的主键/唯一键对应数据被删除或更改时，将关联从表中的数据删除或相应地更新


更改密码
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的密码';



插入表数据
insert into message (book_id,book_category_id,book_name,author,price,pubdate,store)
values(20150201,3,'java编程思想','(美)埃克尔',79.8,'2007-04-01',5);


自增数据
auto_increment


create table bookType(
     category_id varchar(2) primary key auto_increment,
     category varchar(10) not null,
     parent_id char(1) not null
     )auto_increment=5;


修改自增列
alter table bookType auto_increment=15;

删除记录
delete from borrow where book_id='20150301';

更新数据
update bookType set  category='文学',parent_id=3
where category_id=3;

前三行记录
select * from bookinfo limit 3;

从三条记录开始往后两条
select * from bookinfo limit 2,2;

select * from bookinfo limit 2 offset 2;


子查询
select price from message where price < all(select avg(price) from message);

修改表名
alter table bookinfo rename booktype;

计算时间差
datediff(sysdate(),return_date)>0 and status = '否'

连接查询
select category,book_name,book_id from booktype
    -> right join message on booktype.category_id=message.book_category_id;


查询按照分组并显示详情
SELECT proid,GROUP_CONCAT(username),GROUP_CONCAT(sex) FROM cms_user GROUP BY proid;

统计总和
SELECT proid,GROUP_CONCAT(username),GROUP_CONCAT(sex) FROM cms_user GROUP BY proid WITH ROLLUP;

随机提取记录
SELECT * FROM cms_user ORDER BY RAND();

降序，升序排列
SELECT id,age FROM cms_user ODER BY age DESC id ASC;

规定查询显示条数，偏移量
SELECT * FROM cms_user LIMIT 5;

SELECT * FROM cms_user LIMIT 0,5;

SELECT * FROM cms_user LIMIT 5,5;


函数应用
delimiter //
create function show_level(cid char(18))
returns varchar(10)
DETERMINISTIC
begin
declare lev varchar(10);
declare money decimal(7,3);
select balance into money from reader where card_id=cid;
if money>=500 then
    set lev ='金牌会员';
elseif money>=300 then
    set lev ='高级会员';
elseif money>=200 then
    set lev ='普通会员';
else
    set lev='非会员，余额不足';
end if;
return lev;
end//
delimiter;

set num = truncate(money/100,0);
case num
when 0 then set lev = '非会员，余额不足';
when 1 then set lev = '非会员，余额不足';
when 2 then set lev = '普通会员';
when 3 then set lev = '高级会员';
when 4 then set lev = '高级会员';
else
    set lev = '金牌会员';
end case;

delimiter //
drop function if exists testfunc//
create function testfunc(n int)
returns int
begin
declare num int default 0;
declare sum int default 0;
labl:loop
    set num = num + 1;
    set sum = sum + num;
    if num>=n then
        leave labl;
    end if;
end loop labl;
return sum;
end//
delimiter;


set names utf8;







