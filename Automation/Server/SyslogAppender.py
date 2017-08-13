"""

Maybe the worst script to append to syslog but you get the idea :P

I think using the rsyslog CLI will do the job better than this sh!t

"""

import os

path = "/var/log/"
file = "syslog"

while True:
    x = raw_input("Log => ")
    if x == "exit":
        print("Exited")
        break
    else:
        os.system("echo '" + str(x) + "' >> " + path + file)
    
