select date,
       productattributeid,
       partner,
       provider,
       product,
       productname,
       currencycode,
       countrycode,
       countryname,
       riskclassificationid,
       riskclassification,
       loanbucket,
       loanterm,
       sum(ussdhits) as ussdhits,
       sum(ussdhitscumulative) as ussdhitscumulative,
       sum(uniqueussdhits) as uniqueussdhits,
       sum(numberofscreensaccessed) as numberofscreensaccessed,
       sum(loanaccountsactivated) as loanaccountsactivated
from bi_datamarts.dm_daily_ussdmeasures
where date between '2021-09-25' and '2021-10-11'
group by date,
       productattributeid,
       partner,
       provider,
       product,
       productname,
       currencycode,
       countrycode,
       countryname,
       riskclassificationid,
       riskclassification,
       loanbucket,
       loanterm
order by date, productattributeid, currencycode;


select date,
       productattributeid,
       partner,
       provider,
       product,
       productname,
       currencycode,
       countrycode,
       countryname,
       riskclassificationid,
       riskclassification,
       loanbucket,
       loanterm,
       sum(ussdhits) as ussdhits,
       sum(ussdhitscumulative) as ussdhitscumulative,
       sum(uniqueussdhits) as uniqueussdhits,
       sum(numberofscreensaccessed) as numberofscreensaccessed,
       sum(loanaccountsactivated) as loanaccountsactivated
from bi_datamarts.dm_daily_ussdmeasures_uat
where date between '2021-09-25' and '2021-10-11'
group by date,
       productattributeid,
       partner,
       provider,
       product,
       productname,
       currencycode,
       countrycode,
       countryname,
       riskclassificationid,
       riskclassification,
       loanbucket,
       loanterm
order by date, productattributeid, currencycode;



