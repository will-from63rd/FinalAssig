
------------------------------------------------------------------------------------------practice-------------------------------------
--Final Exercise

drop table if exists #tempo;
create temp table #tempo 
(
"date" date,
countryname varchar(100),
partner varchar(100),
product varchar(100),
productname varchar(100),
currencycode varchar(10),
unique_customers int,
NewLoans int,----2nd table
RepeatLoans int,
TotalNumberOfLoans int,
DisbursedAmountNewLoans float(8),
DisbursedAmountRepeatLoans float(8),
TotalDisbursed float(8),
TotalCollected float(8),
initialloanduenumber int,                                                             
initialloanduevalue float(8),
initialloancollectedvalue float(8),
extendedloanduenumber int,
extendedloanduevalue float(8),
extendedloancollectedvalue float(8),
ussdhits int,
uniqueussdhits int
);  
insert into #tempo
(
select date,countryname,partner ,product,
       productname ,currencycode ,
sum( customercountcumulative)as unique_customers
from bi_datamarts.dm_daily_loanmeasures ddl 
where "date" between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by date,countryname,
         partner ,product ,productname 
         ,currencycode
);
insert into #tempo 
(    date,countryname, partner,
     product, productname, currencycode,
     NewLoans,
     RepeatLoans,
     TotalNumberOfLoans, 
     DisbursedAmountNewLoans,
     DisbursedAmountRepeatLoans,
     TotalDisbursed ,
     TotalCollected
)

(select  date,countryname, partner,
       product, productname, currencycode,
       sum(case when loanbucket=1 then disbursed_count end) as NewLoans,
       sum(case when loanbucket>1 then disbursed_count end) as RepeatLoans,
       sum(disbursed_count) TotalNoLoans,
       sum(case when loanbucket =1 then disbursed_movement end) as DisbursedAmountNewLoans,
       sum(case when loanbucket >1 then disbursed_movement end) as DisbursedAmountRepeatLoans,
       sum(disbursed_movement) as TotalDisbursed,
       sum(collected_movement) as TotalCollected
from bi_datamarts.dm_daily_transactions ddt 
where date between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by "date" ,countryname, partner,
          product, productname, currencycode
order by "date"         
) ;  
insert into #tempo        
(    date,countryname, partner,
     product, productname, currencycode,
     initialloanduenumber,
     initialloanduevalue,
     initialloancollectedvalue,
     extendedloanduenumber,
     extendedloanduevalue,
     extendedloancollectedvalue
)  
(
select  date,countryname, partner,
       product, productname, currencycode,
       sum(initialloanduenumber) as initialloanduenumber,
       sum(initialloanduevalue)::numeric(18,0) as initialloanduevalue ,
       sum(initialloancollectednumber )as initialloancollectednumber, 
       sum(extendedloanduenumber) as extendedloanduenumber,
       sum(extendedloanduevalue)::numeric(18,0) as extendedloanduevalue,
       abs(sum(extendedloancollectedvalue))::numeric(18,0) as extendedloancollectedvalue 
from bi_datamarts.dm_daily_collectionsdue ddc 
where "date" between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by "date",countryname, partner,
          product, productname, currencycode
order by "date" 
);
insert into #tempo
(   date,countryname, partner,
    product, productname, currencycode,
    ussdhits,
    uniqueussdhits 
)
(
select date,countryname, partner,
       product, productname, currencycode,
       sum(ussdhits) as ussdhits, 
       sum(uniqueussdhits) as uniqueussdhits 
from bi_datamarts.dm_daily_ussdmeasures ddu 
where "date" between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by date,countryname, partner,
         product, productname, currencycode
order by "date" 
)as ;

select date,countryname,partner ,product,
       productname ,currencycode,
      sum(unique_customers)as unique_customers,
      sum(NewLoans) as NewLoans,
      sum(RepeatLoans) as RepeatLoans,
      sum(TotalNumberOfLoans) as TotalNuOfLoans,
      sum(DisbursedAmountNewLoans) as DisbAmntNewLoans,
      sum(DisbursedAmountRepeatLoans)as DisbAmntOfRepeatLoans,
      sum(TotalDisbursed) as TotalDisbursed,
      sum(TotalCollected) as totalCollected,
      sum(ussdhits) as USSDhits,
      sum(uniqueussdhits) as UniqueUssdHits
