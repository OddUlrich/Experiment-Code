#!/usr/bin/python2.7

fp = open('record.txt', 'w+')

fp.write("tom, 34, 12")

fp.close()


fr = open('record.txt', 'r')
for line in fr.readlines():
    print line


fr.close()