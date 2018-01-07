# input two number to calculate their gcd
promp1 = 'Please input the first number:'
promp2 = 'Please input the second number:'
a = raw_input(promp1)
b = raw_input(promp2)

a = int(a)
b = int(b)

def gcd(a, b):
    if a >= b:
        big = a
        small = b
    else:
        big = b
        small = a


    r = big % small
    if r != 0:
        gcd(small, r)
    # basic condition
    else:   # r == 0
        print 'the GCD is %d' % small
    return

gcd(a,b)