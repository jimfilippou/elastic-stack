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
    
