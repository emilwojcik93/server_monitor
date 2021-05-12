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
        ping_result = ['ping', '-c', '1', '8.8.8.8']

        return subprocess.call(ping_result, stdout=subprocess.DEVNULL) == 0
    else:
        return False

def samba_has_connected_clients():
    status_smb = ['smbstatus', '--locks']
    if len(subprocess.check_output(status_smb).decode('utf-8').split('\n')) > 3:
        return True 
    else:
        return False

def ssh_has_connected_clients():
    cmd = "ss | grep -i ssh"
    status_ssh = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    if len(status_ssh.communicate()[0]) == 0:
        return False
    else:
        return True

def server_is_busy():
    if empty_downloads() and not samba_has_connected_clients() and not ssh_has_connected_clients():
        return False
    else:
        return True

while True:
    if not server_is_busy():
        time.sleep(300)
        if not server_is_busy():
            os.system("systemctl hibernate")
