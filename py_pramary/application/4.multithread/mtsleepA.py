#!/usr/bin/env python

import thread
from time import sleep, ctime

"""
	Run two loop with thread module. The total time is decided by the longest sleep time in function.
	max(2, 4, 6) = 6
	We use longer sleep time in main function to make sure that the process of loop function finished.

	Refferent function:	
		sleep(), ctime()
		start_new_thread(fun, (**argv))
"""

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
	thread.start_new_thread(loop0, ())
	thread.start_new_thread(loop1, ())
	sleep(6)
	print 'all done at:', ctime()

if __name__ == "__main__":
	main()
