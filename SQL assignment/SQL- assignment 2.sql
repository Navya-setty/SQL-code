use db5;

create table db5.loan2(
credit_policy varchar(255),
purpose varchar(255),
int_rate varchar(30),
installment varchar(30),
log_annual_inc varchar(30),
dti varchar(30),
fico varchar(30),
days_with_cr_line varchar(30),
revol_bal varchar(30),
revol_util varchar(30),
inq_last_6mths varchar(30),
delinq_2yrs varchar(50),
pub_rec varchar(60),
not_fully_paid varchar(60)
);

create table db5.loan1(
credit_policy varchar(255),
purpose varchar(255),
int_rate float(30),
installment float(30),
log_annual_inc float(30),
dti float(30),
fico float(30),
days_with_cr_line int(30),
revol_bal float(30),
revol_util float(30),
inq_last_6mths varchar(30),
delinq_2yrs varchar(50),
pub_rec varchar(60),
not_fully_paid varchar(60)
);

#select * from db5.loan2;

insert into db5.loan1  
select * from db5.loan2;

#select * from db5.loan1;

DELIMITER $$
create function new_interest_rate(fico int(30), int_rate float(30))
returns float(30)
deterministic
begin
	return 
    case 
		when fico > 750 then int_rate
        when fico between 700 and 749 then int_rate+0.5
        when fico between 600 and 699 then int_rate+0.8
        when fico < 600 then int_rate+1.3
	end;
end $$

DELIMITER ;

SELECT *, new_interest_rate(fico,int_rate) as new_int_rate from db5.loan1;

DELIMITER $$
create function new_installment(new_int_rate float(30), revol_bal float(30))
returns float(30)
deterministic
begin
	return (new_int_rate*revol_bal)/12;
end $$

DELIMITER ;

create table db5.loan3(
credit_policy varchar(255),
purpose varchar(255),
int_rate float(30),
installment float(30),
log_annual_inc float(30),
dti float(30),
fico float(30),
days_with_cr_line int(30),
revol_bal float(30),
revol_util float(30),
inq_last_6mths varchar(30),
delinq_2yrs varchar(50),
pub_rec varchar(60),
not_fully_paid varchar(60),
new_int_rate float(30)
);

insert into db5.loan3
select *, new_interest_rate(fico,int_rate) as new_int_rate from db5.loan1;

#select * from db5.loan3;

create table db5.loan4(
credit_policy varchar(255),
purpose varchar(255),
int_rate float(30),
installment float(30),
log_annual_inc float(30),
dti float(30),
fico float(30),
days_with_cr_line int(30),
revol_bal float(30),
revol_util float(30),
inq_last_6mths varchar(30),
delinq_2yrs varchar(50),
pub_rec varchar(60),
not_fully_paid varchar(60),
new_int_rate float(30),
new_install float(30)
);

insert into db5.loan4
select *, new_installment(new_int_rate,revol_bal) as new_install from db5.loan3;

select * from db5.loan4;