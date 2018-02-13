#!/usr/bin/env python

import threading
from time import ctime

"""
	Run loop function in threading module.
	We create a instance of a subclass: MyThread to make it more common.
	This way match the thought of OOP.
	The total time is decided by the longest time in loop function.
	max(4, 2) = 4
	
	Refferent function:	
		ctime()
		threading.Thread.__init__(self)
"""

class MyThread(threading.Thread):
	def __init__(self, func, args, name=''):
		threading.Thread.__init__(self)
		self.name = name
		self.func = func
		self.args = args

	def getResult(self):
		return self.res

	def run(self):
		print 'start', self.name, 'at:', ctime()
		self.res = self.func(*self.args)		
		print self.name, 'done at: ', ctime()


