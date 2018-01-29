#!/usr/bin/env python3

from socket import *

# HOST and PORT can be changed as you need.
HOST = '127.0.0.1'
PORT = 21567
BUFSIZ = 1024
ADDR = (HOST, PORT)

tcpCliSock = socket(AF_INET, SOCK_STREAM)
tcpCliSock.connect(ADDR)

while True:
	data = input(">>> ")
	if not data:
		break

	tcpCliSock.send(bytes(data, 'utf-8'))
	data = tcpCliSock.recv(BUFSIZ)
	if not data:
		break

	print(data.decode('utf-8'))
tcpCliSock.close()

