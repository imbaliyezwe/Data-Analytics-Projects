
Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4


Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at the total cases vs total deaths
--Shows the liklihood of dying in South Afrca

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%south africa%'
order by 1,2

--Looking at Total Cases Vs Population 
-- Show percantange of population infected by Covid

Select Location, date, total_cases, Population, (total_cases/Population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--where location like '%south africa%'
order by 1,2

--Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestinfectionCount, MAX((total_cases/Population))*100 as PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentagePopulationInfected desc

--Showing Countries with Highest Death per Population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location 
order by TotalDeathCount desc


--Breaking Things Down By Continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Global Numbers

Select SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

--Total Vaccinations vs Population

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.Location
Order by dea.location, dea.Date) as RollingVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  order by 2,3

  --CTE


  With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingVaccinations)
  as

(
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations )) OVER (Partition by dea.Location
Order by dea.location, dea.Date) as RollingVaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  Where dea.continent is not null
  --order by 2,3
  ) 
  Select *, (RollingVaccinations/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingVaccinations
--, (RollingVaccinations/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
