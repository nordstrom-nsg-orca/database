To migrate data from old database to new database, please create these files below:  
oldDB.pgpass -> `OLD_DB_ENDPOINT:PORT:DB_NAME:USER:PASSWORD`  
newDB.pgpass -> `NEW_DB_ENDPOINT:PORT:DB_NAME:USER:PASSWORD`  

Then:  
`chmod +x exportDB.sh`  
`./exportDB.sh`
