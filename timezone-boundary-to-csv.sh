#!/bin/bash
#A simple bash script that makes use of shp2pgsql and an existing postgresql database to convert files from https://github.com/evansiroky/timezone-boundary-builder

#Managin input
fileName=$1
outFileName=$2
dbName=$3

#Convert shapefile to psql dump
shp2pgsql $fileName public.timezone_polygons > temp_timezone_polygons.sql
#Load it
psql -d $dbName -f temp_timezone_polygons.sql
#Export it to CSV
psql -d $dbName -c "COPY (SELECT tzid as name, ST_AsText(geom) FROM public.timezone_polygons) TO STDOUT CSV" > $outFileName
#Drop whatever was created in your db
psql -d $dbName -c "DROP TABLE public.timezone_polygons"
#Pack it up
gzip $outFileName
