
[![Open in GitHub Codespaces](https://img.shields.io/badge/GitHub-Codespaces-blue?logo=github)](https://github.com/codespaces/new?source_repo=https://github.com/mahesh989/Extraction_via_API/tree/main/Weather)
[![GitHub issues](https://img.shields.io/github/issues/mahesh989/Extraction_via_API.svg)](https://github.com/mahesh989/Extraction_via_API/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![Python](https://img.shields.io/badge/Python-3.6%2B-blue.svg?logo=python)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13-blue.svg?logo=postgresql)
![pgAdmin4](https://img.shields.io/badge/pgAdmin4-5.7-blue.svg?logo=pgadmin)
![Docker](https://img.shields.io/badge/Docker-20.10-blue.svg?logo=docker)
![ETL](https://img.shields.io/badge/ETL-Extract%20Transform%20Load-blue)
![OpenAQ API](https://img.shields.io/badge/OpenAQ%20API-Source-blue)
![Air Quality](https://img.shields.io/badge/Air%20Quality-Data-blue)

# 🌍 OpenAQ Data Extraction and Storage
This project is designed to collect air quality data from the OpenAQ API specifically for Australia and store it in a PostgreSQL database. The purpose is to facilitate further analysis and research on air quality trends and patterns over the past decade.

## 📋 Prerequisites

Before you begin, ensure you have the following installed on your machine:

- Python 3.6+
- PostgreSQL
- SQLAlchemy
- Requests
- Pandas
- pgAdmin4

## 📊 Data Extraction and Storage

Data extraction is performed using the OpenAQ API, which allows querying air quality data based on specific parameters and geographical locations. The query parameters include the country code for Australia (AU), the list of air quality parameters, and the date range. Access to the API requires an API key, which should be set as an environment variable (`OPENAQ_API_KEY`).

### 🌟 Extracted Data

The project successfully extracted 119,709 rows of data. The extracted data includes the following columns:

- **Location**: The specific location where the data was collected.
- **City**: The city in which the data collection point is located.
- **Country**: The country code, in this case, 'AU' for Australia.
- **Parameter**: The type of air quality parameter measured (e.g., CO, O3, CH4, PM2.5, PM4, PM10, SO2, NO, NO2).
- **Value**: The recorded value of the air quality parameter.
- **Unit**: The unit of measurement for the parameter value.
- **Date (UTC)**: The date and time when the measurement was taken, in Coordinated Universal Time (UTC).
- **Latitude**: The latitude of the data collection point.
- **Longitude**: The longitude of the data collection point.

### 💾 Data Storage

The extracted data is saved in a PostgreSQL database due to its robustness, support for complex queries, and ability to handle large datasets. PostgreSQL ensures data integrity and provides essential features like indexing and transactions, crucial for managing time-series data.

#### Data Storage Process

- **Database Schema**: The database schema includes a table designed to accommodate various fields required to store air quality data effectively, such as location, city, country, parameter, value, unit, date (in UTC), latitude, and longitude.
- **Data Insertion**: Using SQLAlchemy, the data is inserted into the PostgreSQL database. This ORM (Object-Relational Mapping) layer facilitates smooth database interactions and ensures efficient data handling.

## 📈 Conclusion

This project provides a comprehensive approach to collecting and storing air quality data for Australia, enabling detailed analysis and research. By leveraging the OpenAQ API and PostgreSQL, we ensure data is systematically managed and easily accessible for further exploration and insights.

For any questions or further assistance, feel free to reach out. Happy coding!
