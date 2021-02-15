/*
  IST 659 Final Project DDL
  Kanning Wu
  03/24/2020
*/

USE IST659_Final_Project

-- Drop tables if exist
DROP TABLE IF EXISTS Patient
DROP TABLE IF EXISTS Outbreak
DROP TABLE IF EXISTS Patient_status
DROP TABLE IF EXISTS Locations
DROP TABLE IF EXISTS Pathogen
DROP TABLE IF EXISTS Literature
DROP TABLE IF EXISTS Drug_status
DROP TABLE IF EXISTS Treatment
DROP TABLE IF EXISTS Vaccine

-- Creating the Drug_status table
CREATE TABLE Drug_status (
  -- Columns for the Drug_status table
  drug_status_id int identity,
  drug_name varchar(200),
  is_available varchar(1) default 'F',
  drug_description varchar(2000),
  url varchar(5000),
  -- Constraints on the Drug_status table
  CONSTRAINT PK_drug_status_id PRIMARY KEY (drug_status_id)
)
-- End creating the Drug_status table

-- Creating the Patient_status table
CREATE TABLE Patient_status (
  -- Columns for the Patient_status table
  patient_status_id int identity,
  is_confirmed varchar(1),
  is_healed varchar(1),
  dead varchar(1),
  condition varchar(500),
  -- Constraints on the Patient_status table
  CONSTRAINT PK_patient_status_id PRIMARY KEY (patient_status_id)
)
-- End creating the Patient_status table

-- Creating the Location table
CREATE TABLE Locations (
  -- Columns for the Location table
  location_id int identity,
  street varchar(20),
  city varchar(20),
  state varchar(20),
  zipcode varchar(10),
  country varchar(20),
  -- Constraints on the Location table
  CONSTRAINT PK_location_id PRIMARY KEY (location_id)
)
-- End creating the Location table

-- Creating the Pathogen table
CREATE TABLE Pathogen (
  -- Columns for the Pathogens table
  pathogen_id int identity,
  pathogen_name varchar(50),
  serotype varchar(50),
  -- Constraints on the Pathogens table
  CONSTRAINT PK_pathogen_id PRIMARY KEY (pathogen_id)
)
-- End creating the Pathogens table

-- Creating the Literature table
CREATE TABLE Literature (
  -- Columns for the Literature table
  literature_id int identity,
  title varchar(200),
  pathogen_id int,
  author varchar(50),
  published_date datetime,
  description varchar(2000),
  url varchar(2000),
  -- Constraints on the Literature table
  CONSTRAINT PK_literature_id PRIMARY KEY (literature_id),
  CONSTRAINT FK1_pathogen_id FOREIGN KEY (pathogen_id) REFERENCES Pathogen (pathogen_id)
)
-- End creating the Literature table

-- Creating the Vaccine table
CREATE TABLE Vaccine (
  -- Columns for the Vaccine table
  vaccine_id int identity,
  pathogen_id int,
  drug_status_id int, 
  -- Constraints on the Vaccine table
  CONSTRAINT PK_vaccine_id PRIMARY KEY (vaccine_id),
  CONSTRAINT FK2_pathogen_id FOREIGN KEY (pathogen_id) REFERENCES Pathogen (pathogen_id),
  CONSTRAINT FK1_drug_status_id FOREIGN KEY (drug_status_id) REFERENCES Drug_status (drug_status_id)
)
-- End creating the Vaccine table

-- Creating the Treatment table
CREATE TABLE Treatment (
  -- Columns for the Treatment table
  treatment_id int identity,
  pathogen_id int,
  drug_status_id int,
  -- Constraints on the Treatment table
  CONSTRAINT PK_treatment_id PRIMARY KEY (treatment_id),
  CONSTRAINT FK3_pathogen_id FOREIGN KEY (pathogen_id) REFERENCES Pathogen (pathogen_id),
  CONSTRAINT FK2_drug_status_id FOREIGN KEY (drug_status_id) REFERENCES Drug_status (drug_status_id)
)
-- End creating the Treatment table

-- Creating the Patient table
CREATE TABLE Patient (
	--Columns for the Patient table
  patient_id int identity,
  first_name varchar(50),
  last_name varchar(50),
  address varchar(100),
  infected_date datetime,
  infected_location int,
  patient_status int,
  pathogen_id int,
  -- Constraints on the User table
	CONSTRAINT PK_patient PRIMARY KEY (patient_id),
  CONSTRAINT FK1_infected_location FOREIGN KEY (infected_location) REFERENCES Locations(location_id),
  CONSTRAINT FK2_patient_status FOREIGN KEY (patient_status) REFERENCES Patient_status(patient_status_id),
  CONSTRAINT FK4_pathgoen_id FOREIGN KEY (pathogen_id) REFERENCES Pathogen(pathogen_id)
)
--End Creating the User table

/*
-- Creating the Outbreak table
CREATE TABLE Outbreak (
  -- Columns for the Outbreak table
  outbreak_id int identity,
  pathogen_id int,
  location_id int,
  -- Constraints on the Outbreak table
  CONSTRAINT PK_outbreak PRIMARY KEY (outbreak_id),
  CONSTRAINT FK1_pathogen_id FOREIGN KEY (pathogen_id) REFERENCES Pathogen(pathogen_id),
  CONSTRAINT FK3_location_id FOREIGN KEY (location_id) REFERENCES Locations(location_id)
)
-- End Creating the Outbreak table
*/

