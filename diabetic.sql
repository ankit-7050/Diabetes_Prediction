CREATE database IF NOT exists diabetes_prediction;

use diabetes_prediction;

# create table
create table patient_details
(
	PatientName varchar(255),
    Patient_id varchar(255),
    gender varchar(255),
    age int,
    hypertension int,
    heart_disease int,
	smoking_history varchar(255),
    bmi double,
    HbA1c_level double,
    blood_glucose_level int,
    diabetes int
    );

select * from patient_details;

# importing the csv file
load data infile 'C:\\diabetes_prediction.csv' into table patient_details
fields terminated by ','
ignore 1 lines;

# 1. Retrieve the Patient_id and ages of all patients. 
select Patient_id, age from patient_details;


# 2. Select all female patients who are older than 40. 
select PatientName from patient_details
where gender = "Female" and age > 40;

# 3. Calculate the average BMI of patients. 
select avg(bmi) as Average_bmi from patient_details;

# 4. List patients in descending order of blood glucose levels. 
select PatientName, blood_glucose_level from patient_details
order by blood_glucose_level desc;

# 5. Find patients who have hypertension and diabetes. 
select PatientName from patient_details
where hypertension = 1 and diabetes = 1;

# 6. Determine the number of patients with heart disease. 
select count(*) as Heart_Disease_Patients from patient_details
where heart_disease = 1;

# 7. Group patients by smoking history and count how many smokers and non smokers there are. 
select count(*) as Smokers from patient_details
where smoking_history = "current";

select count(*) as Non_Smokers from patient_details
where smoking_history = "never";

# 8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI. 
select patient_id, bmi from patient_details
where bmi > (
				select avg(bmi) 
                from patient_details
                );
# avg(bmi) = 27.34818077882965

select avg(bmi) from patient_details;  

# 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.
select PatientName, HbA1c_level from patient_details
order by HbA1c_level desc
limit 1;

select PatientName, HbA1c_level from patient_details
order by HbA1c_level asc
limit 1;

# 10. Calculate the age of patients in years (assuming the current date as of now). 
select PatientName, 
				year(now()) - age as BirthYear, 
                year(now()) - year(now()) + age as PatientAge
from patient_details;

# 11. Rank patients by blood glucose level within each gender group. 
select PatientName, gender, blood_glucose_level,
	rank() over (partition by gender order by blood_glucose_level) as Rank_of_Patients
from patient_details;
    
# 12. Update the smoking history of patients who are older than 50 to "Ex-smoker."
set sql_safe_updates = 0;

update patient_details
set smoking_history = "Ex-smoker"
where age>50;

select * from patient_details;

# 13. Insert a new patient into the database with sample data. 
insert into Patient_details values("Mukesh Singh" ,"PT100101", "Male", 24, 1, 0, "current", 34.54, 4.8, 110, 1);
select * from patient_details;

# 14. Delete all patients with heart disease from the database.
delete from patient_details
where heart_disease = 1;

select * from patient_details;

# 15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
select PatientName, hypertension, diabetes from patient_details
where hypertension = 1
except 
select PatientName, hypertension, diabetes from patient_details
where diabetes = 1;

#Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'except  select PatientName, hypertension, diabetes from patient_details where di' at line 3

# 16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
alter table patient_details
add constraint Patient_id unique (Patient_id);

insert into Patient_details values("Ankit Singh" ,"PT100102", "Male", 24, 1, 0, "current", 34.54, 4.8, 110, 1);
select * from patient_details;

# 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
create view dispaly_data as (
		select Patient_id, age, bmi
        from patient_details
        );
select * from dispaly_data;


