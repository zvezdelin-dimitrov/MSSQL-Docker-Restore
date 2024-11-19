FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y

COPY --chmod=755 entrypoint.sh /usr/src/app/entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
