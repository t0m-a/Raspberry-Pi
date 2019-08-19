#!/usr/bin/env python
# Publish Arduino connected DHT11 sensors data to wia.io through Rapsberry Pi
# Author: Thomas Simon
# Date: 20190819

from wia import Wia
import serial
import string
import time
import simplejson as json
import os


# Messaging Service configuration with secret token file
wia = Wia()
__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))
token_file = open(os.path.join(__location__, 'token_file.json'));

d = json.loads(token_file.read())
wia.access_token = d["token"]

# Configuration of serial connexion to Arduino
ser = serial.Serial(
        port='/dev/ttyUSB0',
        baudrate = 9600,
        parity=serial.PARITY_NONE,
        stopbits=serial.STOPBITS_ONE,
        bytesize=serial.EIGHTBITS,
        timeout=1
)
ser.flushInput()

# The actual serial work retreiveing data only once for both temperature and humidity data
while True:
        # Previous Method to read and decode serial line, to be deleted when saved
        #ser_bytes = ser.readline()
        #decoded_bytes = str(ser_bytes[0:len(ser_bytes)-2].decode("utf-8"))
        y = ser.readline().decode().strip()
        temp = (y.strip().replace(","," ")).split(' ')[0]
        hum = (y.strip().replace(","," ")).split(' ')[0-1]
        Temperature = str(temp)
        Humidity = str(hum)
        if Temperature != '' and Humidity != '':
                break
        else:
            continue
time.sleep(5)
# Publishing data to the Broker in separate events
wia.Event.publish(name="Temperature", data=Temperature)
time.sleep(5)
wia.Event.publish(name="Humidity", data=Humidity)
# End of program
ser.close()

# To be removed when integrated in its own script, if usefull...
# Publishing device location only run once when needed if device is not on the go
#wia.Location.publish(latitude=-19.049674, longitude=-65.258902)

