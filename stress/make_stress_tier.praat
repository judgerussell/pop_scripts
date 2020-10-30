# this script will create stress tiers for an annotated song with vocal tracks
# these stress tiers mirror the vocal track tier, but do not copy over the start boundary of any non-labelled interval
# this is for the ease of putting in stress labels from a textfile, without worrying about pauses in singing
# (with the format of WHOLE NOTE TIER | SHEET MUSIC RHYTHM TRACKS | EXACT RHYTHM TRACKS | 1/4 | 1/8 | 1/16 | SONG SECTIONS )
# (if your file is not formatted like that, do not use this file! it will just mess your stuff up)
#
# by judge russell, university of massachusetts amherst 8.14.2020

form Select directory and file type
	sentence Directory D:\Classes\2020summer\research\top5past5\__test\
	sentence extension TextGrid
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
   # this number is for my files... the first tier is the measures, then the quantized vocals, then the exact vocals, then the timing grid, then the sections. that adds to vocal tracks * 2 + 5
    limit = (((numberOfTiers - 5) / 2) + 1)
    for tier from 2 to limit
        new_tier = tier + ((limit - 1) * 2)
        Insert interval tier: new_tier, "stress"
        # check how many intervals there are in the selected tier:
        numberOfIntervals = Get number of intervals... tier

        # loop through all the intervals
        for interval from 1 to numberOfIntervals
            label$ = Get label of interval... tier interval

            start = Get starting point... tier interval

            if label$ <> ""
                Insert boundary: new_tier, start
            endif
        endfor
    endfor
# Save modified text grid file
      Write to text file... 'directory$''short$'.TextGrid
#  endif   
# Clean up
  select all
  minus Strings list
  Remove
endfor

select Strings list
Remove