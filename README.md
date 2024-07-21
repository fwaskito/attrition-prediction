# Attrition Prediction

![GitHub Created At](https://img.shields.io/github/created-at/fwaskito/attrition-prediction?color=262626) [![DOI](https://zenodo.org/badge/825345024.svg)](https://zenodo.org/doi/10.5281/zenodo.12790616)

Employee attrition prediction system is a ML-based decision support system (DSS). The system use the k-nn method, a supervised learning classifier, to predict whether a future employee will leave the company or not based on employee data in the database.

The raw data used to provide employee data and design the database schema is the [IBM attrition dataset](https://www.kaggle.com/datasets/yasserh/ibm-attrition-dataset). This dataset was analyzed and pre-processed before being imported into the system database.

## Tech Used
### Most Vital
- [**Venv**](https://docs.python.org/3/library/venv.html) &mdash; Lightweight Python virtual environment
- [**Flask**](https://flask.palletsprojects.com) &mdash; Flexible web framework for Python
- [**Bootstrap**](https://getbootstrap.com) &mdash; Front-end development framework
- [**PostgreSQL**](https://www.postgresql.org) &mdash; Relational database

### Dependencies
[![Badge](https://img.shields.io/badge/flask-v3.0.3-blue)](https://pypi.org/project/Flask) [![Badge](https://img.shields.io/badge/flask--WTF-v1.2.1-blue)](https://pypi.org/project/Flask-WTF) [![Static Badge](https://img.shields.io/badge/pandas-v2.2.2-blue)](https://pypi.org/project/pandas) [![Static Badge](https://img.shields.io/badge/psycopg2--binary-v2.9.9-blue)](https://pypi.org/project/psycopg2-binary) [![Static Badge](https://img.shields.io/badge/scikit--learn-v1.5.1-blue)](https://pypi.org/project/scikit-learn) [![Static Badge](https://img.shields.io/badge/WTForms-v3.1.2-blue)](https://pypi.org/project/WTForms)

## Installation
### 1. Install Dependency
Create a local Python virtual environment in the project's root directory, then install the dependencies using the `pip` command.
```bash
pip install -r requirements.txt
```
> [!TIP]
> Optionally, we can use environment management tools for Python such as Miniconda or Virtualenvwrapper. Using the same commands as above, install the dependencies in a centralized environment instead of a local one, for a more organized way of working.

### 2. Import Database
Basic psql import command with implicit user (postgres)
```bash
psql database_name < backup_file.bak
```
or with specific user.
```bash
psql -U user_name -W -d database_name -f backup_file.bak
```
> [!NOTE]
> Location of database backup files in the project: `app/models/backup/*`.

> [!TIP]
> If using a remote database, replace `database_name` with `database_URL` instead.
### 3. Add New User to Database
```sql
INSERT INTO sys_user
VALUES ('US3', 'Your Name', 'admin', 'your_username', 'your_password');
```
### 4. Set Necessary Environment Variables

There are several environment variables that are used as configuration when the application runs. These variables are listed below:
| Variabel          | Description |
|-------------------|-------------| 
|FLASK_APP          | flask run-script location    |
|SECRET_KEY         | key to sign session cookie   |
|POSTGRES_HOST      | database host name           |
|POSTGRES_DATABASE  | database name                |
|POSTGRES_USER      | user used to access database |
|POSTGRES_PASSWORD  | user authentication password |


Set environment variables on Linux using Bash.
```bash
export FLASK_APP="app"
```
```bash
export SECRET_KEY="create your own key"
```
```bash
export POSTGRES_HOST="your_host"
```
```bash
export POSTGRES_DATABASE="your_database_name"
```
```bash
export POSTGRES_USER="your_name"
```
```bash
export POSTGRES_PASSWORD="your_password"
```
Set environment variables on Windows using PowerShell.
```pwsh
$Env:FLASK_APP="app"
```
```pwsh
$Env:SECRET_KEY="create your own key"
```
```pwsh
$Env:POSTGRES_HOST="your_host"
```
```pwsh
$Env:POSTGRES_DATABASE="your_database_name"
```
```pwsh
$Env:POSTGRES_USER="your_name"
```
```pwsh
$Env:POSTGRES_PASSWORD="your_password"
```
Variables as above are temporary. So we need to re-set them every time we change sessions (e.g., reopen the shell).

> [!TIP]
> Optionally, we can create aliases for several commands in Bash or PowerShell to increase the efficiency of repeated use. So, we can set all variables with a simple command (e.g., `exportenv`).

## License
The source code of this system is under the [BSD 2-Clause](https://choosealicense.com/licenses/bsd-2-clause) license.
