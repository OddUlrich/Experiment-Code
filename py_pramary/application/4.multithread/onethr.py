#!/usr/bin/env python

"""
	Run the two loop function in order. 
	(4+2=6)
	
	Refferent function:	
		sleep(), ctime()
"""
from time import sleep, ctime

def loop0():
	print 'start loop 0 at:', ctime()
	sleep(4)
	print 'done loop 0 at:', ctime()

def loop1():
	print 'start loop 1 at:', ctime()
	sleep(2)
	print 'done loop 1 at:', ctime()

def main():
	print 'all start at:', ctime()
	loop0()
	loop1()
	print 'all done at:', ctime()

if __name__ == "__main__":
	main()
