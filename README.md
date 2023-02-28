# Shows Database Project

## Project Summary.
---

In this project my objective was to create a Database with shows and movies from the Netflix and Disney platforms, fetching the data from a S3 Bucket, performing an EDA in order to fill the most of the missing data, deciding the best structure for the database and performing some queries to test it's performance.

![Project_diagram](https://user-images.githubusercontent.com/107011436/221941868-077bb7b3-33ae-46b6-b563-194dd087f928.png)


## Programatic.
---
First, I created a Python function able to fecth csv files from an S3 instance and downloads them.
Taking into account some of the errors that could the bad input of credentials or the likes, the function uses trys instances to give the user feedback in case of being neccesary.
Also considering the most common separators in .csv files, those being "," and ";".

## QA.
---
Then I procceded with the study and transformation of the files as dataframes making use of the pandas library.
I tried to find the most information I could from within only the data in the dataframes.

## Data Modeling.
---
Before deciding where and how I was going to build my database, I first designed the database structure diagram.

![Data_model_diagram](https://user-images.githubusercontent.com/107011436/221942890-fecc0cba-10f2-40cb-9d44-6583460a7fea.png)

I decided the best was to use a snowflake model and create the database in Postgresql inside a Docker container with PgAdmin to manage it.

The credentials are:

- PgAdmin:

user : admin@admin.com

password : admin

- Postgres DB:

user : root

password : root

## SQL.
---
After uploading the dataframes to their corresponding tables using the SQLAlchemy library, I decided to test it's performance by running some queries and a stored procedure.

- Taking into acount only the Netflix platform, who actor appears most times?

![top_actor_on_netflix](https://user-images.githubusercontent.com/107011436/221945170-9ff3f4ca-e086-43fe-b48b-9d8dedceae38.png)

- Top 10 of most frequent actors in both platformns in 2021.

![top_actors_both_platforms](https://user-images.githubusercontent.com/107011436/221945648-f8811dcd-e466-4970-86fa-b190f021a995.png)

- Stored Pocedure (Returns the 5 longest films given the year parameter.)

![stored_procedure](https://user-images.githubusercontent.com/107011436/221946568-42b79b4a-88cc-4367-b8f7-dc6e2e7cdf29.png)

## Files used.
---
- Python_code.ipynb (Jupyter Notebook containing the function, the EDA and the data transformations.)

- docker_compose.docker (Docker file containing the images of Postgres and PgAdmin.)

- sql_code.DDL (DDL file containing the queries to create the database, it's tables, constraints and the stored procedure.)

- SQL - Queries and results.txt (Text file with the queries used to test the database and their results.)

- disney.csv (CSV file with the Disney platform shows data.)

- netflix.csv (CSV file with the Netflix platform shows data.)

- disney_m.csv (CSV file with the Disney platform shows modified data.)

- netflix_m.csv (CSV file with the Netflix platform shows modified data.)
