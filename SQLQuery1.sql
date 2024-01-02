select*from [dbo].[CovidDeaths$]
where continent is NOT NULL
order by location , date
--select*from [dbo].[CovidVaccinations$]
--looking for useful data

select location,date,total_cases,new_cases,population ,total_deaths from [dbo].[CovidDeaths$]
where continent is NOT NULL
order by location , date

--total cases vs total deaths

select location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as morbidity from [dbo].[CovidDeaths$]
where continent is not null and location like 'India'
order by 1,2

--looking at total cases vs population

select location,date,total_cases,population ,(total_cases/population)*100 as infectedpercentage from [dbo].[CovidDeaths$]
where continent is not null --and location like 'India'
order by 1,2

--looking at countires with highest infection rate compared to population

select location,max(total_cases),population ,max((total_cases/population))*100 as infectedpercentage from [dbo].[CovidDeaths$]
where continent is not null --and location like 'India'
group by location,population
order by  infectedpercentage desc

--showing countries with highest death count per population


select location,max(cast(total_deaths as int)) as countdeath from [dbo].[CovidDeaths$]
where continent is not null --and location like 'India'
group by location
order by countdeath desc

select continent,max(cast(total_deaths as int)) as countdeath from [dbo].[CovidDeaths$]
where continent is not null --and location like 'India'
group by continent
order by countdeath desc

--global number

select /*date*/sum(new_cases ),sum(cast(new_deaths as int)), (sum(cast(new_deaths as int))/sum(new_cases ))*100--,new_cases,population ,total_deaths 
from [dbo].[CovidDeaths$]
where continent is NOT NULL
--group by date
--order by date

select*from [dbo].[CovidVaccinations$]

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations 
,sum(convert(int,cv.new_vaccinations)) over(partition by cd.location order by cd.location,cd.date)
from [dbo].[CovidDeaths$]  cd
join [dbo].[CovidVaccinations$] cv
  on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
order by 2,3

create view popvsvac  as 
select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations 
,sum(convert(int,cv.new_vaccinations)) over(partition by cd.location order by cd.location,cd.date) as peoplevaccinated
from [dbo].[CovidDeaths$]  cd
join [dbo].[CovidVaccinations$] cv
  on cd.location=cv.location and cd.date=cv.date
where cd.continent is not null
--order by 2,3

select* from popvsvac 