--Via pm.training_factloan
--The total number of loans based on loan IDs
--The total disbursed amount
--The total collected amountOnly return settled loans and aggregate by loan term

select loanterm,
       count(factloanid) as number_of_loans, 
       sum(disbursedamount) as total_disbursed,
       SUM(totalcollected) as total_collected
from pm.training_factloans tf
where settleddate  is not null 	
group by loanterm

--Repeat the above for loans disbursed via the lending infrastructure (pm.training_factlending)

select  loanterm,
        count(sc_lendingid) as Number_of_loans,
        sum(disbursedbalance)as total_disbursed,
        sum(collectedbalance) as total_collected
from pm.training_factlending tf 
where settleddate is not null
group by loanterm 

select top 10 *
from pm.training_factlending tf 

select factloanid from pm.training_factloans tf
union all
select sc_lendingid from pm.training_factlending tf2
----------------------------------------------------------------

select A.*,B.* from

(select min (date), countryname,partner,productname,currencycode,
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
) as A
inner join

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
group by last_day(date) 
on a.date=b.date


