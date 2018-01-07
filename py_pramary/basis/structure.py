import numpy as np

# Application for list
def nested_sum(t):
    sum = 0
    for i in xrange(len(t)):
        if isinstance(t[i], list):
            sum += nested_sum(t[i])
        else:
            sum += t[i]
    return sum

# t1 = [[1, 2], [3], [4, 5, 6]]
# print nested_sum(t1)

def cumsum(t):
    res = np.zeros(len(t))
    for i in xrange(len(t)):
        if i == 0:
            res[i] = t[i]
        else:
            res[i] = res[i-1] + t[i]
    return res

# t2 = range(10)
# print cumsum(t2)

def get_dict_with_str(str):
    dic = {}
    t = list(str)
    for i in t:
        if i in dic:
            dic[i] += 1
        else:
            dic[i] = 1
    print dic
    return dic

def is_anagram(str1, str2):
    if len(str1) != len(str2):
        return False

    flag = True
    dic1 = get_dict_with_str(str1)
    dic2 = get_dict_with_str(str2)

    for key, value in dic1.items():
        if key in dic2 and dic2[key] == value:
            continue
        else:
            flag = False
            break
    return flag

# str1 = 'aaaasdqwe'
# str2 = 'aqswadeaa'
# print is_anagram(str1, str2)