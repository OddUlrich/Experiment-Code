#!/usr/bin/env python

import thread
from time import sleep, ctime

"""
	Run loop function in threads that are set before starting.
	When all the loop finished in our check loop, the function is over.
	The total time is decided by the longest time in loop function.
	max(4, 2) = 4
	
	Refferent function:	
		sleep(), ctime()
		allocate_lock(),
		acquire(),
		start_new_thread(fun, (**argv))
		release()
		locked()
		
"""

loops = [4, 2]

def loop(nloop, nsec, lock):
	print 'start loop', nloop, 'at:', ctime()
	sleep(nsec)
	print 'done loop', nloop, 'at:', ctime()
	lock.release()	# release the thread lock after loop function.

def main():
	print 'all start at:', ctime()
	locks = []
	nloops = range(len(loops))

	for i in nloops:
		lock = thread.allocate_lock()
		lock.acquire()
		locks.append(lock)

	for i in nloops:
		thread.start_new_thread(loop, (i, loops[i], locks[i]))

	for i in nloops:
		while locks[i].locked():
			pass

	print 'all done at:', ctime()

if __name__ == "__main__":
	main()
