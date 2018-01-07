#!/usr/bin/env python3

from socket import *
from time import ctime

# PORT can be changed as you need, but it should be notified to client.
HOST = ''
PORT = 21567
BUFSIZ = 1024
ADDR = (HOST, PORT)

tcpSvrSock = socket(AF_INET, SOCK_STREAM)
tcpSvrSock.bind(ADDR)
tcpSvrSock.listen(5)

while True:
	print("Waiting for connection...")
	tcpCliSock, addr = tcpSvrSock.accept()
	print("...connected from", addr)

	while True:
		data = tcpCliSock.recv(BUFSIZ)

		if not data:
			break
		data = data.decode('utf-8')
		respMsg = "[%s] %s" % (ctime(), data)
		tcpCliSock.send(bytes(respMsg, 'utf-8'))

	tcpCliSock.close()

tcpSvrSock.close()