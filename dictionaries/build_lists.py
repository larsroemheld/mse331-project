import sys
import re
import string

counter = 0

anger_words = open("nrc_anger_words.txt", "w")
anticipation_words = open("nrc_anticipation_words.txt", "w")
disgust_words = open("nrc_disgust_words.txt", "w")
fear_words = open("nrc_fear_words.txt", "w")
joy_words = open("nrc_joy_words.txt", "w")
negative_words = open("nrc_negative_words.txt", "w")
positive_words = open("nrc_positive_words.txt", "w")
sadness_words = open("nrc_sadness_words.txt", "w")
surprise_words = open("nrc_surprise_words.txt", "w")
trust_words = open("nrc_trust_words.txt", "w")

for line in sys.stdin:
    counter += 1

    #print(line)
    line = line.strip().split("\t")
    #print(line)
    word = line[0]
    num = line[2]
    #print(word + " -- " + num)
    if num == "1":
        #print(counter)
        if counter == 1:
            #print(word)
            print>>anger_words, word
        elif counter == 2:
            print>>anticipation_words, word
        elif counter == 3:
            print>>disgust_words, word
        elif counter == 4:
            print>>fear_words, word
        elif counter == 5:
            print>>joy_words, word
        elif counter == 6:
            print>>negative_words, word
        elif counter == 7:
            print>>positive_words, word
        elif counter == 8:
            print>>sadness_words, word
        elif counter == 9:
            print>>surprise_words, word
        elif counter == 10:
            print>>trust_words, word
 
    if counter == 10:
        counter = 0


