


SELECT * FROM [Portfolio Project ]..CovidDeaths

SELECT * FROM [Portfolio Project ]..CovidVaccinations


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Project ]..CovidDeaths
ORDER BY location, date


--1. Total Cases vs Total Deaths 

SELECT SUM(cast(new_cases AS bigint)) as TotalCases, SUM(CAST(new_deaths as bigint)) AS TotalDeaths, sum(cast(new_deaths as bigint))/sum(new_cases)*100 AS DeathPercentage
FROM [Portfolio Project ]..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY TotalCases,TotalDeaths

--2. Total Deaths per Day

SELECT (cast(date as Date)) AS Date, MAX(cast(new_deaths as INT)) AS Deaths 
FROM [Portfolio Project ]..CovidDeaths
GROUP BY date
ORDER BY date ASC


-- 3. Countries with the highest death count per population

SELECT location, MAX(cast(total_deaths as INT)) AS HighestDeaths
FROM [Portfolio Project ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeaths DESC

-- 4. Highest Death Count Per by Continent 

SELECT continent, MAX(cast(total_deaths AS INT)) AS Deaths 
FROM [Portfolio Project ]..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Deaths DESC

--5. Population vs Cases 

SELECT location, population, MAX(total_cases) AS cases
FROM [Portfolio Project ]..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location, population
ORDER BY cases DESC 



--Total population vs vaccinated 

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as bigint)) over (PARTITION BY d.location ORDER BY d.location, d.date) AS PeopleVaccinated
FROM [Portfolio Project ]..CovidDeaths AS d
INNER JOIN [Portfolio Project ]..CovidVaccinations AS v
ON d.location = v. location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY location, date



----------CTE	

With Popvsvac (continent, location, date, population, new_vaccinations,PeopleVaccinated)
as
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as bigint)) over (PARTITION BY d.location ORDER BY d.location, d.date) AS PeopleVaccinated
FROM [Portfolio Project ]..CovidDeaths AS d
INNER JOIN [Portfolio Project ]..CovidVaccinations AS v
ON d.location = v. location AND d.date = v.date
WHERE d.continent IS NOT NULL
)

SELECT *, (PeopleVaccinated/population)*100
FROM Popvsvac

-----------Temp

DROP TABLE if exists percentpopulationvac
CREATE TABLE percentpopulationvac
(continent NVARCHAR (255),
location NVARCHAR (255),
date datetime,
population FLOAT,
new_vaccinations FLOAT,
PeopleVaccinated FLOAT )

INSERT INTO percentpopulationvac
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as bigint)) over (PARTITION BY d.location ORDER BY d.location, d.date) AS PeopleVaccinated
FROM [Portfolio Project ]..CovidDeaths AS d
INNER JOIN [Portfolio Project ]..CovidVaccinations AS v
ON d.location = v. location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY location, date

SELECT *, (PeopleVaccinated/population)*100
FROM percentpopulationvac




DROP TABLE percentpopulationvac

---------

CREATE VIEW percentpopulationvaccinated AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, 
SUM(cast(v.new_vaccinations as bigint)) over (PARTITION BY d.location ORDER BY d.location, d.date) AS PeopleVaccinated
FROM [Portfolio Project ]..CovidDeaths AS d
INNER JOIN [Portfolio Project ]..CovidVaccinations AS v
ON d.location = v. location AND d.date = v.date
WHERE d.continent IS NOT NULL


DROP VIEW percentpopulationvaccinated


SELECT * FROM percentpopulationvaccinated














