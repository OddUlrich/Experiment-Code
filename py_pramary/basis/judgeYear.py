#!/usr/bin/python2.7

class Date(object):
    """docstring for Date"""
    def __init__(self, year, month, day):
        super(Date, self).__init__()
        self.year = year
        self.month = month
        self.day = day

    def judge(self):
        if (self.year%100 == 0):
            if (self.year%400 == 0):
                return True
            else:
                return False
        elif (self.year%4 == 0):
            return True
        else:
            return False

    def printRet(self):
        print self.judge()        

today1 = Date(2000, 1, 2)
today2 = Date(2008, 3, 23)
today3 = Date(2013, 6, 12)
today4 = Date(2200, 4, 2)

today1.printRet()
today2.printRet()
today3.printRet()
today4.printRet()