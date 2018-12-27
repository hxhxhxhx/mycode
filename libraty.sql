
�������ݿ�
create database text1
  character set utf8
  collate utf8_bin;
ͼ����Ϣ��
create table message(
     book_id char(8) primary key,
     book_category_id char(2) not null,
     book_name varchar(20) not null,
     author varchar(20) not null,
     price decimal(7,3) not null,
     press varchar(10) default '��е��ҵ������',
     pubdate date not null,
     store tinyint not null,
     constraint fk_book_category_id foreign key(book_category_id) references bookType(category_id)
     );

insert into message (book_id,book_category_id,book_name,author,price,pubdate,store)
values(20150201,3,'java���˼��','(��)���˶�',79.8,'2007-04-01',5),
(20150202,3,'PHP��MySQL Web����','Luke Welling��',95,'2009-04-01',2),
(20150301,3,'SpringԴ����Ƚ���','�¼�',69,'2013-09-01',3),
(20160801,5,'��ҽ����ѧ','���ܴ�',136,'2011-04-01',1),
(20170401,5,'С����������','�����',24.5,'2011-04-01',4);

update message
set press ='�����ʵ������' where book_id=20150301;
update message
set press ='��������������' where book_id=20160801;
update message
set press ='��������������' where book_id=20170401;


ͼ������
create table bookType(
     category_id varchar(2) primary key,
     category varchar(10) not null,
     parent_id char(1) not null
     );

insert into bookType
values(1,'�����',0),
(2,'ҽѧ',0),
(3,'�������',1),
(4,'���ݿ�',1),
(5,'����ѧ',2);

������Ϣ��
create table reader(
     card_id char(18) primary key,
     name varchar(10) not null,
     sex enum('��','Ů'),
     age char(3),
     tel varchar(11) unique,
     balance smallint not null
     );

insert into reader
values(210210199901011111,'�ŷ�','Ů',18,13566661111,300),
(210210199802012222,'����','Ů',19,13566662222,200),
(210210199703013333,'����','��',20,13566663333	,300),
(210210199604014444,'����','��',21,13566664444	,400),
(210210199505015555,'����','��',22,13566665555	,500);


������Ϣ��
create table borrow(
     book_id char(8),
     card_id char(18),
     borrow_date date,
     return_date date,
     status enum('��','��'),
     constraint pk_book_id_card_id primary key(book_id,card_id)
     );

insert into borrow
values(20150201,210210199901011111,'2017-05-05','2017-06-05','��'),
(20160801,210210199902012222,'2017-06-05','2017-07-05','��'),
(20150301,210210199903013333,'2017-08-05','2017-09-05','��'),
(20150202,210210199904014444,'2017-10-15','2017-11-15','��'),
(20170401,210210199902012222,'2017-10-18','2017-11-18','��');







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


����ΨһԼ��
constraint uk_btname unique(btname);

����ΨһԼ��
alter table bookType1 add unique(btid);
alter table bookType1 add unique(btname);

���Ӷ��ΨһԼ��
alter table bookType1 add unique(btid,btname);

����ΪΨһԼ��
alter table bookType1 modify btname varchar(60) uniaue;

ɾ��ΨһԼ��
alter table bookType1 drop unique uk_btname;

ɾ������ΨһԼ��
alter table bookType1 drop unique;

�������
alter table bookinfo add constraint fk_btid foreign key(btid) references booType(btid)
on delete cascade on update cascade;

"on delete cascade" "on update cascade"�����б����õ�����/Ψһ����Ӧ���ݱ�ɾ�������ʱ���������ӱ��е�����ɾ������Ӧ�ظ���


��������
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '�������';



���������
insert into message (book_id,book_category_id,book_name,author,price,pubdate,store)
values(20150201,3,'java���˼��','(��)���˶�',79.8,'2007-04-01',5);


��������
auto_increment


create table bookType(
     category_id varchar(2) primary key auto_increment,
     category varchar(10) not null,
     parent_id char(1) not null
     )auto_increment=5;


�޸�������
alter table bookType auto_increment=15;

ɾ����¼
delete from borrow where book_id='20150301';

��������
update bookType set  category='��ѧ',parent_id=3
where category_id=3;

ǰ���м�¼
select * from bookinfo limit 3;

��������¼��ʼ��������
select * from bookinfo limit 2,2;

select * from bookinfo limit 2 offset 2;


�Ӳ�ѯ
select price from message where price < all(select avg(price) from message);

�޸ı���
alter table bookinfo rename booktype;

����ʱ���
datediff(sysdate(),return_date)>0 and status = '��'

���Ӳ�ѯ
select category,book_name,book_id from booktype
    -> right join message on booktype.category_id=message.book_category_id;


��ѯ���շ��鲢��ʾ����
SELECT proid,GROUP_CONCAT(username),GROUP_CONCAT(sex) FROM cms_user GROUP BY proid;

ͳ���ܺ�
SELECT proid,GROUP_CONCAT(username),GROUP_CONCAT(sex) FROM cms_user GROUP BY proid WITH ROLLUP;

�����ȡ��¼
SELECT * FROM cms_user ORDER BY RAND();

������������
SELECT id,age FROM cms_user ODER BY age DESC id ASC;

�涨��ѯ��ʾ������ƫ����
SELECT * FROM cms_user LIMIT 5;

SELECT * FROM cms_user LIMIT 0,5;

SELECT * FROM cms_user LIMIT 5,5;


����Ӧ��
delimiter //
create function show_level(cid char(18))
returns varchar(10)
DETERMINISTIC
begin
declare lev varchar(10);
declare money decimal(7,3);
select balance into money from reader where card_id=cid;
if money>=500 then
    set lev ='���ƻ�Ա';
elseif money>=300 then
    set lev ='�߼���Ա';
elseif money>=200 then
    set lev ='��ͨ��Ա';
else
    set lev='�ǻ�Ա������';
end if;
return lev;
end//
delimiter;

set num = truncate(money/100,0);
case num
when 0 then set lev = '�ǻ�Ա������';
when 1 then set lev = '�ǻ�Ա������';
when 2 then set lev = '��ͨ��Ա';
when 3 then set lev = '�߼���Ա';
when 4 then set lev = '�߼���Ա';
else
    set lev = '���ƻ�Ա';
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







