#!/usr/bin/env python
# Publish Arduino connected DHT11 sensors data to wia.io through Rapsberry Pi
# Author: Thomas Simon
# Date: 20190819


import serial
from wia import Wia
import simplejson as json
import os


wia = Wia()

__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))
token_file = open(os.path.join(__location__, 'token_file_2.json'));
d = json.loads(token_file.read())
wia.access_token = d["token"]

ser = serial.Serial('/dev/rfcomm0', 9600)

counter = 0
while counter < 1:
	ser.write("m")
	y = ser.readline().decode().strip()
	temp = (y.strip().replace(","," ")).split(' ')[0]
	hum = (y.strip().replace(","," ")).split(' ')[0-1]
	Temperature = str(temp)
	Humidity = str(hum)
	counter = counter+1

	wia.Event.publish(name="Temperature", data=Temperature)
	wia.Event.publish(name="Humidity", data=Humidity)

	ser.close()
