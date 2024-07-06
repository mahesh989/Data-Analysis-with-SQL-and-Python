--- 
Report: Importing country.csv into PostgreSQL using Docker and pgAdmin 4
---

### Objective
The objective of this report is to provide a detailed guide for setting up PostgreSQL within a Docker container, configuring pgAdmin 4 for database management, and importing data from `country.csv` into PostgreSQL using Docker and pgAdmin 4.

### Ingredients

1. **Software and Tools**
   - Docker Desktop
   - pgAdmin 4
   - PostgreSQL Docker image (`postgres:12.19-alpine3.20`)
   - pgAdmin Docker image (`dpage/pgadmin4:latest`)

2. **Data Files**
   - `country.csv`: Located at `/Users/mahesh/Documents/GitHub/EDA-and-Modelling-of-Retracted-Papers/data/raw/country.csv`

---

#### Setting Up PostgreSQL Container

 1.1. Open Docker Desktop
   - Navigate to the "Containers/Apps" section.

 1.2. Create a New Container
   - Click on "New Container" or "Create Container".

 1.3. Select the PostgreSQL Image
   - Choose `postgres:12.19-alpine3.20`.

 1.4. Configure the Container Settings
   - Container Name: `postgres-container`
   - Ports:
     - Host port: `5432`
     - Container port: `5432`
   - Volumes:
     - Host path: `/usr/local/var/postgres` (or preferred directory)
     - Container path: `/var/lib/postgresql/data`
   - Environment Variables:
     - `POSTGRES_PASSWORD`: `mysecretpassword`
     - `POSTGRES_DB` (optional): `yourdatabase`
   - Click "Create" or "Run".

---

#### Setting Up pgAdmin Container

# 2.1. Open Docker Desktop
   - Navigate to the "Containers/Apps" section.

# 2.2. Create a New Container
   - Click on "New Container" or "Create Container".

# 2.3. Select the pgAdmin Image
   - Choose `dpage/pgadmin4:latest`.

# 2.4. Configure the Container Settings
   - Container Name: `pgadmin-container`
   - Ports:
     - Host port for 80/tcp: `5050` (to access pgAdmin on http://localhost:5050)
     - Port Mapping: `5050:80`
     - Host port for 443/tcp: `0` (or leave it blank if not using HTTPS)
   - Environment Variables:
     - `PGADMIN_DEFAULT_EMAIL`: `admin@example.com`
     - `PGADMIN_DEFAULT_PASSWORD`: `admin`
   - Click "Create" or "Run".

---

#### Connecting pgAdmin to PostgreSQL

# 3.1. Open pgAdmin 4
   - Open your web browser and navigate to http://localhost:5050.

# 3.2. Create a New Server in pgAdmin 4
   - In the Object Browser on the left, right-click on "Servers" and select "Create" -> "Server...".

# 3.3. General Tab
   - Name: Enter `PostgreSQL Docker`.

# 3.4. Connection Tab
   - Host name/address: Enter `host.docker.internal`.
   - Port: Enter `5432`.
   - Maintenance database: Enter `yourdatabase`.
   - Username: Enter `postgres`.
   - Password: Enter `mysecretpassword`.
   - Click "Save".

---

#### Importing Data from `country.csv` into PostgreSQL

# 4.1. Prepare the CSV File
   - Ensure `country.csv` is located at `/Users/mahesh/Documents/GitHub/EDA-and-Modelling-of-Retracted-Papers/data/raw/country.csv`.

# 4.2. Copy File to Docker Container
   - Open a terminal and run:
     ```
     docker exec -it postgres-container mkdir -p /data
     docker cp /Users/mahesh/Documents/GitHub/EDA-and-Modelling-of-Retracted-Papers/data/raw/country.csv postgres-container:/data/country.csv
     ```

# 4.3. Create Table in pgAdmin 4
   - Open pgAdmin 4, navigate to your database, right-click, and select "Query Tool".
   - Run the following SQL command to create the table:
     ```sql
     CREATE TABLE country_frequency (
       country VARCHAR(255),
       frequency INTEGER
     );
     ```

# 4.4. Import CSV Data into PostgreSQL
   - In the Query Tool, run the following command to import the CSV file:
     ```sql
     COPY country_frequency (country, frequency)
     FROM '/data/country.csv'
     DELIMITER ','
     CSV HEADER;
     ```

---

### Conclusion

By following these steps, you should be able to successfully set up PostgreSQL within Docker, configure pgAdmin 4, and import `country.csv` data into your PostgreSQL database. Adjust paths and details as per your specific setup. If you encounter any issues or need further assistance, feel free to consult the respective documentation or ask for support.
