#!/usr/bin/env python3

from socket import *

# HOST and PORT can be changed as you need.
HOST = '127.0.0.1'
PORT = 21567
BUFSIZ = 1024
ADDR = (HOST, PORT)

udpCliSock = socket(AF_INET, SOCK_DGRAM)

while True:
	data = input(">>> ")
	if not data:
		break

	udpCliSock.sendto(bytes(data, 'utf-8'), ADDR)
	data, ADDR = udpCliSock.recvfrom(BUFSIZ)
	if not data:
		break

	data = data.decode('utf-8')
	print(data)

udpCliSock.close()