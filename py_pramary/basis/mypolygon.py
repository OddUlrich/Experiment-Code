import turtle
import math

def square(t, length):
    # write a right angle
    t.fd(length)
    t.lt(90)
    t.fd(length)
    # continue to be a rectangle
    t.lt(90)
    t.fd(length)
    t.lt(90)
    t.fd(length)

    # an equal code
    for i in range(4):
        t.rt(90)
        t.fd(length)
    return

def polygon(t, length, n):
    angle = 360.0/n
    for i in range(n):
        t.fd(length)
        t.rt(angle)
    return

def circle(t, r):
    c = 2*math.pi*r
    n = 360
    polygon(t, c/n, n)
    return



bob = turtle.Turtle()   # create an object
print bob

# bob.fd(100)     # forward at 100 pixel
# bob.bk(50)      # backward at 50 pixel
# bob.lt(10)      # left turn in 10 degree
# bob.rt(100)     # right turn in 100 degree
# bob.pu()      # pen up
# bob.pd()      # pen down

# rectangle
length_rectangle = 100
square(bob, length_rectangle)

bob.pu()
bob.fd(100)
bob.pd()

# polygon
polygon(bob, 80, 8)

bob.pu()
bob.rt(90)
bob.fd(300)
bob.pd()

# circle
circle(bob, 100)

turtle.mainloop()   # tell the window to wait for control





