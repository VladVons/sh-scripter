#!/bin/bash

# sudo apt-get install postgresql-client

# pg_dump --dbname=postgresql://username:password@localhost:5432/mydatabase
#pg_dump --dbname=postgresql://postgres:19710819@192.168.2.115:5432/scraper1


Dump()
{
  aHost=$1; aDb=$2; aUser=$3;
  pg_dump --host=$aHost --dbname=$aDb --username=$aUser --password --verbose --format=custom --file ${aHost}_${aDb}.sql.dat
}

Restore()
{
  aHost=$1; aDb=$2; aUser=$3; aFile=$4;
  pg_restore --host=$aHost --dbname=$aDb --username=$aUser --password --verbose $aFile
}


#Dump 192.168.2.115 scraper1 postgres
#Restore localhost postgres postgres 192.168.2.115_scraper1.sql.dat


