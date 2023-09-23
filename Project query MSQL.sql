--Data exploration of covid 19 dataset--

--#1.Importing Datasets
Select *
From portfolio_project..CovidDeaths
where continent is not null
order by 3,4

Select *
From Portfolio_Project..CovidVaccinations
order by 3,4

--#2.select Data that we are going to be using

select location,date, total_cases, new_cases,total_deaths,population
 from Portfolio_Project..CovidDeaths
 where continent is not null
order by 1,2


 --#3.looking at total_cases vs total_deaths

select location, date, total_cases,total_deaths,
 (CONVERT (float,total_deaths)/NULLIF(CONVERT(float,total_cases),0))*100 as DeathPercentage
 from Portfolio_Project..CovidDeaths
 where location = 'India'
 and  continent is not null
order by 1,2

--#4.look at total cases vs population
--*shows what percentage of population got covid*--

select location, date, total_cases,population,
 NULLIF(CONVERT(float,total_cases),0)/(population)*100 as Percent_Population_infected
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
order by 1,2

--#5.looking at countries with highest infection rate compared to population

select location ,population, MAX( total_cases) AS Highest_Infection_count,
 max(NULLIF(CONVERT(float,total_cases),0)/(population))*100 as Percent_Population_infected
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 group by location,population
order by Percent_Population_infected desc

--#6.showing countries with highest death count per population

select location , MAX(cast(total_deaths as int)) AS Highest_Death_count
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 group by location
order by Highest_Death_count desc

--#7.lets break this down by continent

select continent , MAX(cast(total_deaths as int)) AS Highest_Death_count
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 group by continent
 order by Highest_Death_count desc

--#8.showing the continents with highest death count

 select continent , MAX(cast(total_deaths as int)) AS Highest_Death_count
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 group by continent
 order by Highest_Death_count desc

--#9.global numbers
 
 select  sum(new_cases)as Total_cases,sum(new_deaths) as Total_deaths,
 (sum(new_deaths) *100.0)/sum(nullif(new_cases,0)) as DeathPercentage
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 --group by date
 order by 1,2

--#10.joining two tables
--*looking at total population vs vaccinations*--

select deaths.continent, deaths.location, deaths.date , deaths.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date)
as Rolling_People_Vaccinated
from Portfolio_Project..CovidDeaths  deaths
join Portfolio_Project..CovidVaccinations   vac
on deaths. location = vac.location
and deaths.date = vac.date
where deaths.continent is not null
order by 2,3


--#11.USING CTE

with PopvsVac (Continent, Location, Date, Population,New_vaccinations, Rolling_People_Vaccinated)
as
(
select deaths.continent, deaths.location, deaths.date , deaths.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date)
as Rolling_People_Vaccinated
from Portfolio_Project..CovidDeaths  deaths
join Portfolio_Project..CovidVaccinations   vac
on deaths. location = vac.location
and deaths.date = vac.date
where deaths.continent is not null
--order by 2,3
)

select *,nullif(CONVERT (float,Rolling_People_Vaccinated),0)/(population)*100
from PopvsVac


--#12.TEMP TABLE

drop table if exists #PercentPopulationVaccinated
Create table  #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

insert into #PercentPopulationVaccinated
select deaths.continent, deaths.location, deaths.date , deaths.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date)
as Rolling_People_Vaccinated
from Portfolio_Project..CovidDeaths  deaths
join Portfolio_Project..CovidVaccinations   vac
on deaths. location = vac.location
and deaths.date = vac.date
--where deaths.continent is not null
--order by 2,3

select *,nullif(CONVERT (float,Rolling_People_Vaccinated),0)/(population)*100
from  #PercentPopulationVaccinated


--#13.Creating view to store data for later viz

create view PercentPopulationVaccinated as
select deaths.continent, deaths.location, deaths.date , deaths.population, vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date)
as Rolling_People_Vaccinated
from Portfolio_Project..CovidDeaths  deaths
join Portfolio_Project..CovidVaccinations   vac
on deaths. location = vac.location
and deaths.date = vac.date
where deaths.continent is not null
--order by 2,3


select * from PercentPopulationVaccinated


--#14.for visualization in Tableau
--*global numbers*


 select  sum(new_cases)as Total_cases,sum(new_deaths) as Total_deaths,
 (sum(new_deaths) *100.0)/sum(nullif(new_cases,0))as DeathPercentage
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 --group by date
 order by 1,2

-- *we take these out as they are not included in the above queries and want to say consistent*--

select location, sum(new_deaths) as Total_Death_Count
from Portfolio_Project..CovidDeaths
where continent is null
and location not in('World','High income','Upper middle income','European Union','Lower middle income','Low income')
group by location
order by 1 asc

--
select location ,population, MAX( total_cases) AS Highest_Infection_count,
 max(NULLIF(CONVERT(float,total_cases),0)/(population))*100 as Percent_Population_infected
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 where continent is not null
 group by location,population
order by Percent_Population_infected desc 

--

select location ,population,date, MAX( total_cases) AS Highest_Infection_count,
 max(NULLIF(CONVERT(float,total_cases),0)/(population))*100 as Percent_Population_infected
 from Portfolio_Project..CovidDeaths
 --where location = 'India'
 group by location,population, date
order by Percent_Population_infected desc 

