#!/usr/bin/env python

import threading
from time import sleep, ctime

"""
	Run loop function in threading module.
	We create a Thread instance and pass it a function: loop.
	The total time is decided by the longest time in loop function.
	max(4, 2) = 4
	
	Refferent function:	
		sleep(), ctime()
		Thread(target=fun, args=(**argv))
		start()
		join()
"""

loops = [4, 2]

def loop(nloop, nsec):
	print 'start loop', nloop, 'at:', ctime()
	sleep(nsec)
	print 'done loop', nloop, 'at:', ctime()

def main():
	print 'all start at:', ctime()
	threads = []
	nloops = range(len(loops))

	for i in nloops:
		t = threading.Thread(target=loop, args=(i, loops[i]))
		threads.append(t)

	for i in nloops:
		threads[i].start()

	for i in nloops:		
		threads[i].join()	# wait for all threads to finish

	print 'all done at:', ctime()

if __name__ == "__main__":
	main()
