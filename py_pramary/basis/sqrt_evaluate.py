import math
# calculate function


def mysqrt(a):
    x = 7.0
    acc = 1.0e-8

    while True:
        y = (x + a / x) / 2
        if abs(y - x) < acc:
            break;
        else:
            x = y
    return y

def test_squre_root():
    print "a \t mysqrt(a) \t math.sqrt(a) \t diff"
    print "- \t --------- \t ------------ \t ----"
    for i in xrange(1, 100, 5):
        print '%2.1f \t%f\t%f\t\t%f' % (i, mysqrt(i), math.sqrt(i), abs(mysqrt(i) - math.sqrt(i)))

    return

test_squre_root()