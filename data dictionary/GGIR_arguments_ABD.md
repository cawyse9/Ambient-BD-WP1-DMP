# GGIR Parameters for Consideration in Ambient-BD  

####  mode  
which of the five parts need to be run.  Part 6 not run for now, wait for updates  

####  datadir  
This is a local drive – set to Ambient-BD FG local drive this is where to plant cwa file after download from axivity  

####  outputdir  
Local drive in same location as datadir  

####  studyname  
AmbientBD  
####  do.report  
c(2, 4, 5)  

####  overwrite   
Overwrite previous milestone data – change if re-running  
 
#### Includedaycrit  
Numeric (default = 16). Minimum required number of valid hours in calendar day specific to analysis in part 2.   
####  ndayswindow  
Numeric (default = 7). If data_masking_strategy is set to 3 or 5, then this is the size of the window as a number of days. For data_masking_strategy 3 value can be fractional, e.g. 7.5, while for data_masking_strategy 5 it needs to be an integer.  

####  data_masking_strategy  
Numeric (default = 1). How to deal with knowledge about study protocol. data_masking_strategy = 1 means select data based on hrs.del.start and hrs.del.end. data_masking_strategy = 2 makes that only the data between the first midnight and the last midnight is used. data_masking_strategy = 3 selects the most active X days in the file where X is specified by argument ndayswindow, where the days are a series of 24-h blocks starting any time in the day (X hours at the beginning and end of this period can be deleted with arguments hrs.del.start and hrs.del.end) data_masking_strategy = 4 to only use the data after the first midnight. data_masking_strategy = 5 is similar to data_masking_strategy = 3, but it selects X complete calendar days where X is specified by argument ndayswindow (X hours at the beginning and end of this period can be deleted with arguments hrs.del.start and hrs.del.end).  
#### do.imp  
Boolean (default = TRUE). Whether to impute missing values (e.g., suspected of monitor non-wear or clippling) or not by g.impute in GGIR g.part2.   
#### data_cleaning_file  
Character (default = NULL). Optional path to a csv file you create that holds four columns: ID, day_part5, relyonguider_part4, and night_part4. ID should hold the participant ID. Columns day_part5 and night_part4 allow you to specify which day(s) and night(s) need to be excluded from g.part5 and g.part4, respectively. When including multiple day(s)/night(s) create a new line for each day/night. So, this will be done regardless of whether the rest of GGIR thinks those day(s)/night(s) are valid. Column relyonguider_part4 allows you to specify for which nights g.part4 should fully rely on the guider.   
####  nonWearEdgeCorrection  
Boolean (default = TRUE). If TRUE then the non-wear detection around the edges of the recording (first and last 3 hours) are corrected following description in vanHees2013 as has been the default since then. This functionality is advisable when working with sleep clinic or exercise lab data typically lasting less than a day.    
####  segmentDAYSPTcrit.part5  
= c(0, 0.9)  
Numeric vector or length 2 (default = c(0.9, 0)). Inclusion criteria for the proportion of the segment that should be classified as day (awake) and spt (sleep period time) to be considered valid. If you are interested in comparing time spent in behaviour then it is better to set one of the two numbers to 0, and the other defines the proportion of the segment that should be classified as day or spt, respectively. The default setting would focus on waking hour segments and includes all segments that overlap for at least 90 percent with waking hours. In order to shift focus to the SPT you could use c(0, 0.9) which ensures that all segments that overlap for at least 90 percent with the SPT are included. Setting both to zero would be problematic when comparing time spent in behaviours between days or individuals: A complete segment would be averaged with an incomplete segments (someone going to bed or waking up in the middle of a segment) by which it is no longer clear whether the person is less active or sleeps more during that segment. Similarly it is not clear whether the person has more wakefulness during SPT for a segment or woke up or went to bed during the segment.  

#### def.noc.sleep  
Numeric (default = 1). The time window during which sustained inactivity will be assumed to represent sleep, e.g., def.noc.sleep = c(21, 9). This is only used if no sleep log entry is available. If left blank def.noc.sleep = c() then the 12 hour window centred at the least active 5 hours of the 24 hour period will be used instead. Here, L5 is hardcoded and will not change by changing argument winhr in function g.part2. If def.noc.sleep is filled with a single integer, e.g., def.noc.sleep=c(1) then the window will be detected with based on built in algorithms. See argument HASPT.algo from HASPT for specifying which of the algorithms to use.  
#### sleepefficiency.metric  

Numeric (default = 1). If 1 (default), sleep efficiency is calculated as detected sleep time during the SPT window divided by log-derived time in bed. If 2, sleep efficiency is calculated as detected sleep time during the SPT window divided by detected duration in sleep period time plus sleep latency (where sleep latency refers to the difference between time in bed and sleep onset). sleepefficiency.metric is only considered when argument sleepwindowType = “TimeInBed”  
#### possible_nap_edge_acc  
Numeric (default = Inf). Maximum acceleration before or after the SIB for the nap to be considered. By default this will allow all possible naps.  
####  Mvpathreshold  
= 0 we don’t want to look at PA in ambient-bd, but possibility remains since cwa is retained
mvpathreshold = c(), then MVPA is not estimated.  
####  qwindow  
Numeric or character (default = c(0, 24)). To specify windows over which all variables are calculated,   
####  cosinor  
Boolean (default = FALSE). Whether to apply the cosinor analysis from the ActCR package.
####  part6CR  
Boolean (default = FALSE) to indicate whether circadian rhythm analysis should be run by part 6 = FALSE) to indicate whether Household Co Analysis should be run by part 6.  

####  part6Window
Character vector with length two (default = c(“start”, “end”)) to indicate the start and the end of the time series to be used for circadian rhythm analysis in part 6. In other words, this parameters is not used for Household co-analysis. Alternative values are: “Wx”, “Ox”, “Hx”, where “x” is a number to indicat the xth wakeup, onset or hour of the recording. Negative values for “x” are also possible and will count relative to the end of the recording. For example, c(“W1”, “W-1”) goes from the first till the last wakeup, c(“H5”, “H-5”) ignores the first and last 5 hours, and c(“O2”, “W10”) goes from the second onset till the 10th wakeup time.  

####  epochvalues2csv  
= true  This will be at 5 sec epochs, non-wear time is imputed where possible.  

####  Timewindow  
= c(“MM”)  Character (default = c(“MM”, “WW”)). In g.part5: Timewindow over which summary statistics are derived. Value can be “MM” (midnight to midnight), “WW” (waking time to waking time), “OO” (sleep onset to sleep onset), or any combination of them.  
####  dofirstpage
Boolean (default = TRUE). To indicate whether a first page with histograms summarizing the whole measurement should be added in the file summary reports generated with visualreport = TRUE.  
####  visualreport  
Boolean (default = TRUE). useful for QC-ing the data   
Do.part3.pdf  
Boolean (default = TRUE). In g.part3: Whether to generate a pdf for g.part3.  

####  do.visual  
= FALSE we don’t have a sleeplog  



