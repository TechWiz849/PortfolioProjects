/*
Sunday, June 13, 2021

https://www.youtube.com/watch?v=qfyynHBFOsM&t=2103s

https://ourworldindata.org/covid-deaths

Statistics and Research
Coronavirus (COVID-19) Deaths

*/

/*
DROP TABLE IF EXISTS dbo.CovidDeaths_3;

CREATE TABLE CovidDeaths_3 (
iso_code	varchar(100),
continent	varchar(100),
location	varchar(100),
date	datetime,
population	int,
total_cases	float,
new_cases	float,
new_cases_smoothed	float,
total_deaths	float,
new_deaths	float,
new_deaths_smoothed	float,
total_cases_per_million	float,
new_cases_per_million	float,
new_cases_smoothed_per_million	float,
total_deaths_per_million	float,
new_deaths_per_million	float,
new_deaths_smoothed_per_million	float,
reproduction_rate	float,
icu_patients	float,
icu_patients_per_million	float,
hosp_patients	float,
hosp_patients_per_million	float,
weekly_icu_admissions	float,
weekly_hosp_admissions	float,
weekly_hosp_admissions_per_million	float,
new_tests	float,
total_tests	float,
total_tests_per_thousand	float,
new_tests_per_thousand	float,
new_tests_smoothed	float,
new_tests_smoothed_per_thousand	float,
positive_rate	float,
tests_per_case	float,
tests_units	varchar(50),
total_vaccinations	int,
people_vaccinated	int,
people_fully_vaccinated	int,
new_vaccinations	int,
new_vaccinations_smoothed	int,
total_vaccinations_per_hundred	int,
people_vaccinated_per_hundred	int,
people_fully_vaccinated_per_hundred	int,
new_vaccinations_smoothed_per_million	int,
stringency_index	int,
population_density	int,
median_age	float,
aged_65_older	int,
aged_70_older	int,
gdp_per_capita	int,
extreme_poverty	int,
cardiovasc_death_rate	int,
diabetes_prevalence	int,
female_smokers	int,
male_smokers	int,
handwashing_facilities	int,
hospital_beds_per_thousand	int,
life_expentancy	int,
human_development_index	int,
excess_mortality	int,
);


BULK INSERT CovidDeaths_3
FROM 'C:\Users\The_Elect\Documents\CovidDeaths.xlsx'
WITH (FORMAT = 'CSV', FIRSTROW=2)
;

*/

--Insert INTO PortfolioProject..CovidDeaths_3 Select Top 96000 * FROM  CovidDeaths_2;	-- Copy/Insert * From CovidDeaths_2 Into CovidDeaths_3 

Select *
From dbo.CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
Order By 3,4;

Select location, date, total_cases, new_cases, total_deaths, population 
From dbo.CovidDeaths_3
Order By 1,2;

--Looking At % Total Deaths vs Total Cases
--Shows the likelihood of dying if you contract covid in your country.

Select location, date, total_cases, total_deaths, Format((total_deaths/total_cases)*100, '##.####0') DeathPct
From PortfolioProject..CovidDeaths_3
Order By 1,2;

--Looking At % Total Deaths vs Total Cases in USA
--Shows the likelihood of dying if you contract covid in USA.

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPct
From CovidDeaths_3
Where Location Like '%states%'
Order By 1,2;

--Looking At % Total Cases vs Population
--Displays what % & Count of the population that contracted Covid in USA.

Select location, date, Format(population, '###,###,##0') Population, total_cases, (total_cases/population)*100 [Pct Infected], 
Format(population*(total_cases/population), '##,###,##0') [Number Infected]
From CovidDeaths_3
Where Location Like '%states%' 
Order By 1,2;

--Looking At % Total Cases vs Population
--Displays what % & Count of the population that contracted Covid Worldwide.

Select location, date, Format(population, '###,###,##0') Population, total_cases, (total_cases/population)*100 [Pct Infected], 
Format(population*(total_cases/population), '##,###,##0') [Number Infected]
From CovidDeaths_3
Order By 1,2;

--Display Countries with the Highest Infection Rate vs/compared to their Population.

