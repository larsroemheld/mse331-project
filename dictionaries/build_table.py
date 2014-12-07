import sys
import re
import string

counter = 0

for line in sys.stdin:
    counter += 1

    #print(line)
    line = line.strip().split("\t")
    #print(line)
    word = line[0]
    num = line[2]
    if counter == 10:
        print(out + "\t" + num)
        counter = 0
    elif counter == 1:
        out = word + "\t" + num
    else:
        out += "\t" + num
    #get word
    #if word is new, print line
