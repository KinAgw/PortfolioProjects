

SELECT *
FROM [Portfolio Project].dbo.CovidDeaths
Where continent is not null
order by 3, 4


--SELECT *
--FROM [Portfolio Project].dbo.CovidVaccinations
--order by 3, 4

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project].dbo.CovidDeaths
order by 1, 2



--TOTAL CASES vs TOTAL DEATHS
--Shows likelihood of dying if you contract covid in your country

SELECT Location,date,total_cases,total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
FROM [Portfolio Project].dbo.CovidDeaths
Where location like '%states%'
order by 1, 2


--Looking at TOTAL CASES vs POPULATION
--Shows what population got covid

SELECT Location,date,population,total_cases, (total_cases/population) * 100 as PercentagePopulationInfected
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
order by 1, 2


--COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION


SELECT Location , population, MAX(total_cases) as HighestInfectionsCount, MAX((total_cases/population)) * 100 as PercentagePopulationInfected
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location, Population
order by PercentagePopulationInfected desc



--COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION


SELECT Location , MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc


--BREAK THINGS DOWN BY CONTINENT

SELECT location , MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
order by TotalDeathCount desc



--CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION


SELECT continent , MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



--GLOBAL NUMBERS

SELECT SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, SUM(Cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM [Portfolio Project].dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1, 2



--TOTAL POPULATION vs VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2, 3



--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMP TABLE

DROP TABLE if exists #PercentagePopulationVaccinated

CREATE TABLE #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
----,(RollingPeopleVaccinated/population)*100
FROM [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2, 3


SELECT*, (RollingPeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated



CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

Create view PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio Project].dbo.CovidDeaths dea
Join [Portfolio Project].dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2, 3

Select *
FROM PercentagePopulationVaccinated