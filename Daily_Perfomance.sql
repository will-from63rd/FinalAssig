select 
           date, 
           sum(case when loanbucket = 1 then disbursed_count end) as NewLoans,
           sum (case when loanbucket >1 then disbursed_count  end) as RepeatLoans,
           sum(disbursed_count) as TotalNumOfLoans, 
           sum(disbursed_movement) as TotalDisbursed,
           (sum(ddt.disbursed_movement) / sum(ddt.disbursed_count))::numeric(18,0) as avg_loan_size,
           sum(abs(ddt.collected_movement))::numeric(18,0) as totalCollected,
           null as ussdhits ,
           null as uniqueussdhits_unique,
           null as USShits_UniqueUssd,
           null as initialDueNumOfLoans,
           null as InitialDue_col_rate, 
           null as extendedDueNumOfLoans,
           null as ExtendedDue_col_rate,
           null as TotalUniqueCtomer
from bi_datamarts.dm_daily_transactions ddt 
where ddt."date" between '2021-08-30'and '2021-09-05'
and currencycode ='GHS'
and partner ='MTN'
and product ='ACCESS' 
group  by "date"
union all
select (ddu."date"),
        null as col,
        null as col2,
        null as col3,
        null as col4,
        null as col5,
        null as col6,
       sum(ddu.ussdhits)  as ussdhits,
       sum (ddu.uniqueussdhits) as unique_hits,
      (SUM(ddu.ussdhits)::numeric(18,1) / sum(ddu.uniqueussdhits)::numeric(18,1))::numeric(18,1) as ussdhits_uniqueussdhits,
      null as col7,
      null as col8,
      null as col8,
      null as col9,
      null as col10
      --(sum(uniqueussdhits) / sum(ddl.numberofloans))::numeric (18,0)as uniqueussdhits_loans
from bi_datamarts.dm_daily_ussdmeasures ddu
where "date" between '2021-08-30' and '2021-09-05'
and currencycode ='GHS'
and partner ='MTN'
and product ='ACCESS'
group by "date"
------------------------------------------------------
union all 

select date,null as col1,
 null as cl2,
 null as col3,
 null as col4,
 null as col5,
 null as col6,
 null as col7,
 null as col8,
 null as col9,
sum(initialloanduenumber) as InitialDue_NumOfLoans,             
          sum(initialloanduevalue) as InitialDue_col_rate,       --percentage -column 2
            sum(extendedloanduenumber)as ExtendeDue_NumOfLoans,
            sum(extendedloanduevalue) as ExtendedDue_col_rate,      --percentage -column 4
            null as col10
from bi_datamarts.dm_daily_collectionsdue ddc 
where ddc."date" between '2021-08-30' and '2021-09-05'
and currencycode='GHS'
and partner ='MTN'
and product ='ACCESS'
group by "date"

union all 

select date, null as col1,
             null as col2,
             null as col3,
             null as col4,
             null as col5,
             null as col6,
             null as col7,
             null as col8,
             null as col9,
             null as col10,
             null as col11,
             null as col12,
             null as col13,
sum(distinct customercountcumulative)as unique_customers
from bi_datamarts.dm_daily_loanmeasures ddl 
where "date" between '2021-08-30' and '2021-09-05'
and currencycode ='GHS'
and partner ='MTN'
and product ='ACCESS'
group by "date"
order by "date" asc 

--UPDATED One !!
- 
--



select date, loanbucket 
from bi_datamarts.dm_daily_customermeasures ddc 
--where ddc."date" between '2021-08-30' and '2021-09-05'
--and currencycode ='GHS'
--and product ='ACCESS'
--and partner ='MTN'
group by "date",loanbucket 

select "date" ,
       sum(abs(ddt.collected_movement))::numeric(18,0) as totalCollected 
from bi_datamarts.dm_daily_transactions ddt 
where ddt ."date" between '2021-08-30'and '2021-09-05'
and ddt.partner='MTN'
and ddt.product='ACCESS'
and ddt.currencycode ='GHS'
group by "date"

--LOAN MEASURES

select date, sum(customercountcumulative) as CustomerCount,provider 
from bi_datamarts.dm_daily_loanmeasures ddl 
where ddl."date" between '2021-08-30' and '2021-09-05'
and loanbucket = '1'
and currencycode ='GHS'
and partner ='MTN'
and product ='ACCESS'
group by "date",provider

select top 5 * from bi_datamarts.dm_daily_loanmeasures ddl 


--USSD MEASURES
select date, sum(ussdhits) as ussdhits,
      uniqueussdhits,
      (sum(ddu.ussdhits)::numeric(18,1)/ sum(ddu.uniqueussdhits)::numeric(18,1)) as UssdHitsUniqueUssdHits
from bi_datamarts.dm_daily_ussdmeasures ddu 
where ddu."date" between '2021-08-30' and '2021-09-05'
and currencycode = 'GHS'
and partner ='MTN'
and product = 'ACCESS'
group by "date" , uniqueussdhits 
-----------------------------------------------------------------------------------------------------------------------------------------------


drop table if exists #employeename;
drop table if exists #employeedetails;

create table #employeename
(
       emploeeid int,
       firstname varchar(255),
       lastname  varchar(255)
);

create table #employeedetails
(
       team varchar(255),
       department varchar(255)
);

insert into #employeename (emploeeid, firstname, lastname)
values 
       (1,'Will','Chisesu');

insert into #employeedetails (team, department)
values 
       ('Analysts','D&P');
      
select null as team,
       null as department,
       firstname,
       lastname,
from #employeename

union all

select team,
       department,
       null as firstname,
       null as lastname
from #employeedetails



