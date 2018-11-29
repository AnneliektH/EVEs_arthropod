# Fokke Dekker, 2018

# To run this you will need an input file consisting only of one or more Blast trace-back operations strings

import re
import sys
import csv

# regexes to check for alpha or numeric characters
alpha_exp = re.compile(r'[A-Z]')
num_exp = re.compile(r'[0-9]')

# regexes to check for gaptypes
# Gap1 is subject gap
# Gap2 is query gap
gap1_exp= re.compile(r'[A-Z]-')
gap2_exp = re.compile(r'-[A-Z]')
mismatch = re.compile(r'[A-Z]{2}')

# number match for counting
numbers = re.compile(r'\d+')

# test string
string = '6TC2CG3T-2-G1GT3TC2T-A-C-CG5AT5CAGTCA14GA6'

def get_sub_string_score(sub_string):
    
    # get all associated scores
    numbers_value = sum([int(i) for i in re.findall(numbers, sub_string)])
    mismatch_value = len(re.findall(mismatch, sub_string))
    gap1_value = len(re.findall(gap1_exp, sub_string))
     
    # return total score
    return numbers_value + mismatch_value + gap1_value

def get_biggest_string(max_string, new_string, new_string_value):
    
    # return the largest of the two strings to compare
    if new_string_value > max_string[1]:
        return (new_string, new_string_value)
    else: return max_string

def get_sub_strings(string):
    
    max_string = ("test_string",0)
    
    # first string cuttoff point initiated
    skip = 0

    # var to save previous gap type
    prev_gap1 = False
    prev_gap2 = False

    # scan string until end is reached
    while len(string) > 0:

        # initiate number of mismatches to zero
        num_mismatch = 0

        # cut string from new start
        string = string[skip:]

        # if gap2 error found at beginning of string move to next character
        if re.match(gap2_exp,string[:2]):
            skip = 2
            continue

        # loop through the newly created string
        for i in range(len(string)):

            # if end of string is reached withouth other breaks check for highest string
            if i+1 == len(string):
                
                new_value = get_sub_string_score(string)
                max_string = get_biggest_string(max_string, string, new_value)

            # if not last character of string 
            if i < len(string):

                # create the string to check
                to_check = string[i:i+2]

                # check for gap type 1
                if re.match(gap1_exp, to_check):
                    prev_gap1 = True
                    prev_gap2 = False

                    # if gap1 at beginning of string continue and count as mismatch
                    if i == 0:
                        num_mismatch += 1
                        continue

                    # check if max num mismatch is reached
                    if num_mismatch == 2:
                        print string[:i]


                    # if not treat as terminal
                    else: 

                        # check if next item is also gap1 and there is room for another mismatch
                        if re.match(gap1_exp,string[i+2:i+4]) and num_mismatch !=1:
                            
                            # check for highest new string value
                            new_value = get_sub_string_score(string[:i+4])
                            max_string = get_biggest_string(max_string, string[:i+4], new_value)

                        # if not print string with just the single gap 1
                        else: 
                            new_value = get_sub_string_score(string[:i+2])
                            max_string = get_biggest_string(max_string, string[:i+2], new_value)

                    break

                # check for gap type 2
                if re.match(gap2_exp, to_check) and prev_gap1 == False:
                    prev_gap1 = False
                    prev_gap2 = True

                    # check for new highest string
                    new_value = get_sub_string_score(string[:i+2])
                    max_string = get_biggest_string(max_string, string[:i+2], new_value)
                    break

                # check for mismatch
                if re.match(mismatch, to_check):

                    prev_gap1 = False
                    prev_gap2 = False
                    num_mismatch += 1

                # check for numeric value 
                if re.match(num_exp, to_check[0]):
                    prev_gap1 = False
                    prev_gap2 = False

                if num_mismatch == 2:

                    # check if there are enough characters to check
                    if i+2 < len(string):

                        # if numbers follow max mismatch include them still
                        if re.match(num_exp, string[i+2]):
                            continue

                        # check for double mismatch at the end
                        if re.match(mismatch,string[i-1:i+1]) and re.match(mismatch,string[i:i+2]):
                            
                            # check for biggest new string value
                            new_value = get_sub_string_score(string[:i+3])
                            max_string = get_biggest_string(max_string, string[:i+3], new_value)
                            break

                        # if regular mismatch number reached print string and break
                        else:

                            # check for new max string
                            new_value = get_sub_string_score(string[:i+2])
                            max_string = get_biggest_string(max_string, string[:i+2], new_value)
                            break
                    else:
                        
                        # check for new max string
                        new_value = get_sub_string_score(string)
                        max_string = get_biggest_string(max_string, string, new_value)
                        break

        # get next string start point based on mismatches or size of numbers
        if len(string) > 0:
            if re.match(num_exp, string[0]):
                if len(string) > 3 and re.match(num_exp, string[1]) and re.match(num_exp, string[2]) and re.match(num_exp, string[3]):
                    skip = 4
                elif len(string) > 2 and re.match(num_exp, string[1]) and re.match(num_exp, string[2]):
                    skip = 3
                elif len(string) > 1 and re.match(num_exp, string[1]):
                    skip = 2
                else:
                    skip = 1
            else: skip = 2
                
    return max_string

f = open(sys.argv[1])

for line in f.readlines():
    line = line.strip(" ")
    print get_sub_strings(line)
