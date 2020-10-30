import os
import csv
import re
from nltk.corpus import cmudict 

# input lyrics folder
path = input("Input path to folder with lyrics: ")

# load cmu phonetic dictionary
cmu = cmudict.dict()     

# used for words unknown to cmudict, but occur more than once in the song
cache_dict = dict()

func_words = []
singing_words = []
# load list of function words 
with open('one_syl_func_words.csv', newline='') as file:
    funcreader = csv.reader(file)
    for row in funcreader:
        func_words.append(''.join(row))

with open('singing_words.csv', newline='') as file:
    singreader = csv.reader(file)
    for row in singreader:
        singing_words.append(''.join(row))

func_words = [w.lower() for w in func_words]
singing_words = [w.lower() for w in singing_words]

# regex written by andrew lamont, from his ling509 class
def getStress(word):
    # function words are generally unstress in singing
    if word in func_words:
        return '0'
    # singing words / adlibs generally have no lexical information, given stress label of 3
    if word in singing_words:
        return '3'
    if word in cache_dict:
        return cache_dict[word]
    # else consult cmudict
    else:
        # try to find entry in cmu dict
        try:
            w = [''.join(x) for x in cmu[word]]
            stress = list(dict.fromkeys([re.sub('[^012]', '', x) for x in w]))
            # if there are multiple valid stress patterns, ask user for the correct one
            if len(stress) > 1:
                while(True):
                    print(stress)
                    index = int(input("Multiple stress patterns for \"{}\" found. Which is the correct stress? Give an index (starting from 0).\n".format(word)))

                    try:
                        stress = stress[index]
                        break
                    except IndexError:
                        print('Please try again. Give an index starting from 0.')
            # if there is only one stress pattern, use it
            else:
                stress = stress[0]
        # if the word is not in cmudict, ask the user to type in the word stress themselves
        except KeyError:
            print(word)
            stress = (input("No stress patterns for \"{}\" found. Please type the correct stress as an string with no spaces For example: \"coffee\" as \"10\". (0 is unstressed, 1 is primary stress, 2 is secondary stress, 3 is a singing syllable).\n".format(word)))
            cache_dict[word] = stress
        return stress

for filename in os.listdir(path):
    result = []
    with open(os.path.join(path, filename), 'r') as f:
        line = f.readline()
      
        while line:
            try:
                result.append(getStress(line.strip('\n ').lower()))
            except KeyError:
                result.append('!error!')

            line = f.readline()
    
    output = open(os.path.join(path,filename + "_stress.txt"), 'w')
    
    for l in result:
        output.write(l + "\n")