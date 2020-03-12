# Introduction

A different approach to tracking aircraft using Docker with your Raspberry Pi and a USB TV stick.  Instead of installing everything by hand in a single environment we will be using separate docker containers for each feeder instance.

Inspired by great work from the following people:
* Alex Ellis' blog post: [Get eyes in the sky with your Raspberry Pi](https://blog.alexellis.io/track-flights-with-rpi/)
* [Alex Ellis' original github project](https://github.com/alexellis/eyes-in-the-sky)
* [LoungeFlyZ enhanced github project which added the FlightRadar24 feed](https://github.com/LoungeFlyZ/eyes-in-the-sky)


We will start from a bare-bone Raspberry Pi installation but you can skip the initial parts if you already have an existing setup that you want to adapt.



# Initial Raspberry Pi setup

The following steps are performed on a MacBook - the steps might be slightly difference if you use a PC (Windows or Linux). I assume you are able to translate this accordingly.


1. Download the latest Raspbian Lite image  [https://www.raspberrypi.org/downloads/raspbian](https://www.raspberrypi.org/downloads/raspbian)

2. Burn the image on a micro SD card, you will need a SD card of at least 16 GB.

3. Connect the micro SD card to your Mac/PC

    The SD card will be visible as a volume called `boot` - this is the FAT32 partition on the SD card.  There is also a hidden Linux ext4 partition on the SD card.

4. Enable SSH

    Add an empty `ssh` file on the boot partition to enable SSH:

    ```
    $ touch /Volumes/boot/ssh
    ```

5. Enable WiFi connection (Optional)

    I prefer to use the Ethernet connection but if you would like to use WiFi to connect your Raspberry Pi to your local network then you need to add a new file `wpa_supplicant.conf` on the boot partition (I use vim in the example below, you can use your favourite text editor):

    ```
    $ touch /Volumes/boot/wpa_supplicant.conf
    $ vim /Volumes/boot/wpa_supplicant.conf
    ```

    Add the following content to the `wpa_supplicant.conf` file:

    ```
    country=be
    update_config=1
    ctrl_interface=/var/run/wpa_supplicant GROUP=netdev

    network={
        ssid="your SSID"
        scan_ssid=1
        psk="your password"
        key_mgmt=WPA-PSK
    }
    ```

6. Connect and start Raspberry Pi.

    Connect the network cable (if applicable) and the power cable.  DO NOT connect the DVB-T receiver at this time!

7. connect to the raspberry Pi using SSH:

    ```
    $ ssh pi@raspberrypi.local
    ```

    Or replace `raspberrypi.local` by the IP address of the Raspberry Pi if you are able to find out the IP address.

8. Change default password

    ```
    $ passwd
    ```

9. Update Raspbian

    ```
    $ sudo apt-get update -y
    $ sudo apt-get upgrade -y
    ```


# Fixed IP address configuration

This configuration is optional unless you want to easily connect to your Raspberry Pi by always using the same IP address.  Depending on your local setup - add the confguration part from the Ethernet or the WiFi setup below to the file `/etc/dhcpcd.conf`.

    ```
    $ vi /etc/dhcpcd.conf
    ```


## Ethernet cable connection (preferred)

    ```
    interface eth0 
    static ip_address=192.168.0.212/24
    static routers=192.168.0.1
    static domain_name_servers=8.8.8.8
    ```


## WiFi connection

    ```
    interface wlan0 
    static ip_address=192.168.0.212/24
    static routers=192.168.0.1
    static domain_name_servers=8.8.8.8
    ```


# Prepare Raspberry Pi for a DVB-T receiver

blacklist your DVB-T receiver to avoid the loading of the default driver:

```
$ sudo sh -c "echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/blacklist-dvbt.conf"
```

If this is not done correctly, DUMP1090 will give the following error when starting: Error opening the RTLSDR device: Device or resource busy

At this point reboot your Raspberry Pi (disconnect the power and connect again) and connect your DVB-T receiver.

    ```
    $ sudo reboot
    ```

Connect again to your Raspberry Pi using SSH:

    ```
    $ ssh pi@raspberrypi.local
    ```


# Install Docker

1. install Docker on your raspberry pi:

    ```
    $ curl -sSL https://get.docker.com | sh
    ```

2. Optionally (security risk!) if you would like to run docker commands without using sudo:

    ```
    $ sudo usermod -a -G docker pi
    ```

3. Install docker-compose and git:

    ```
    $ sudo apt-get -y install git python python-pip libffi-dev python-backports.ssl-match-hostname
    $ sudo pip install docker-compose
    ```

4. Reboot

    To finalize reboot your Raspberry Pi and connect again using SSH

    ```
    $ sudo reboot
    ```


# Setup Docker ADS-B environment

1. Clone this GIT repository on your raspberry pi:

    ```
    $ git clone https://github.com/filipjonckers/eyes-in-the-sky
    $ cd eyes-in-the-sky
    ```

2. Edit docker-compose.yml if required (Optional)

    ```
    $ cp docker-compose.yml.template docker-compose.yml
    $ nano docker-compose.yml
    ```


## Configure dump1090

Create a copy of the example file and set your latitude and longitude in `dump1090fa.conf`:

```
$ cp dump1090fa/dump1090fa.conf.example dump1090fa/dump1090fa.conf
$ vi dump1090fa/dump1090fa.conf
```

Example `dump1090fa.conf`:

```
DUMP_LAT=51.0
DUMP_LON=4.0
```


## Configure Flightradar24 feeder

Create a copy of the example file and set your FR24 key in `fr24feed.ini`:

```
$ cp fr24/fr24feed.ini.example fr24/fr24feed.ini
$ vi fr24/fr24feed.ini
```

Example `fr24feed.ini`:

```
receiver="avr-tcp"
host="dump1090fa:30002"
fr24key="XXXXXXXXXXXXXXXXX"
bs="no"
raw="no"
logmode="2"
windowmode="0"
logpath="/var/log"
mlat="yes"
mlat-without-gps="yes"
gt="60"
```


## Configure Flightaware feeder

Create a copy of the example file and set your FlightAware key in `piaware.conf`:

```
$ cp flightaware/piaware.conf.example flightaware/piaware.conf
$ vi flightaware/piaware.conf
```

Example `piaware.conf`:

```
receiver-type other
receiver-host dump1090fa
receiver-port 30005
feeder-id XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
mlat-results yes
mlat-results-anon yes
allow-modeac yes
mlat-results-format beast,connect,dump1090fa:30104
```


## Configure Adsbexchange feeder

Nothing to be done.


# Start the docker containers

1. docker-compose up

    ```
    $ docker-compose up -d
    ```
    
2. browse to your raspberry pi's ip address on port 8080
 
    [http://raspberrypi.local:8080](http:///raspberrypi.local:8080) _(replace with your ip address)_
    
    You should now see dump1090's web interface.


# Getting your feeder id

## Getting your feeder id -- FlightAware.com

Log into your FlightAware account and find your new feeder on the "My ADS-B" page. Every time a new feeder is detected FlightAware assigns a unique identifier (guid) to it. To ensure your piaware container is not seen as a new feeder each time it is restarted you need to get the "unique identifier" from your My ADS-B stats page and set it in the `piaware.conf` file.


## Getting your feeder key -- FlightRadar24.com

Before you can feed FlightRadar24.com you need to create an account on their website. Then you need to run the container with a signup command to register and generate your key.

If you dont want to feed FlightRadar24.com comment out the flightradar service in the docker-compose.yml


    ```
    $ docker run --rm -it loungefly/raspbian-flightradar24 /usr/bin/fr24feed --signup
    ```

1. Enter your accounts email address
2. Leave blank
3. yes
4. Enter your latitude
5. Enter your longitude
6. Enter your altitude in feet
7. Enter 'yes' to confirm

You should be given a key that you can copy and enter into `fr24feed.ini` file.



# Troubleshooting

- Check the logs for the FlightRadar24 container

    ```
    $ docker logs fr24
    ```

- Check the logs for the ADS-B Exchange container

    ```
    $ docker logs adsbexchange
    ```
    
- Check the logs for the piaware container

    ```
    $ docker logs piaware
    ```
    
- Check the logs for the dump1090 container

    ```
    $ docker logs dump1090fa
    ```
