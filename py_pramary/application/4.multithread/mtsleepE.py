#!/usr/bin/env python

import threading
from time import sleep, ctime

"""
	Run loop function in threading module.
	We create a instance of a subclass: MyThread to make it more common.
	This way match the thought of OOP.
	The total time is decided by the longest time in loop function.
	max(4, 2) = 4
	
	Refferent function:	
		sleep(), ctime()
		threading.Thread.__init__(self)
		start()
		join()
"""

loops = [4, 2]

class MyThread(threading.Thread):
	def __init__(self, func, args, name=''):
		threading.Thread.__init__(self)
		self.name = name
		self.func = func
		self.args = args

	def run(self):
		self.func(*self.args)		

def loop(nloop, nsec):
	print 'start loop', nloop, 'at:', ctime()
	sleep(nsec)
	print 'done loop', nloop, 'at:', ctime()

def main():
	print 'all start at:', ctime()
	threads = []
	nloops = range(len(loops))

	for i in nloops:
		t = MyThread(loop, (i, loops[i]), loop.__name__)
		threads.append(t)

	for i in nloops:
		threads[i].start()

	for i in nloops:		
		threads[i].join()	# wait for all threads to finish

	print 'all done at:', ctime()

if __name__ == "__main__":
	main()
