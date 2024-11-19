# MSSQL-Docker-Restore

This project provides a simple script to restore one or more MS SQL Server database backups in a clean Docker container. When running the container, you must specify the SA password and the location of the backup files.

## Building the Docker Image

To build the Docker image, run the following command:

```bash
docker build --rm --tag db .
```

- `--rm` removes intermediate containers after a successful build, reducing clutter.
- `--tag db` names the Docker image as `db`.

## Running the Docker Container

To run the Docker container with your specified backup directory and SA password, use the following command:

```bash
docker run -p 1433:1433 -p 1434:1434/udp -e MSSQL_SA_PASSWORD=REPLACE_WITH_PASSWORD -v "REPLACE_WITH_FULL_PATH_TO_BACKUP_DIRECTORY:/var/opt/mssql/backup" --name db db
```

- **Ports**: `-p 1433:1433` maps the default SQL Server port for TCP connections, and `-p 1434:1434/udp` maps the port for SQL Server Browser service.
- **Environment Variable**: `-e MSSQL_SA_PASSWORD=REPLACE_WITH_PASSWORD` sets the SA password. Replace `REPLACE_WITH_PASSWORD` with a strong password.
- **Volume**: `-v "REPLACE_WITH_FULL_PATH_TO_BACKUP_DIRECTORY:/var/opt/mssql/backup"` mounts your host's backup directory to the container. Replace `REPLACE_WITH_FULL_PATH_TO_BACKUP_DIRECTORY` with the full path to your backup directory.
- **Container Name**: `--name db` sets the name of the running container as `db`.
- **Image Name**: `db` is the name of the Docker image to run.