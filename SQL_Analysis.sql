---Retrieve table to inspect the data
SELECT * FROM `retaildatplusage.alldataretail.dataretail`;

--Checking unique values
--Check unique values in year of transaction 
SELECT DISTINCT Tran_Year FROM `retaildatplusage.alldataretail.dataretail`;

--Check unique values in product categories
SELECT DISTINCT prod_cat FROM `retaildatplusage.alldataretail.dataretail`;

--Check unique values in store type
SELECT DISTINCT Store_type FROM `retaildatplusage.alldataretail.dataretail`;

--Analysis
--Find the best selling product category(Group revenue by product categories)
SELECT prod_cat, SUM(total_amt) Revenue FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY prod_cat
Order by 2 desc;

--Which gender contributes more revenue(Group revenue by gender)
SELECT Gender, SUM(total_amt) Revenue FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY Gender
Order by 2 desc;

--What's the most preferred store type?(Group revenue by store type)
SELECT Store_type, AVG(total_amt) AS AVG_REVENUE
FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY Store_type
ORDER BY 2 DESC;

--Check sales performance over the years(Group revenue by year of transaction)
SELECT Tran_Year, SUM(total_amt) Revenue FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY Tran_Year
Order by 2 desc;

--Because the revenue generated in 2014 is the lowest, check if the business actually operated from January to December in 2014; check for the other years too
SELECT DISTINCT Tran_month FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2014;

--What was the best month for sales? 
--FOR 2011
SELECT Tran_month, SUM(total_amt) RevenueMonth, COUNT(transaction_id) FREQUENCY
FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2011
GROUP BY Tran_month
ORDER BY 2 DESC;

--For 2012
SELECT Tran_month, SUM(total_amt) RevenueMonth, COUNT(transaction_id) FREQUENCY
FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2012
GROUP BY Tran_month
ORDER BY 2 DESC;

--for 2013
SELECT Tran_month, SUM(total_amt) RevenueMonth, COUNT(transaction_id) FREQUENCY
FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2013
GROUP BY Tran_month
ORDER BY 2 DESC;

--for 2014
SELECT Tran_month, SUM(total_amt) RevenueMonth, COUNT(transaction_id) FREQUENCY
FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2014
GROUP BY Tran_month
ORDER BY 2 DESC;

--What was the best quarter? (Group revenue by quarter for each year)
--For 2011
SELECT Tran_Qtr, SUM(total_amt) FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2011
GROUP BY Tran_Qtr
ORDER BY 2 DESC;

--For 2012
SELECT Tran_Qtr, SUM(total_amt) FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2012
GROUP BY Tran_Qtr
ORDER BY 2 DESC;

--For 2013
SELECT Tran_Qtr, SUM(total_amt) FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2013
GROUP BY Tran_Qtr
ORDER BY 2 DESC;

--For 2014
SELECT Tran_Qtr, SUM(total_amt) FROM `retaildatplusage.alldataretail.dataretail`
WHERE Tran_Year = 2014
GROUP BY Tran_Qtr
ORDER BY 2 DESC;

--How much was lost to refunds?
SELECT
CASE
WHEN total_amt < 1 THEN 'Refund'
WHEN total_amt > 1 THEN 'Sold'
END AS RefundOrSales,
SUM(total_amt) Revenue
FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY RefundOrSales;

--Revenue lost to refunds
SELECT SUM(total_amt) FROM `retaildatplusage.alldataretail.dataretail`
WHERE total_amt < 1;

--Categorise the customers into 3 buckets based on their age
SELECT MIN(Age) MinAge FROM `retaildatplusage.alldataretail.dataretail`;
SELECT Max(Age) MaxAge FROM `retaildatplusage.alldataretail.dataretail`;

SELECT
CASE
WHEN age BETWEEN 30 AND 39 THEN '30-39'
WHEN age BETWEEN 40 AND 49 THEN '40-49'
WHEN age BETWEEN 50 AND 59 THEN '50-59'
END AS AgeSegment,
ROUND(SUM(total_amt),2) AS Revenue
FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY AgeSegment
ORDER BY 2 DESC;

--Who is the best customer?RFM ANALYSIS(Categorize the customers based on recency, frequency and monetary)

SELECT *, 
CASE
  when rfm_string in ('111', '112', '121', '122', '123', '132', '211', '212', '114', '141') then 'lost customers'
  when rfm_string in ('133', '134', '143', '244', '334', '343', '344') then 'slipping away, cannot lose'
  when rfm_string in ('311', '411', '331') then 'new customers'
  when rfm_string in ('222', '223', '233', '322') then 'potential churners'
  when rfm_string in ('323','333', '321', '422', '332', '432') then 'active'
  when rfm_string in ('433', '434', '443', '444') then 'loyal'
  END AS rfm_segment
  FROM(
SELECT * , CONCAT(cast(rfm_recency as string), cast(rfm_frequency as string), cast(rfm_monetary as string)) as rfm_string
FROM (
SELECT * , 
NTILE(4) OVER (ORDER BY Recency) rfm_recency,
NTILE(4) OVER (ORDER BY Frequency) rfm_frequency,
NTILE(4) OVER (ORDER BY AvgMonetary) rfm_monetary

FROM `retaildatplusage.alldataretail.rfm`
) A
  )B
CREATE VIEW `retaildatplusage.alldataretail.rfm` AS 
(
SELECT customer_Id, SUM(total_amt)MonetaryValue, AVG(total_amt) AvgMonetary, COUNT(transaction_id) Frequency, MAX(tran_date)LastOrderDate,

(SELECT MAX(tran_date) FROM `retaildatplusage.alldataretail.dataretail`)MaxOrderDate,


DATE_DIFF((SELECT MAX(tran_date) FROM `retaildatplusage.alldataretail.dataretail`), MAX(tran_date), DAY)Recency
FROM `retaildatplusage.alldataretail.dataretail`
GROUP BY customer_Id
)




















