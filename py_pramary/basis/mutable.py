#!/usr/bin/python2.7

def numfunc(x):
    x = x + 1
    print x

def strfunc(x):
    x = 'asd'
    print x

def listfunc(l):
    l[0] = 10
    print l


a = 2
strin = 'qwe'
nl = [1,2,3]
dicr = {'0':2, '1':12}

print a
numfunc(a)
print a
print strin
strfunc(strin)
print strin
print nl
listfunc(nl)
print nl
print dicr
listfunc(dicr)
print dicr
    
