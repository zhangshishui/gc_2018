--1
select m.sname, m.sid, n.average from FUSER.student m, (select sid, sum(score)/3 as average from fUser.sc 
group by sid having sum(score)/3 >= 60) n where m.sid = n.sid;
--2
select * from fUser.student where sid in (select sid from fUser.sc);
--3
select count(tname) from fUser.Teacher where tname = 'li';
--4
select * from fUser.student where sid in (select sid from fUser.sc where cid in
(select cid from fUser.course where tid in (select tid from fUser.teacher where tname = 'zhang')));
--5
select * from fUser.student where sid in (select sid from fUser.sc group by sid having count(cid) != 3);
--6
select * from fUser.student where sid in (select sid from fUser.sc where cid in
(select cid from fUser.sc where sid = 1))  and sid != 1;
--7
select * from fUser.student where (sid in (select sid from fUser.sc where cid in
(select cid from fUser.sc where sid = 1) group by sid having count(sid) = 3)) and sid != 1;
--8
select sname from fUser.student where sid not in (select sid from fUser.sc where cid in (select cid from fUser.course where 
tid in (select tid from fUser.teacher where tname = 'zhang')));
--9
select sid, sum(score)/3 from fUser.sc where score < 60  group by sid having count(cid) >1;
select sname from fUser.student where sid  in (select sid from fUser.sc where score < 60  group by sid having count(cid) >1);
--10
select cid, count(sid) from fUser.sc where score>85 and score <= 100 group by cid;
select cid, count(sid) from fUser.sc where score>70 and score <= 85 group by cid;
select cid, count(sid) from fUser.sc where score>60 and score <= 70 group by cid;
select cid, count(sid) from fUser.sc where score>0 and score <= 60 group by cid;
--11
select count(sid) from fUser.sc group by cid;
--12
select * from FUSER.sc t1 where exists
(select * from fuser.sc t2 where t1.score=t2.score and t1.cid!=t2.cid);
--13
select * from fuser.sc a
where (SELECT count(*) FROM fuser.sc b 
where b.cid=a.cid and b.score>=a.score) <= 2
order by a.cid, a.score desc
--14
select sid from fUSer.sc group by sid having count(cid) > 1;
--15
select sid from fUSer.sc group by sid having count(cid) = 3;
--过程函数
create or replace
PROCEDURE       F1 
(
  AGE OUT NUMBER  
, ID IN NUMBER  
) 
AS v_age NUMBER;
BEGIN
  AGE:=0;
  select sage into v_age from fUser.student where sid = ID ;
  AGE:=v_age;
  NULL;
END F1;
--执行
--确保变量在控制台输出
set serveroutput on;
declare 
  v_age number(10, 1);
begin 
  v_age:=10;
  fUser.F1(v_age, 1);
  dbms_output.put_line(v_age);
  dbms_output.put_line('ok');
end;
--直接复制到   控制台，接着Enter,输入/,enter执行
--函数
CREATE OR REPLACE FUNCTION FUSER.F2 
(
  ID IN NUMBER  
) RETURN NUMBER AS p_score number(10,2);
BEGIN
  select sum(score)/count(1) into p_score from fUser.sc where cid = id ;
  RETURN p_score;
END F2;
--函数运行
begin 
  dbms_output.put_line( fUser.f2(2) );
  dbms_output.put_line('ok');
end;
--触发器
CREATE OR REPLACE TRIGGER FUSER.TRIGGER1 
AFTER DELETE ON FUSER.COURSE 
FOR EACH ROW 
BEGIN
  delete from fUser.sc where cid = :old.cid;
  NULL;
END;
--执行
delete from FUSER.course where cid = 4;