from #tempo
group by date,countryname, partner, product, productname, currencycode
order by date


---

----------------------------------------------------------
select  A.date,A.countryname, A.partner ,A.product ,A.productname ,A.currencycode , A.unique_customers,
        B.NewLoans,B.RepeatLoans,B.TotalNoLoans,B.DisbursedAmountNewLoans,B.DisbursedAmountRepeatLoans,B.TotalDisbursed ,B.TotalCollected,
        C.initialloanduenumber,C.initialloanduevalue,C.initialloanduevalue,C.extendedloanduenumber,C.extendedloanduevalue,C.extendedloancollectedvalue,
        D.ussdhits,D.uniqueussdhits 
FROM        
(
select date,countryname,
        partner ,product ,productname ,currencycode ,
sum( customercountcumulative)as unique_customers
from bi_datamarts.dm_daily_loanmeasures ddl 
where "date" ='2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by date,countryname,
         partner ,product ,productname 
         ,currencycode
)as A inner join 
(select date, 
       sum(case when loanbucket=1 then disbursed_count end) as NewLoans,
       sum(case when loanbucket>1 then disbursed_count end) as RepeatLoans,
       sum(disbursed_count) TotalNoLoans,
       sum(case when loanbucket =1 then disbursed_movement end) as DisbursedAmountNewLoans,
       sum(case when loanbucket >1 then disbursed_movement end) as DisbursedAmountRepeatLoans,
       sum(disbursed_movement) as TotalDisbursed,
       sum(collected_movement) as TotalCollected
from bi_datamarts.dm_daily_transactions ddt 
where date between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by "date" 
--order by "date"         
) as B
on A.date=B.date -----
inner join       
(select date,
       sum(initialloanduenumber) as initialloanduenumber,
       sum(initialloanduevalue)::numeric(18,0) as initialloanduevalue ,
       sum(initialloancollectednumber )as initialloancollectednumber, 
       sum(extendedloanduenumber) as extendedloanduenumber,
       sum(extendedloanduevalue)::numeric(18,0) as extendedloanduevalue,
       abs(sum(extendedloancollectedvalue))::numeric(18,0) as extendedloancollectedvalue 
from bi_datamarts.dm_daily_collectionsdue ddc 
where "date" between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by "date"
)as C 
on A.date =C.date

inner join
(
select date,
       sum(ussdhits) as ussdhits, 
       sum(uniqueussdhits) as uniqueussdhits
from bi_datamarts.dm_daily_ussdmeasures ddu 
where "date" between '2021-09-27' and '2021-10-03'
and currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by "date"
order by "date"  
)as D on 
C.date=D.date
order by date;




------------------------------------
--Understanding the date_parts function the 

(select date_part(w, getdate())as current_week  
      , countryname,partner,productname,currencycode,
        partner ,product ,productname ,currencycode ,
sum( customercountcumulative)as unique_customers
from bi_datamarts.dm_daily_loanmeasures ddl 
where currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by (date),countryname,
         partner ,product ,productname 
         ,currencycode)

) 


(select min (date), 
       sum(case when loanbucket=1 then disbursed_count end) as NewLoans,
       sum(case when loanbucket>1 then disbursed_count end) as RepeatLoans,
       sum(disbursed_count) TotalNoLoans,
       sum(case when loanbucket =1 then disbursed_movement end) as DisbursedAmountNewLoans,
       sum(case when loanbucket >1 then disbursed_movement end) as DisbursedAmountRepeatLoans,
       sum(disbursed_movement) as TotalDisbursed,
       sum(collected_movement) as TotalCollected
from bi_datamarts.dm_daily_transactions ddt 
where  currencycode ='XOF'
and countrycode ='CI'
and partner ='MTN'
and product ='LENDING'
and productname ='VITKASH'
group by last_day("date") )
as B
on A.date=B.date;





