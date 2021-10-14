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
where "date" between '2021-09-27' and '2021-10-03'
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


