# MSSQL Docker Compose Setup (Optional Redis Support)

This repository provides a `docker-compose` configuration to set up and run a Microsoft SQL Server (MSSQL) instance, pre-configured to restore databases from backup files upon startup using a custom `entrypoint.sh` script. 

Additionally, Redis is included as an optional layer, which can easily be removed if not needed.

---

## Features

1. **MSSQL Server**:
   - Runs the official Microsoft SQL Server 2022 container image.
   - Automatically restores databases from the `backup` directory (if provided).
   - Configured to use a custom entrypoint script (`entrypoint.sh`) to handle database initialization and restoration.
   - Exposes ports `1433` (TCP) and `1434` (UDP) (default MSSQL ports).

2. **Redis**:
   - Runs the official Redis container image.
   - Configured to disable persistence (`--save "" --appendonly no`) for improved performance and simplicity.
   - Utilizes an in-memory data store with a `tmpfs` mount for `/data` (meaning data will be lost when the container stops).
   - Exposes port `6379` (default redis port).

---

## Usage

### 1. Setup Environment Variables
Create a `.env` file in the root directory of the repository and define the following variable:
```bash
MSSQL_SA_PASSWORD=YourStrongPasswordHere
```
- Replace `YourStrongPasswordHere` with a strong password for the MSSQL `SA` user.
- The password must meet MSSQL's complexity requirements (otherwise the container will fail to initialize).

---

### 2. Directory Structure
Ensure the following structure in your repository and place any database backup files in the `backup/` directory:
```
.
├── docker-compose.yaml
├── entrypoint.sh
├── backup/
│   ├── [your_database_backup_file1]
│   └── [your_database_backup_file2]
└── .env
```

---

### 3. Run the Services
Start the containers using Docker Compose:
```bash
docker-compose up -d
```

### 4. Accessing the Services
- **MSSQL Server**:
  - Host: `localhost`
  - Port: `1433` (default MSSQL port)
  - Credentials:
    - Username: `SA`
    - Password: The value of `MSSQL_SA_PASSWORD` in your `.env` file
- **Redis**:
  - Host: `localhost`
  - Port: `6379` (default Redis port)

---

## How the MSSQL Entrypoint Script Works

The `entrypoint.sh` script is executed when the MSSQL container starts. Here's what it does:
1. Starts the MSSQL server process in the background.
2. Waits for the SQL Server to become fully operational.
3. Iterates through all files in the `/var/opt/mssql/backup` directory (mapped from the `./backup` host directory).
4. For each backup file:
   - Checks if the corresponding database already exists.
   - If the database does not exist:
     - Determines the logical file names for the data and log files.
     - Restores the database to `/var/opt/mssql/data/` (default MSSQL data directory).
   - If the database exists, the restoration is skipped.
