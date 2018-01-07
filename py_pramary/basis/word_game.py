import os

# practice 1
def Print_Large20(fin):
    for line in fin:
        word = line.strip()
        if len(word) > 20:
            print word
    return

# practice 2
def has_no_e(word):
    if 'e' in word:
        return False
    else:
        print word
        return True

def calculate_rate_no_e(fin):
    fin.seek(0, os.SEEK_SET)
    total = 0
    num_no_e = 0
    for line in fin:
        total += 1
        word = line.strip()
        if has_no_e(word):
            num_no_e += 1
    print 'rate of no_e_word is %f' % (float(num_no_e) / total)

# practice 3
def avoids(word, avoid_str):
    if avoid_str in word:
        return False
    else:
        return True

def Print_no_avoid(fin):
    fin.seek(0, os.SEEK_SET)
    total = 0
    no_cnt = 0
    avoid_c = raw_input("Please input a character banned to use:")
    for line in fin:
        total += 1
        if avoids(line.strip(), avoid_c):
            no_cnt += 1
    print 'rate of no %c is : %d / %d = %f' % (avoid_c, no_cnt, total, no_cnt / float(total))

def Print_5_least_no_avoid(fin):
    fin.seek(o, os.SEEK_SET)
    total = 0
    no_cnt = 0
    keyList = []
    dic = {}
    key = map(chr, (97 : 122))
    for key in keyList:
        for line in fin:
            total += 1
            if avoids(line.strip(), key):
                no_cnt += 1
    #     dic = {key:no_cnt}
    # dic.sorted()
    return

# puzzle 1 : Search a three continuous-character word
def three_double_ch(fin):
    goal = []
    fin.seek(0, os.SEEK_SET)
    for line in fin:
        word = line.strip()
        size = len(word)
        for i in xrange(size-6):
            if word[i] == word[i+1] and word[i+2] == word[i+3] and word[i+4] == word[i+5]:
                goal.append(word)
                continue
    return goal

# puzzle 2 : Get my first data
def divide_num(num):
    singleNum = []
    for i in xrange(6):
        c = num % 10
        num = num / 10
        singleNum.append(c)
    return singleNum

def first_data():
    data = []
    for i in xrange(100000, 999997):
        x1 = divide_num(i)
        x2 = divide_num(i+1)
        x3 = divide_num(i+2)
        x4 = divide_num(i+3)
        if x1[0] == x1[3] and x1[1] == x1[2]:
            if x2[0] == x2[4] and x2[1] == x2[3]:
                if x3[1] == x3[4] and x3[2] == x3[3]:
                    if x4[0] == x4[5] and x4[1] == x4[4] and x4[2] == x4[3]:
                        data.append(i)
                        print i
                        continue
    return data


# set file point
fin = open('words.txt')

# practice 1
# Print_Large20(fin)

# practice 2
# calculate_rate_no_e(fin)

#  practice 3
# Print_no_avoid(fin)

# puzzle 1
# print three_double_ch(fin)
fin.close()

# puzzle 2
# print first_data()


