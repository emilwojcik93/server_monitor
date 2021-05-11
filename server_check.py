#!/usr/bin/env python3

# service name (also used for logging purpose in journalctl)
import server_check
import sys
import os
import json
import re
import requests
import subprocess
import time
import logging
from systemd.journal import JournaldLogHandler

# get an instance of the logger object this module will use
logger = logging.getLogger(__name__)

# instantiate the JournaldLogHandler to hook into systemd
journald_handler = JournaldLogHandler()

# set a formatter to include the level name
journald_handler.setFormatter(logging.Formatter(
    '[%(levelname)s] %(message)s'
))

# add the journald handler to the current logger
logger.addHandler(journald_handler)

# optionally set the logging level
logger.setLevel(logging.DEBUG)

if len(sys.argv) < 3:
    print("Please declare username and password\nUsaga:\nserver_check.py <usename> <password>")
    exit(1)

def empty_downloads():
    username = sys.argv[1]
    password = sys.argv[2]

    session_req = requests.post('http://192.168.1.4:8080/api/v2/auth/login', data={"username": username, "password": password})
    session_cookie = re.findall(r"SID=(.*); Http", session_req.headers['set-cookie'])[0]

    status_req = requests.get('http://192.168.1.4:8080/api/v2/transfer/info', cookies = {"SID": session_cookie})
    current_speed = json.loads(status_req.text)['dl_info_speed']

    if current_speed == 0:
#            logger.info("Server dosn't download anything")
        ping_result = ['ping', '-c', '1', '8.8.8.8']

        return subprocess.call(ping_result, stdout=subprocess.DEVNULL) == 0
    else:
        return False

def samba_has_connected_clients():
    status_smb = ['smbstatus', '--locks']
    if len(subprocess.check_output(status_smb).decode('utf-8').split('\n')) > 3:
        return True 
    else:
#            logger.info("Samba has no clients")
        return False

def ssh_has_connected_clients():
    status_ssh = ['ss']
    if len(subprocess.check_output(status_ssh).decode('utf-8').split('\n')) == 0:
#            logger.info("SSH has no clients")
        return False
    else:
        return True

def server_is_busy():
    if empty_downloads() and not samba_has_connected_clients() and ssh_has_connected_clients():
        return False
#            logger.info("Server is idlee")
    else:
        return True
#            logger.info("Server is busy")

while True:
    if not server_is_busy():
        time.sleep(300)
        if not server_is_busy():
            logger.info("Hibernating")
            os.system("systemctl hibernate")