Select location, 
Format(population, '###,###,##0') Population, 
Format(MAX(total_cases), '##,###,##0') HighestInfectionCount, 
MAX((total_cases/population))*100 Pct_Infected
From CovidDeaths_3
Group By location, Population
Order By Pct_Infected Desc;

--Display Countries with the Highest Deaths vs/per to their Population.

Select location, 
--MAX(Cast(total_deaths as int)) TotalDeathCount		--here, if total_deaths was a char datatype then it would need to be converted/cast as an int.
MAX(total_deaths) TotalDeathCount
From CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
Group By location
Order By TotalDeathCount Desc;

--Display Continents with the Highest Deaths vs/per to their Population.
--But here, for the North America continent, only the U.S. numbers are displayed.

Select continent, 
--MAX(Cast(total_deaths as int)) TotalDeathCount		--here, if total_deaths was a char datatype then it would need to be converted/cast as an int.
MAX(total_deaths) TotalDeathCount
From CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
And total_deaths is not null
Group By continent
Order By TotalDeathCount Desc;

--Display Continents with the Highest Deaths vs/per to their Population.
--Here, all location/continent numbers are displayed.

Select location Location, 
--MAX(Cast(total_deaths as int)) TotalDeathCount		--here, if total_deaths was a char datatype then it would need to be converted/cast as an int.
MAX(total_deaths) TotalDeathCount
From CovidDeaths_3
Where continent = ''
And total_deaths is not null
Group By location
Order By TotalDeathCount Desc;


--Display Locations & Continents with the Highest Deaths vs/per to their Population.

Select location, continent, 
--MAX(Cast(total_deaths as int)) TotalDeathCount		--here, if total_deaths was a char datatype then it would need to be converted/cast as an int.
MAX(total_deaths) TotalDeathCount
From CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
And total_deaths is not null
Group By location, continent
Order By TotalDeathCount Desc;

--Display Continents with the Highest Deaths vs/per to their Population.

Select continent, 
--MAX(Cast(total_deaths as int)) TotalDeathCount		--here, if total_deaths was a char datatype then it would need to be converted/cast as an int.
MAX(total_deaths) TotalDeathCount
From CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
And total_deaths is not null
Group By continent
Order By TotalDeathCount Desc;

--Global/Worldwide numbers by Date

Select date Date, Sum(new_cases) [Total Cases], Sum(new_deaths) [Total Deaths], Format(SUM(new_deaths)/Sum(new_cases)*100, '#0.#0') + '%' [Death Pct]
From dbo.CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
Group By date
Order By 1,2;

--Global/Worldwide Total Cases

Select Format(Sum(new_cases), '###,###,##0') [Total Cases], Format(Sum(new_deaths), '###,###,##0') [Total Deaths], Format(SUM(new_deaths)/Sum(new_cases)*100, '#0.#0') + '%' [Death Pct]
From dbo.CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
Order By 1,2;

Select Max(date) [As Of], Format(Sum(new_cases), '###,###,##0') [Total Cases], Format(Sum(new_deaths), '###,###,##0') [Total Deaths], Format(SUM(new_deaths)/Sum(new_cases)*100, '#0.#0') + '%' [Death Pct]
From dbo.CovidDeaths_3
Where continent <> '' And continent is not null		--continent is not blank and not null, checks for both.
;

/*With this Join, if you scroll across each row you will see records from both tables.
At the end of ea rec for CvdDeaths you will see the beginning of the 1st rec for CvdVacs.
*/

Select * 
From PortfolioProject..CovidDeaths_3 CvdDeaths
Join PortfolioProject..CovidVaccinations CvdVacs
On CvdDeaths.date = CvdVacs.date
And CvdDeaths.location = CvdVacs.location;

/*Using the above qry (modified) 
Display global population vs global vaccinations
(how many people in the world have been vacc)
using a running total by location & date.
*/

Select CvdDeaths.continent, CvdDeaths.location, CvdDeaths.date,
CvdDeaths.population, CvdVacs.new_vaccinations new_vaccinations_daily,
SUM(CvdVacs.new_vaccinations) 
OVER (PARTITION By CvdDeaths.Location Order By CvdDeaths.Location, CvdDeaths.date) 
As [Running TTL People Vacc]	-- Every time location changes set Sum = 0 for new location vaccs.

