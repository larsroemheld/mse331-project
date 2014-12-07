import sys
import re
import os
import string





line_number = 0
user_id = ""
user_lines = 0
week_n = []
week_n1 = []
for line in sys.stdin:
    line_number += 1
    if line_number == 1:
        #ignore first line
        header = line.strip().split(',')
        #remove user_id, week_number_since_registration, user_registration, user_lifetime_editcount, week_number, user_registration_week
        header.pop(0)
        header.pop(0)
        header.pop(0)
        header.pop(0)
        header.pop(0)
        header.pop(2)
        
        #print header
        w1_features = ['n1_' + x for x in header]
        w2_features = ['n2_' + x for x in header]
        print(','.join(['user_id'] + ['edits'] + ['thanks'] +['user_age'] + w1_features + w2_features))
    else:
        #start capturing data
        week_n2 = week_n1
        week_n1 = week_n
        user_id_prev = user_id

        week_n = line.strip().split(',')
        user_id = week_n[0]
        user_age = week_n[1]
        edits = week_n[5]
        thanks = week_n[6]

        #get rid of user_id, week_num, reg_date, lifetime_edits
        week_n.pop(0)
        week_n.pop(0)
        week_n.pop(0)
        week_n.pop(0)
        week_n.pop(0)
        week_n.pop(2)
        #case 1. we are still dealing with the same user
        if user_id == user_id_prev:
            user_lines += 1
            #is this the third line (or later) of the user?
            if user_lines >= 2:
                #YES : output line
                observation = ','.join([user_id] + [edits] + [thanks] + [user_age] + week_n1 + week_n2)
                #user editsn thanksn -- weeks_since_reg editsn1 editsn2 thanksn1 thanksn2 sentimentn1 sentiment n2
                print(observation)
            #NO : store data and keep going
            #else:

        #case 2. we have a new user
        else :
            user_lines = 0
