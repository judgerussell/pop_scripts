# This script will calculate the durations of all labeled segments in a TextGrid object,
# as well as their start value in terms of measure, and their duration in terms of measure.
# The results will be save in a text file, each line containing the label text, the exact start time, 
# the measure start time, and the measure 
# duration of the corresponding segment..
# A TextGrid object needs to be selected in the Object list.
# The user must input which tier is being analyzed and which tier holds the measures.
#
# This script is distributed under the GNU General Public License.
# 8.6.2020 Judge Russell, based off of a script from 12.3.2002 by Mietta Lennes, and meant to model the .nlt files produced by Temperley in his RS200 dataset.
# User input: directory for files to be looped over
form Select directory and file type
	sentence Directory D:\Classes\2020summer\research\newest_text_grids\
	sentence Save_directory D:\Classes\2020summer\research\newest_text_grids\_durations\
        sentence Extension TextGrid

	comment Which tier holds the measure length?
	integer Measure 1
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
  
    # this calculation is specific, and made to be automatic. there's another file that can do this with selected tiers.
    # the issue is that different songs have different numbers of vocal tracks, so even with the same layout of tiers,
    # you can't just choose one range of numbers and expect it to work
    # so this will select all the metrically aligned vocal tiers given that there is a measure tier at tier 1, the metrically aligned vocal tracks after
    # and then after that, an exact tier and a stress tier track for each vocal track, and then the quarter, eighth, and sixteenth note grids
    numberOfTiers = Get number of tiers
    numberOfVocalTracks = (numberOfTiers - 5) / 3
    sequential_tier = 0
    for tier from 2 to (((numberOfTiers - 5) / 3) + 1)
        sequential_tier = sequential_tier + 1
        # check how many intervals there are in the selected tier:
        numberOfIntervals = Get number of intervals... tier
        current_measure = 2
        measurestart = Get starting point... measure current_measure
        measureend = Get end point... measure current_measure
        measureduration = measureend - measurestart

        # used to count the stress tier. since it has no end boundaries, only start ones, it doesn't exactly line up with the normal vocal track
        count = 2
        # loop through all the intervals
        for interval from 1 to numberOfIntervals
            
            label$ = Get label of interval... tier interval
            stress_tier = (tier + 2 * numberOfVocalTracks)
            start = Get starting point... tier interval
            end = Get end point... tier interval

            # if the start of the interval is greater than the end of the current measure, advance the current measure
            while measureend <= start
                current_measure = current_measure + 1
                measureend = Get end point... measure current_measure
            endwhile

            # calculate the start and duration of measure
            measurestart = Get starting point... measure current_measure
            measureduration = measureend - measurestart
            
            # if the interval has a label, calculate necessary info
            if label$ <> ""
                duration = end - start
                
                stress$ = Get label of interval... stress_tier count
                note_duration = (duration / measureduration)
                note_start = ((start - measurestart) / measureduration) + (current_measure - 1)
                note_duration = number(fixed$(note_duration, 3))
                note_start = number(fixed$(note_start, 3))
                
                # increment the count to advance the stress tier
                count = count +  1

                start = number(fixed$(start, 3)) 
                # append the label and the duration to the end of the text file, separated with a tab:		
                resultline$ = "'label$','stress$','start','note_start','note_duration','sequential_tier''newline$'"
                fileappend "'save_directory$''current$'.csv" 'resultline$'
            endif
        endfor
        fileappend "'save_directory$''current$'.csv" 'newline$'
    endfor
endfor