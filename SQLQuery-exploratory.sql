select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

SELECT
    Location,
    date,
    total_cases,
    Population,
    CASE 
        WHEN TRY_CONVERT(float, total_cases) IS NOT NULL AND TRY_CONVERT(float, total_deaths) IS NOT NULL
        THEN TRY_CONVERT(float, total_deaths) / TRY_CONVERT(float, total_cases)*100
        ELSE NULL
    END AS DeathPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
Where location like '%israel%'
ORDER BY 1, 2;


-- Looking at Total Cases vs Poplulation
-- Shows what percentage of population got covid

select Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfacted
from PortfolioProject..CovidDeaths
where continent is not null
Where location like '%germany%'
order by 1,2


-- Looking at countries with the highest infaction rate compared to population

SELECT
    Location,
    population,
    Max(total_cases) AS HighestInfectionCount,
    Max((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
--WHERE location LIKE '%israel%'
GROUP BY Location, population
ORDER BY PercentPopulationInfected desc

-- Let's break things down by continent

SELECT
    continent,
    MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%israel%'
Where continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc



-- Showing the Countries with the highest death count per population

SELECT
    continent,
    MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
--WHERE location LIKE '%israel%'
GROUP BY continent
ORDER BY TotalDeathCount desc



-- Global numbers


SELECT

    SUM(new_cases) AS TotalNewCases,
    SUM(cast(new_deaths as int)) AS TotalNewDeaths,
	sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
	from PortfolioProject..CovidDeaths
	where continent is not null
	order by 1,2

--Looking at the toatl population vs Vaccinations

WITH PopVsVac (Continent, Location, Date, Population, New_Vaccination, TotalNewVaccinations)
AS
(
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS TotalNewVaccinations
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *,
       TotalNewVaccinations / CAST(population AS FLOAT) * 100 AS VaccinationPercentage
FROM PopVsVac;



-- USE CTE
with PopVsVac as
(
    SELECT
        dea.continent AS Continent,
        dea.location AS Location,
        dea.date AS Date,
        dea.population AS Population,
        vac.new_vaccinations AS NewVaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS TotalNewVaccinations
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    -- ORDER BY dea.location, dea.date
)
SELECT *
FROM PopVsVac;


-- Temp table

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalNewVaccinations numeric
)

insert into #PercentPopulationVaccinated
SELECT
        dea.continent AS Continent,
        dea.location AS Location,
        dea.date AS Date,
        dea.population AS Population,
        vac.new_vaccinations AS NewVaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS TotalNewVaccinations
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    --WHERE dea.continent IS NOT NULL
    -- ORDER BY dea.location, dea.date

	SELECT *, (TotalNewVaccinations/population)*100
FROM #PercentPopulationVaccinated
-------------------------------------------------



--Creating view to store data for later visualizations

create view PercentPopulationVaccinated as
SELECT
        dea.continent AS Continent,
        dea.location AS Location,
        dea.date AS Date,
        dea.population AS Population,
        vac.new_vaccinations AS NewVaccinations,
        SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS TotalNewVaccinations
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    --ORDER BY dea.location, dea.date

	select *
	from PercentPopulationVaccinated
