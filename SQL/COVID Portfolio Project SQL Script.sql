SELECT * FROM
PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT * FROM
--PortfolioProject..CovidVaccinations
--ORDER BY 3,4

-- Select data we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows Likelihood of dying if you contract covid
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%India%'
AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at the total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%India%'
AND continent IS NOT NULL
ORDER BY 1,2

-- Looking at countries with Highest Infection Rate compared to population
SELECT location, population, 
		MAX(total_cases) AS HighestInfectionCount,
		MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
--WHERE location like '%India%'
ORDER BY PercentPopulationInfected DESC

-- Showing countries with Highest Death Count per Population
SELECT location, 
		MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
--WHERE location like '%India%'
ORDER BY TotalDeathCount DESC

-- BREAK things down by CONTINENT
SELECT location, 
		MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
--WHERE location like '%India%'
ORDER BY TotalDeathCount DESC

-- BREAK things down by CONTINENT
SELECT continent, 
		MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
--WHERE location like '%India%'
ORDER BY TotalDeathCount DESC

--Showing continents with the Highest Death Count per Population
-- BREAK things down by CONTINENT
SELECT continent, 
		MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
--WHERE location like '%India%'
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS
SELECT date, 
		SUM(new_cases) AS total_cases,
		SUM(CAST(new_deaths AS INT)) AS total_deaths,
		(SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT 
		SUM(new_cases) AS total_cases,
		SUM(CAST(new_deaths AS INT)) AS total_deaths,
		(SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- Looking at Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, 
		dea.population, vac.new_vaccinations,
		SUM(CONVERT(INT, vac.new_vaccinations)) OVER
		(PARTITION BY dea.location
		 ORDER BY dea.date) AS RollingPeopleVaccinated
		-- (RollingPeopleVaccinated/population)*100
FROM
PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON 
	dea.location = vac.location AND
	dea.date     = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Use CTE

With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, 
		dea.population, vac.new_vaccinations,
		SUM(CONVERT(INT, vac.new_vaccinations)) OVER
		(PARTITION BY dea.location
		 ORDER BY dea.date) AS RollingPeopleVaccinated
		-- (RollingPeopleVaccinated/population)*100
FROM
PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON 
	dea.location = vac.location AND
	dea.date     = vac.date
WHERE dea.continent IS NOT NULL
)

SELECT *,  (RollingPeopleVaccinated/population)*100
FROM PopvsVac



-- Temp Table
DROP TABLE IF EXISTS  #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
		continent NVARCHAR(255),
		location NVARCHAR(255),
		date DATETIME,
		population NUMERIC,
		new_vaccinations NUMERIC,
		RollingPeopleVaccinated NUMERIC
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, 
		dea.population, vac.new_vaccinations,
		SUM(CONVERT(INT, vac.new_vaccinations)) OVER
		(PARTITION BY dea.location
		 ORDER BY dea.date) AS RollingPeopleVaccinated
FROM
PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON 
	dea.location = vac.location AND
	dea.date     = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

SELECT *,  (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, 
		dea.population, vac.new_vaccinations,
		SUM(CONVERT(INT, vac.new_vaccinations)) OVER
		(PARTITION BY dea.location
		 ORDER BY dea.date) AS RollingPeopleVaccinated
FROM
PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON 
	dea.location = vac.location AND
	dea.date     = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT * FROM PercentPopulationVaccinated
