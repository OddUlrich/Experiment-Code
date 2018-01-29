#!/usr/bin/env python3

from socket import *
from time import ctime

# PORT can be changed as you need, but it should be notified to client.
HOST = '127.0.0.1'
PORT = 21567
BUFSIZ = 1024
ADDR = (HOST, PORT)

udpSvrSock = socket(AF_INET, SOCK_DGRAM)
udpSvrSock.bind(ADDR)

while True:
	print("Waiting for message..")
	data, addr = udpSvrSock.recvfrom(BUFSIZ)
	data = data.decode('utf-8')
	respMsg = "[%s] %s" % (ctime(), data)
	udpSvrSock.sendto(bytes(respMsg, 'utf-8'), addr)

	print("...received from and return to: ", addr)

udpSvrSock.close()