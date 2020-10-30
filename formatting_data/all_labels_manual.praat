# this script takes every label in a given set of tiers specified by a user and outputs it to a text file
# THE ONLY WAY TO MAKE THIS WORK is to EVENLY SPACE your tiers. give a beginning tier, an end tier, and the spacing in between them
#
# by judge russell, university of massachusetts amherst 10.30.2020

form Select file, save directory and file type
	sentence Target_file D:\Classes\2020summer\research\top5past5\
	sentence Save_directory D:\Classes\2020summer\research\top5past5\lyrics\
    sentence Output_name output
    positive Start_tier 1
    positive Number_of_tiers 1
    positive Spacing_interval 1
endform

# Set up file

Read from file... 'target_file$'
short$ = selected$ ("TextGrid")

tier = start_tier

for index from 0 to number_of_tiers
    # check how many intervals there are in the selected tier:
    numberOfIntervals = Get number of intervals... tier + index * spacing_interval

    # loop through all the intervals
    for interval from 1 to numberOfIntervals
        label$ = Get label of interval... tier interval
        # if the interval has some text as a label, then calculate the duration.
        
        if label$ <> ""	
            resultline$ = "'label$''newline$'"
            fileappend "'save_directory$''output_name$'.txt" 'resultline$'
        endif
    endfor
    fileappend "'save_directory$''output_name$'.txt" 'newline$' 'newline$'
endfor