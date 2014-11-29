import sys
import re
import os
import string
from collections import Counter as mset


def compute_score(dictionary, text):
    score = 0
    for w in dictionary:
        score += text.count(w)
    return score

def load_dictionary(file):
    return set(map(lambda x: x.strip(), open(file).read().splitlines()))


############## LIU DICTIONARY
liu_directory = "C:/Users/checo/Desktop/wiki/Liu lexicon/"
liu_positive_filename = liu_directory + "liu-positive-words.txt"
liu_negative_filename = liu_directory + "liu-negative-words.txt"
#positive_words = set(map(lambda x: x.strip(), open(pos_filename).read().splitlines()))
liu_positive_words = load_dictionary(liu_positive_filename)
liu_negative_words = load_dictionary(liu_negative_filename)
liu_positive_words.update("hi","hello")


############## NRC DICTIONARY
nrc_directory = "C:/Users/checo/Desktop/wiki/NRC-Emotion-Lexicon-v0.92/"

nrc_anger_filename        = nrc_directory + "nrc_anger_words.txt"
nrc_anticipation_filename = nrc_directory + "nrc_anticipation_words.txt"
nrc_disgust_filename      = nrc_directory + "nrc_disgust_words.txt"
nrc_fear_filename         = nrc_directory + "nrc_fear_words.txt"
nrc_joy_filename          = nrc_directory + "nrc_joy_words.txt"
nrc_negative_filename     = nrc_directory + "nrc_negative_words.txt"
nrc_positive_filename     = nrc_directory + "nrc_positive_words.txt"
nrc_sadness_filename      = nrc_directory + "nrc_sadness_words.txt"
nrc_surprise_filename     = nrc_directory + "nrc_surprise_words.txt"
nrc_trust_filename        = nrc_directory + "nrc_trust_words.txt"

nrc_anger_words        = load_dictionary(nrc_anger_filename)
nrc_anticipation_words = load_dictionary(nrc_anticipation_filename)
nrc_disgust_words      = load_dictionary(nrc_disgust_filename)
nrc_fear_words         = load_dictionary(nrc_fear_filename)
nrc_joy_words          = load_dictionary(nrc_joy_filename)
nrc_negative_words     = load_dictionary(nrc_negative_filename)
nrc_positive_words     = load_dictionary(nrc_positive_filename)
nrc_sadness_words      = load_dictionary(nrc_sadness_filename)
nrc_surprise_words     = load_dictionary(nrc_surprise_filename)
nrc_trust_words        = load_dictionary(nrc_trust_filename)

#nrc_filename = "C:/Users/checo/Desktop/wiki/NRC-Emotion-Lexicon-v0.92/table.txt"
#nrc_dict = open(nrc_filename).read().splitlines()
#for line in nrc_dict:
#    line = line.strip().split('\t')
#    word = line[0]
#    if line[1] == "1":
#        nrc_anger_words.append(word)
#    if line[2] == "1":
#        nrc_anticipation_words.append(word)
#    if line[3] == "1":
#        nrc_disgust_words.append(word)
#    if line[4] == "1":
#        nrc_fear_words.append(word)
#    if line[5] == "1":
#        nrc_joy_words.append(word)
#    if line[6] == "1":
#        nrc_negative_words.append(word)
#    if line[7] == "1":
#        nrc_positive_words.append(word)
#    if line[8] == "1":
#        nrc_sadness_words.append(word)
#    if line[9] == "1":
#        nrc_surprise_words.append(word)
#    if line[10] == "1":
#        nrc_trust_words.append(word)
#

#count how many of the positive words appear in a string
#positive_score = lambda l: len(liu_positive_words.intersection(l))
#negative_score = lambda l: len(liu_negative_words.intersection(l))

#ps = lambda l : len(list((mset(negative_words) & mset(l)).elements()))

exclude = set(string.punctuation)
table = string.maketrans("","")

print("user_to\tuser_from\tcomment_year\tcomment_month\tcomment_day\tword_count\tliu_positive_score\tliu_negative_score\tnrc_anger_score\tnrc_anticipation_score\tnrc_disgust_score\tnrc_fear_score\tnrc_joy_score\tnrc_negative_score\tnrc_positive_score\tnrc_sadness_score\tnrc_surprise_score\tnrc_trust_score")

#read file
#for each line
for line in sys.stdin:
    comment = line.strip().split('\t')
    user_to = comment[0]
    user_from = comment[1]
    timestamp = comment[2]
    comment_year = timestamp[0:4]
    comment_month = timestamp[5:7]
    comment_day = timestamp[8:10]
    #subject = comment[3]

    #get fifth column (tab separated)
    if len(comment) >= 5:
        comment = comment[4]
        #remove punctuation and make lowercase
        comment = comment.translate(table, string.punctuation).lower()
        comment_str = comment
        #break comment into a list
        comment = comment.split()
        word_count = len(comment)
       
        #compute score
        #neg = negative_score(comment)
        #pos = positive_score(comment)

        liu_positive_score = compute_score(liu_positive_words,comment)
        liu_negative_score = compute_score(liu_negative_words,comment)

        nrc_anger_score        = compute_score(nrc_anger_words, comment)
        nrc_anticipation_score = compute_score(nrc_anticipation_words, comment)
        nrc_disgust_score      = compute_score(nrc_disgust_words, comment)
        nrc_fear_score         = compute_score(nrc_fear_words, comment)
        nrc_joy_score          = compute_score(nrc_joy_words, comment)
        nrc_negative_score     = compute_score(nrc_negative_words, comment)
        nrc_positive_score     = compute_score(nrc_positive_words, comment)
        nrc_sadness_score      = compute_score(nrc_sadness_words, comment)
        nrc_surprise_score     = compute_score(nrc_surprise_words, comment)
        nrc_trust_score        = compute_score(nrc_trust_words, comment)

        #for w in positive_words:
        #    pos2 += comment.count(w)
        #neg2 = compute_socre
        #for w in negative_words:
        #    neg2 += comment.count(w)

        #nrc_neg = 0
        #for w in nrc_negative_words:
        #    nrc_neg += comment.count(w)

        word_count = str(word_count)

        liu_positive_score = str(liu_positive_score)
        liu_negative_score = str(liu_negative_score)

        nrc_anger_score        = str(nrc_anger_score)
        nrc_anticipation_score = str(nrc_anticipation_score)
        nrc_disgust_score      = str(nrc_disgust_score)
        nrc_fear_score         = str(nrc_fear_score)
        nrc_joy_score          = str(nrc_joy_score)
        nrc_negative_score     = str(nrc_negative_score)
        nrc_positive_score     = str(nrc_positive_score)
        nrc_sadness_score      = str(nrc_sadness_score)
        nrc_surprise_score     = str(nrc_surprise_score)
        nrc_trust_score        = str(nrc_trust_score)


        #write scores
        #print(comment_str + '\t' + str(pos) + '\t' + str(pos2) + '\t'+ str(neg) + '\t'+ str(neg2) + '\t'+ str(nrc_neg) + '\t' + str(count))
        print(user_to+'\t'+user_from+'\t'+comment_year+'\t'+comment_month+'\t'+comment_day+'\t'+word_count+'\t'+liu_positive_score+'\t'+liu_negative_score+'\t'+nrc_anger_score+'\t'+nrc_anticipation_score+'\t'+nrc_disgust_score+'\t'+nrc_fear_score+'\t'+nrc_joy_score+'\t'+nrc_negative_score+'\t'+nrc_positive_score+'\t'+nrc_sadness_score+'\t'+nrc_surprise_score+'\t'+nrc_trust_score)





