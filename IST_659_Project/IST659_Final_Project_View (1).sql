/*
  IST 659 Final Project Functions/Views/Procedures
  Kanning Wu
  03/24/2020
*/

USE IST659_Final_Project

-- Functions

-- Find the number patients from a specific location
GO
CREATE FUNCTION dbo.LocationCount(@locationID int)
RETURNS int AS -- COUNT() is an integer value, so return it as an int
BEGIN
	DECLARE @returnValue int -- matches the function's return type
	SELECT @returnValue = COUNT(patient_id) FROM Patient
	WHERE Patient.infected_location = @locationID

	-- Return @returnValue to the calling code
	RETURN @returnValue
END
GO
--
SELECT TOP 10
	*,
	dbo.LocationCount(infected_location) as locationCount
FROM Patient
ORDER BY LocationCount DESC

-- Look up pathogen by serotype
GO
-- Function to retrieve the vc_TagID for a given tag's text
CREATE FUNCTION dbo.drugLookup(@name varchar(50))
RETURNS varchar(1) AS -- vc_TagID as an int, so we'll match that
BEGIN
	DECLARE @returnValue varchar(1)-- Matches the function's return type

	/*
		Get the vc_TagID of the vc_Tag record whose TagText
		matches the parameter and assign that value to @returnValue
	*/
	SELECT @returnValue = is_available
	FROM Drug_status
	WHERE Drug_status.drug_name = @name

	-- Send the vc_TagID back to the caller
	RETURN @returnValue
END
GO

-- Test serotypeLookup function
SELECT dbo.drugLookup('v1')
SELECT dbo.drugLookup('cerveza corona') -- jk
SELECT dbo.drugLookup('t2')


-- Views

-- Views for most infected location
GO
CREATE VIEW MostInfectedLocations AS
	SELECT TOP 10
		city,
		[state],
		dbo.LocationCount(infected_location) as LocationCount
	FROM Patient
	JOIN Locations ON Locations.location_id = patient_id
	ORDER BY LocationCount DESC
GO

-- Test the vc_MostProlificUsers VIEW
SELECT * FROM MostInfectedLocations

-- Procedures

-- Update patients status
GO
CREATE PROCEDURE UpdatePatientStatus(@patientID int, @confirmed varchar(1), @healed varchar(1), @dead varchar(1),@description varchar(400))
AS
BEGIN
	UPDATE Patient_status SET is_confirmed = @confirmed, is_healed = @healed, dead = @dead, condition = @description
	WHERE patient_status_id = @patientID
  --TODO use join to join patient and patient status
END
GO

EXEC UpdatePatientStatus '1','T','F','T', 'failed'
EXEC UpdatePatientStatus '2','F','F','F', 'inaccurate test'
EXEC UpdatePatientStatus '3','T','T','F', 'Yay'

SELECT * FROM Patient_status

-- The current number of infected people
SELECT COUNT(patient_id) FROM Patient

-- Number of people are healed/dead
SELECT COUNT(is_healed) FROM Patient_status
SELECT COUNT(dead) FROM Patient_status

-- Cities to avoid
SELECT * FROM MostInfectedLocations

-- Methods can be used 
SELECT * FROM Treatment

-- Track quarantined patients
SELECT address FROM Patient

-- Type of pathogen
SELECT serotype FROM Pathogen
