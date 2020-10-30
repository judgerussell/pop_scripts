#### GRIDICIZE_MUSIC.PRAAT
#### Time-stamp: <2017-04-06 13:12:50 amoebe>
#### AUTHOR: Kristine Yu <krisyu@linguist.umass.edu>
#### PURPOSE: This adds a second and third tier to a TextGrid dividing up intervals annotated in the first tier into fourths and eighths, respectively, for every file in a directory
#### INPUT: Directory of sound files and accompanying TextGrids (with same base file name), which have been annotated to mark measures as intervals (sound files aren't actually needed, just the TextGrid files)
#### OUTPUT: Overwrites original TextGrids with new TextGrid, with the additional second and third tier and saves to specified Save_directory
#### NOTE: If you have some intervals you don't want to have sub-divided, just mark those with the label xxx in your first tier. Known bug: this must be done for the inteval that starts at zero.

## This script loops over specified files in a directory and creates textgrids with voiced and unvoiced intervals labeled.

# User input: directory for files to be looped over
form Select directory and file type
	sentence Directory D:\Classes\2020summer\research\
	sentence Save_directory D:\Classes\2020summer\research\
	boolean Exclude_intervals_labeled_as_xxx 1
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
  
   # Duplicate tier one to tier 2
  select TextGrid 'short$'
  Insert interval tier: 2, "2"
  Insert interval tier: 3, "3"
  Insert interval tier: 4, "4"

   number_of_intervals = Get number of intervals... 1
  
   for b from 1 to number_of_intervals
   interval_label$ = Get label of interval... 1 'b'
      if interval_label$ <> "xxx"
         begin_measure = Get starting point: 1, 'b'
         echo 'begin_measure'
         end_measure = Get end point: 1, 'b'
         echo 'end_measure'
         duration_s = (end_measure - begin_measure)
         Insert boundary: 2, begin_measure
         Insert boundary: 2, begin_measure + duration_s/4
         Insert boundary: 2, begin_measure + 2 * duration_s/4
         Insert boundary: 2, begin_measure + 3 * duration_s/4
         Insert boundary: 3, begin_measure
         Insert boundary: 3, begin_measure + duration_s/8
         Insert boundary: 3, begin_measure + 2 * duration_s/8
         Insert boundary: 3, begin_measure + 3 * duration_s/8
         Insert boundary: 3, begin_measure + 4 * duration_s/8
         Insert boundary: 3, begin_measure + 5 * duration_s/8
         Insert boundary: 3, begin_measure + 6 * duration_s/8
         Insert boundary: 3, begin_measure + 7 * duration_s/8
         Insert boundary: 4, begin_measure 
         Insert boundary: 4, begin_measure + duration_s/16
         Insert boundary: 4, begin_measure + 2 * duration_s/16
         Insert boundary: 4, begin_measure + 3 * duration_s/16
         Insert boundary: 4, begin_measure + 4 * duration_s/16
         Insert boundary: 4, begin_measure + 5 * duration_s/16
         Insert boundary: 4, begin_measure + 6 * duration_s/16
         Insert boundary: 4, begin_measure + 7 * duration_s/16
         Insert boundary: 4, begin_measure + 8 * duration_s/16
         Insert boundary: 4, begin_measure + 9 * duration_s/16
         Insert boundary: 4, begin_measure + 10 * duration_s/16
         Insert boundary: 4, begin_measure + 11 * duration_s/16
         Insert boundary: 4, begin_measure + 12 * duration_s/16
         Insert boundary: 4, begin_measure + 13 * duration_s/16
         Insert boundary: 4, begin_measure + 14 * duration_s/16
         Insert boundary: 4, begin_measure + 15 * duration_s/16
         endif
      endif
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
#clearinfo
echo Yay! gridicize_music.praat done. 'number_of_files' were gridicized in 'directory$' 'extension$'.