/*Here, we want to show the % vaccs/population for ea location
by using the last [Running TTL People Vacc] number for ea location
e.g., ([Running TTL People Vacc]/CvdDeaths.population)*100
But we cant use the [Running TTL People Vacc] bec it was created & not a table col name.
So we need to create a CTE or a Temp tbl for this calc.
*/

From PortfolioProject..CovidDeaths_3 CvdDeaths
Join PortfolioProject..CovidVaccinations CvdVacs
On CvdDeaths.location = CvdVacs.location 
And CvdDeaths.date = CvdVacs.date
Where CvdDeaths.continent <> '' And CvdDeaths.continent is not null		--continent is not blank and not null, checks for both.
Order By 2,3;

--Using a CTE named PopsvsVac to calc % population vaccs/location
With PopsvsVac (Continent, Location, Date, Population, New_Vaccinations, RunningTTLPeopleVacc)
as
(
Select CvdDeaths.continent, CvdDeaths.location, CvdDeaths.date,
CvdDeaths.population, CvdVacs.new_vaccinations,
SUM(CvdVacs.new_vaccinations) 
OVER (PARTITION By CvdDeaths.Location 
Order By CvdDeaths.Location, CvdDeaths.date) As RunningTTLPeopleVacc	

/*Here, we want to show the % vaccs/population for ea location
by using the last [Running TTL People Vacc] number for ea location
e.g., ([Running TTL People Vacc]/CvdDeaths.population)*100
*/

From PortfolioProject..CovidDeaths_3 CvdDeaths
Join PortfolioProject..CovidVaccinations CvdVacs
On CvdDeaths.location = CvdVacs.location 
And CvdDeaths.date = CvdVacs.date
Where CvdDeaths.continent <> ''
--Order By 2,3	--can't use Order By in CTE
)
Select *, (RunningTTLPeopleVacc/Population)*100	
From PopsvsVac;

--Creating a Temp table to calc % population vaccs/location
Drop Table If Exists #PercentPopulationVaccinated;

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_Vaccinations numeric, 
RunningTTLPeopleVacc numeric
)
Insert Into #PercentPopulationVaccinated
Select CvdDeaths.continent, CvdDeaths.location, CvdDeaths.date,
CvdDeaths.population, CvdVacs.new_vaccinations,
SUM(CvdVacs.new_vaccinations) 
OVER (PARTITION By CvdDeaths.Location 
Order By CvdDeaths.Location, CvdDeaths.date) As RunningTTLPeopleVacc	

/*Here, we want to show the % vaccs/population for ea location
by using the last [Running TTL People Vacc] number for ea location
e.g., ([Running TTL People Vacc]/CvdDeaths.population)*100
*/

From PortfolioProject..CovidDeaths_3 CvdDeaths
Join PortfolioProject..CovidVaccinations CvdVacs
On CvdDeaths.location = CvdVacs.location 
And CvdDeaths.date = CvdVacs.date
Where CvdDeaths.continent <> ''
--Order By 2,3	--can't use Order By in CTE

Select *, (RunningTTLPeopleVacc/Population)*100	[PctPeopleVacc/Population]
From #PercentPopulationVaccinated;

--Create a View To Store Data Later For Visualization.
Create View PercentPopulationVaccinated As
Select CvdDeaths.continent, CvdDeaths.location, CvdDeaths.date,
CvdDeaths.population, CvdVacs.new_vaccinations,
SUM(CvdVacs.new_vaccinations) 
OVER (PARTITION By CvdDeaths.Location 
Order By CvdDeaths.Location, CvdDeaths.date) As RunningTTLPeopleVacc	
From PortfolioProject..CovidDeaths_3 CvdDeaths
Join PortfolioProject..CovidVaccinations CvdVacs
On CvdDeaths.location = CvdVacs.location 
And CvdDeaths.date = CvdVacs.date
Where CvdDeaths.continent <> ''
--Order By 2,3	--can't use Order By in View

/*To see the View, From Menu
View, Object Explorer, Databases, PortfolioProject, Views
Rt-click dbo.PercentPopulationVaccinated, Select Top 1000 Rows
*/
Select * From PercentPopulationVaccinated;

-- Save to GitHub


























































































