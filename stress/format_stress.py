# INPUT: stress notation file, with one words stress pattern per line
# a word like "coffee"'s line would look like 10
# breaks up multisyllable words and removes spaces so that each line contains only one syllable, 
# and there are two new lines inbetween vocal tracks
#
# written by judge russell, university of massachusetts amherst 8.14.2020

import os
import re

path = input("Input path to folder with lyrics: ")

for filename in os.listdir(path):
    result = []
    with open(os.path.join(path, filename), 'r') as f: # open in readonly mode
        lyrics = f.read()
        lyrics = re.split("\n\n", lyrics)
        try:
            lyrics.remove('')
        except:
            print('no extra spaces')

        for track in lyrics:
            t = ''.join(track.split())
            t = '\n'.join(t[i:i+1] for i in range(0, len(t)))
            result.append(t)


    output = open(os.path.join(path,filename + "_formatted.txt"), 'w')

    
    for l in result:
        output.write(l + "\n\n\n")