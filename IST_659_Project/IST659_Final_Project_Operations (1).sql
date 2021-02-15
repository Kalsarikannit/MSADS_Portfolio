/*
  IST 659 Final Project DML
  Kanning Wu
  03/24/2020
*/

USE IST659_Final_Project

-- Insert into Drug_status
INSERT INTO Drug_status (drug_name, drug_description, url)
  VALUES ('v1', 'vaccine1', 'http://www.emro.who.int/health-topics/corona-virus/questions-and-answers.html'),
         ('v2', 'vaccine2', 'www.testurl.com'),
         ('t1', 'treatment3', '404'),
         ('t2', 'treatment2', 'google.com')

-- Insert into Patient_status
INSERT INTO Patient_status
  VALUES ('T','F','F', 'affected, severe symptom')

INSERT INTO Patient_status
  VALUES ('T','T','F', 'very light symptom')

INSERT INTO Patient_status
  VALUES ('T','F','T', 'DEAD')

-- Insert into Location
INSERT INTO Locations
  VALUES ('1234 st', 'Wuhan', 'Hubei', '123456', 'PRC')

INSERT INTO Locations
  VALUES ('123 st', 'NYC', 'NY', '12345', 'USA')

INSERT INTO Locations
  VALUES ('123 st', 'SFO', 'CA', '12345', 'USA')

-- Insert into Pathogen 
INSERT INTO Pathogen (pathogen_name, serotype)
  VALUES ('corona virus', 'virus'),
         ('ccp virus', 'virus'),
         ('bubonic plague','bacteria')

-- Insert into Vaccine
INSERT INTO Vaccine(pathogen_id, drug_status_id)
  VALUES ((SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'corona virus'),
          (SELECT drug_status_id FROM Drug_status WHERE drug_name = 'v1')),
         ((SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'ccp virus'),
          (SELECT drug_status_id FROM Drug_status WHERE drug_name = 'v2')),
         ((SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'corona virus'),
          (SELECT drug_status_id FROM Drug_status WHERE drug_name = 'v3'))

-- Insert into Treatment
INSERT INTO Treatment(pathogen_id, drug_status_id)
  VALUES ((SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'corona virus'),
          (SELECT drug_status_id FROM Drug_status WHERE drug_name = 't1')),
         ((SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'ccp virus'),
          (SELECT drug_status_id FROM Drug_status WHERE drug_name = 't2')),
         ((SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'corona virus'),
          (SELECT drug_status_id FROM Drug_status WHERE drug_name = 't3'))

-- Insert into Literature
INSERT INTO Literature (title, author, published_date, description, url, pathogen_id)
  VALUES ('Some title',
          'CDC',
          '3/18/2020',
          'How to Protect Yourself',
          'https://www.cdc.gov/coronavirus/2019-ncov/community/index.html',
          (SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'corona virus')),
         ('Some title',
          'CDC',
          '3/21/2020',
          'Schools, Workplaces & Community Locations',
          'https://www.cdc.gov/coronavirus/2019-ncov/prepare/prevention.html',
          (SELECT pathogen_id FROM Pathogen WHERE pathogen_name = 'corona virus'))

-- Insert into Patient
INSERT INTO Patient (first_name, last_name, address, infected_date, infected_location, patient_status, pathogen_id)
  VALUES ('San', 'Zhang', '123 ST, Wuhan, Hubei, PRC, 123456', '01/02/2020',
          (SELECT location_id FROM Locations WHERE city = 'Wuhan'),1,1),
         ('Si', 'Li', '123 ST, Wuhan, Hubei, PRC, 123456', '01/02/2020',
          (SELECT location_id FROM Locations WHERE city = 'Wuhan'),2,1),
         ('Five', 'Wang', '123 ST, Wuhan, Hubei, PRC, 123456', '01/02/2020',
          (SELECT location_id FROM Locations WHERE city = 'Wuhan'),1,1),
         ('Liu', 'Zhao', '123 ST, Wuhan, Hubei, PRC, 123456', '01/02/2020',
          (SELECT location_id FROM Locations WHERE city = 'Wuhan'),1,2),
         ('John', 'Doe', '123 ST, NYC, NY, USA, 12345', '03/02/2020',
          (SELECT location_id FROM Locations WHERE city = 'NYC'),3,2),
         ('John', 'Doe', '123 ST, NYC, NY, USA, 12345', '03/01/2020',
          (SELECT location_id FROM Locations WHERE city = 'NYC'),1,2),
         ('John', 'Doe', '123 ST, NYC, NY, USA, 12345', '03/01/2020',
          (SELECT location_id FROM Locations WHERE city = 'NYC'),2,2),
         ('Jane', 'Doe', '123 ST, SFO, CA, USA, 12345', '03/01/2020',
          (SELECT location_id FROM Locations WHERE city = 'SFO'),2,3)

