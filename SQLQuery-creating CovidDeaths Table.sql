CREATE TABLE [dbo].[CovidDeaths] (
    [iso_code] nvarchar(255),
    [continent] nvarchar(255),
    [location] nvarchar(255),
    [date] datetime,
    [population] float,
    [total_cases] nvarchar(255),  -- This column might need a different data type
    [new_cases] float,
    [new_cases_smoothed] float,
    [total_deaths] nvarchar(255),  -- This column might need a different data type
    [new_deaths] float,
    [new_deaths_smoothed] float,
    [total_cases_per_million] nvarchar(255),  -- This column might need a different data type
    [new_cases_per_million] float,
    [new_cases_smoothed_per_million] float,
    [total_deaths_per_million] nvarchar(255),  -- This column might need a different data type
    [new_deaths_per_million] float,
    [new_deaths_smoothed_per_million] float,
    [reproduction_rate] nvarchar(255),  -- This column might need a different data type
    [icu_patients] nvarchar(255),  -- This column might need a different data type
    [icu_patients_per_million] nvarchar(255),  -- This column might need a different data type
    [hosp_patients] nvarchar(255),  -- This column might need a different data type
    [hosp_patients_per_million] nvarchar(255),  -- This column might need a different data type
    [weekly_icu_admissions] nvarchar(255),  -- This column might need a different data type
    [weekly_icu_admissions_per_million] nvarchar(255),  -- This column might need a different data type
    [weekly_hosp_admissions] nvarchar(255),  -- This column might need a different data type
    [weekly_hosp_admissions_per_million] nvarchar(255)  -- This column might need a different data type
);
