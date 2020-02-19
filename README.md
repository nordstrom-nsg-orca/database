Insert admin user, and data   
psql -v admin_password="'ASK_ADMIN_FOR_PASSWORD'" -h nsgclouddb.clqzasuuu8wm.us-west-2.rds.amazonaws.com --port 5432 -U nsg -W -f insert.sql -d nsgCloudDB    
