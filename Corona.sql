use corona;
select * from country_wise_latest

ALTER TABLE country_wise_latest CHANGE `Country/Region` Country VARCHAR(255);
ALTER TABLE country_wise_latest CHANGE `WHO Region` WHORegion VARCHAR(255);

# Basic queries
SELECT * 
FROM country_wise_latest
WHERE Confirmed > 100000
ORDER BY Deaths DESC;

# Aggegate for sum, avg,count
#Sum of the number of cases confirmed globally
SELECT SUM(Confirmed) AS TotalConfirmed FROM country_wise_latest;

#Average, minimum and maximum number of deaths per country
SELECT AVG(Deaths) AS AvgDeaths, MIN(Deaths) AS MinDeaths, MAX(Deaths) AS MaxDeaths FROM country_wise_latest;

#Count on how many countries has data on the dataset
SELECT COUNT(DISTINCT Country) AS CountryCount FROM country_wise_latest;

#Group the data by WHORegion and find the total number of cases and deaths for each region
SELECT WHORegion, SUM(Confirmed) AS TotalConfirmed, SUM(Deaths) AS TotalDeaths
FROM country_wise_latest
GROUP BY WHORegion;

#Filter regions that have more than 1,000,000 total cases by Having 
SELECT WHORegion, SUM(Confirmed) AS TotalConfirmed
FROM country_wise_latest
GROUP BY WHORegion
HAVING SUM(Confirmed) > 1000000;

#Subquery at select to find the countries with the highest death rate (deaths/confirmed cases)
SELECT Country, (Deaths / Confirmed) * 100 AS DeathRate 
FROM country_wise_latest
ORDER BY DeathRate DESC;

#subquery at where clause to find countries where the number of deaths is greater than the global average
SELECT Country, Deaths
FROM country_wise_latest
WHERE Deaths > (SELECT AVG(Deaths) FROM country_wise_latest);

#Windows function
#Rank countries by the number of confirmed cases
SELECT Country, Confirmed,
       RANK() OVER (ORDER BY Confirmed DESC) AS ConfirmedRank
FROM country_wise_latest;
#Calculate the cumulative number of confirmed cases over the ranked countries
SELECT Country, Confirmed,
       SUM(Confirmed) OVER (ORDER BY Confirmed DESC) AS CumulativeConfirmed
FROM country_wise_latest;

# Views and Indexes
#Create a view that shows the top 10 countries with the most deaths
CREATE VIEW Top10Deaths AS
SELECT Country, Deaths
FROM country_wise_latest
ORDER BY Deaths DESC
LIMIT 10;
#Add an index on the Country column to speed up lookups
CREATE INDEX idx_country ON country_wise_latest(Country);
