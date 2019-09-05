#!/usr/bin/env python3
# import Arduino connected DHT11 sensors data in mongodb on Rapsberry Pi
# Author: Thomas Simon
# Date: 20190819

import pymongo
from pymongo import MongoClient
import serial
import string
import datetime


# Declare DB and Server
client = MongoClient("127.0.0.1", 27017)
db = client.sensorDB

# Collections in DB
sensor_data = db.sensor_data

# Configuration of USB serial connexion to Arduino
ser = serial.Serial(
        port='/dev/ttyUSB0',
        baudrate = 9600,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=1
)
# configuration of Bluetooth serial connexion to Arduino
#ser = serial.Serial('/dev/rfcomm0', 9600)
ser.flushInput()

while True:
    y = ser.readline().decode().strip()
    temp = (y.strip().replace(","," ")).split(' ')[0]
    hum = (y.strip().replace(","," ")).split(' ')[0-1]
    Temperature = str(temp)
    Humidity = str(hum)
    if Temperature != '' and Humidity != '':
            break
    else:
        continue

now = datetime.datetime.now()
dateInCollection = now.strftime("%Y-%m-%d %H:%M")

# Sensor IDs: Nano, Uno, NodeMCU, Pi
tempInCollection = {"Sensor_ID": "Nano", "Temperature": Temperature, "Datetime": dateInCollection}
humInCollection = {"Sensor_ID": "Nano", "Humidity": Humidity, "Datetime": dateInCollection}
temp_1 = sensor_data.insert_one(tempInCollection).inserted_id
hum_1 = sensor_data.insert_one(humInCollection).inserted_id
# End of program
ser.close()
client.close()
