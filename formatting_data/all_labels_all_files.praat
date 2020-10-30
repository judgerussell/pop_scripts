# this script takes every label in a range of tiers for an annotated song and outputs it to a text file, separated by tier
# (with the format of WHOLE NOTE TIER | SHEET MUSIC RHYTHM TRACKS | EXACT RHYTHM TRACKS | 1/4 | 1/8 | 1/16 | SONG SECTIONS )
# (if your file is not formatted like that, do not use this file! it will just mess your stuff up, use the all_labels_manual script.)
#
# by judge russell, university of massachusetts amherst 8.14.2020

form Select directory and file type
	sentence Directory D:\Classes\2020summer\research\top5past5\
	sentence Save_directory D:\Classes\2020summer\research\top5past5\lyrics\
        sentence Extension TextGrid
endform

# Set up file list to be looped over
Create Strings as file list... list 'directory$'*.'extension$'
number_of_files = Get number of strings

# Loop over files to create text grids with labeled voiced/unvoiced intervals
for i_file to number_of_files
  select Strings list
  current$ = Get string... i_file
  Read from file... 'directory$''current$'
  short$ = selected$ ("TextGrid")
  

    numberOfTiers = Get number of tiers
   
    for tier from 2 to (((numberOfTiers - 5) / 2) + 2)
        # check how many intervals there are in the selected tier:
        numberOfIntervals = Get number of intervals... tier

        # loop through all the intervals
        for interval from 1 to numberOfIntervals
            label$ = Get label of interval... tier interval
            # if the interval has some text as a label, then calculate the duration.
            
            if label$ <> ""	
                resultline$ = "'label$''newline$'"
                fileappend "'save_directory$''current$'.txt" 'resultline$'
            endif
        endfor
        fileappend "'save_directory$''current$'.txt" 'newline$' 'newline$'
    endfor
endfor