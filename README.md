<div align="center">
	<img src="./images/Questionnaire_header.svg", width=150%>
</div>  

<br>  
<br> 

	
# Work Package 1 - Data Management Plan  
<br>  
<br>  


Bipolar disorder is defined by extreme variability in mood, activity, sleep and circadian timing recurring over weeks and months. To date, studies of sleep/circadian rhythms in bipolar disorder
have been cross-sectional and based on only 1-2 weeks of monitoring: we urgently need new approaches that can assess longer-term individual-level changes in sleep, activity and mood, to
better understand symptom trajectories and mechanisms of relapse. In Ambient-BD, we will optimize innovative ambient and passive data collection methods over long time periods and test their feasibility and
performance against gold standards.  

The aims of Work Package 1 (Acceptability, feasibility and validity of novel ambient and passive data collection methods for sleep, circadian rhythmicity and light exposure) are:
* to test the performance of novel radar sleep sensors against the gold standard methods for assessing sleep and circadian rhythms, polysomnography and dim light melatonin onset
* to generate a longitudinal dataset of radar sensing and sleep data that can be used to optimse methods for assessing varibaility in sleep time series data
  

## Study Design


## Methodological Information  

### [Questionnaires](/Questionnaires)   

1. Morning Eveningness Questionnaire 
2. Concensus Sleep Diary
4. Insomnia Severity Index
5. Demography 
6. Stopbang Questionnaire

Questionnaire data are collected online using ([onlinesurveys.ac.uk](https://www.onlinesurveys.ac.uk/)) and downloaded as coded csv files.  The coding translations are [here](Questionnaires/questionnaire_coding.xlsx)   
<br>  

### Radar Sensing  
A radar sensing unit (Somnofy, [VitalThings](https://vitalthings.com/en/products/somnofy/) will be placed at the bedside.  Data are acquired to a cloud-based platform continuously and downloaded to the servers at MU on a weekly basis and stored in individual participant folders (Z:\Somnofy\data). The code for downloading data from the VitalThings API is [here](https://github.com/chronopsychiatry/ambient-somnofy.git)

<br>  

### Accelerometry  
Data will be collected using an AX6 wrist worn accelerometer (Axivity, UK; [details](https://axivity.com/product/ax6)) over a three month duration.  The Axivity devices will be programmed to collect acceleration data from X, Y and Z axis at 12.5 Hz with a sensitivity of 8g.  
####  AX6 Setup  

Use opensource software OpenMovement, UK [OMGUI](https://github.com/digitalinteraction/openmovement/wiki/AX3-GUI), to programme the AX6 with the following options:  
```
[Tools][Options] set [Filename] = acc_{SubjectCode}_{DeviceId}  
[File][Choose Working Folder] = set to Z:\Accelerometery\cwa_files\  

# To program device – [clear][record]  

#### Recording Settings
[Sampling] = 12.5Hz
[Recording Time][Range] = +/- 8g
[Interval = anticipated wear start time +24h
[Subject][Code] = “studyID”
    Untick  [Flash during Recording]
            [Lower power]
	    [Unpacked data]
```



Data will be downloaded from the device in *.cwa (Continuous Wave Accelerometry) format and stored on the MU server (Z:\Axivity\cwa_files).  Accelerometry data will be processed using the R-package [GGIR](https://github.com/wadpac/GGIR) to derive parameters describing sleep and circadian rhythms by running R script [runGGIR](scripts/run_ggir290924.R).  The GGIR configuration parameters applied are [here](datasheets/config_130824.csv).  The final outputs of the runGGIR script are stored in the Z: server:  

| Directory | Description |
|-----------|-------------|
| `Z:/Axivity/cwa` | Contains all CWA files |
| `Z:/Axivity/Results/csv_files` | Contains time series data for all participants in separate files |
| `Z:/Axivity/Results/ggir_variables` | Contains GGIR variables needed for Ambient-BD in separate files |
| `Z:/Axivity/Participant_GGIR_output` | Contains all GGIR output for all participants in separate folders |

<br>  

### Polysomnography  
Polysomnography will be performed according to this [protocol](protocols/PSG_protocol_161024.docx).  Data will be acquired and analysed using MiniView software supplied by Lowenstein Medical [datasheet here](datasheets/miniscreen-viewer-sleep-diagnostics-user-manual-en.pdf).  Sleep scoring will be performed independently by trained scorers. Each 30 second epoch will be scored as (i) wake, (ii) N1, (iii) N2, (iv) N3, (v) REM and comparsons between scorers or devices made using comparisons described [here](  ).  the following data downloaded from Miniview:  

Sleep parameters according to AASM definitions will be downloaded from Miniviewer as a automatically generated html report; direct export of parameters is not possible.  

*  Physiological time series (EEG, ECG, EMG, SpO2, airflow, thermistor, abdomimal and chest movement) (edf)
*  Sleep scores (csv)
*  Sleep report (html)
  
The parameters and hyponogram are extracted from the report using this [R-script](
  
<br>
  


| Directory | Description |
|-----------|-------------|
| `Z:/psg/Data/studyID` | Contains all miniview output (total measurement, efg, report and sleep stage pdf files) for each studyID |
| `Z:/psg/Analysis/Sleep_metrics` | Contains sleep parameters extracted from miniview report |
| `Z:/psg/Analysis/Sleep_scores` | Contains sleep scores for each studyID |

<br>  
   
### Dim Light Melatonin Onset (DMLO)  
The time of DLMO will be measured according to this [protocol](protocols/DMLO_protocol.md). Time series data describing salivary melatonin concentrations will be stored as csv files for each participant in the following folder, Z:\DMLO\time_series) and derived times of DLMO will be stored in a csv file here, Z:\DMLO\results)
<br>


### File Formats and Size  
Questionnaire raw data are stored in CSV format, somnofy raw data as json files and accelerometry raw data in .cwa format.  PSG data are stored as edf or csv files.  All other data are stored in csv format.  Code and metadata wil be stored in .txt files. The entire project dataset will take less than 100GB storage space.  W3C/ISO 8601 date standard, which specifies the international standard notation of YYYY-MM-DD or YYYY-MM-DDThh:mm:ss will be used in all data collection and processing.  Data will be stored on dedicated workspace on an MU server mapped as Z: and on an allocated Ambient-BD sharepoint.
<br>  

### Participant Identification  

Participants will be identified by a sequence of 4 random numbers that uniquely identifies preceeded by ABD to denote the project (primary identification key).  Random numbers were allocated using the RAND() function in MS Excel, with no replacement.  These data will be called "studyID" in all datasets and used as the primary key in a relational database stored in MS Access.  

<br>  

### Dataset and Folder Overview  

A file and folder naming schema will be used to organise the data based on the domain and measurement instrument.  The folder and file name schema are closely related (see below) and data from each participant will be easily identified across the datasets by their primary identification key (studyID)  
<br>  

### File Naming  
File names will reflect folder structure and be inform the user of the domain, modality and participant (for individual level data). The three letter file extension will convey information on the file format.   
<br>  

Files will be named as:  
[domain][instrument][studyID]  

Date format in this case will be YYMMDD. Domains and their abbreviations are  

* Questionnaires (isi, meq, demo, sb, diary)
* Radar (rad)
* Accelerometery (acc)
* Dim light melatonin onset (dlmo)
* Polysomnography (psg)
 
Each folder will contain a folder where old versions of data files will be archived.  

<br>  

### Folder Naming
In the top folder of the folder structure, there will be a .txt format file (a ReadMe file) with a description of the structure and data contained and where any changes can be documented.  The folder names will follow the naming convention of the files.  The top folders will be the domain names, Questionnaires, Radar, Accelerometery, Polysomnography, DLMO.  

```
Ambient_BD
│
├── Questionnaires
│   │
│   ├── Readme.txt
|   |
│   ├── MEQ
│   │   ├── 
│   │   ├── analysis
│   │   └── key
│   │
│   ├── ISI
│   │   ├── 
│   │   ├── analysis
│   │   └── key
│   │
│   ├── Demo
│   │   ├── 
│   │   ├── analysis
│   │   └── key
│   │
│   └── Stopbang
│       ├── 
│       ├── analysis
│       └── key
│
├── Sleep_Diaries
│   │
│   ├── Readme.txt
|   |
│   ├── Analysis
|   |
│   └── Key
│   
├── Accelerometry
│   │
│   ├── Readme.txt
│   │
│   ├── cwa
│   │
│   └── Results
│       ├── csv
│       ├── ggir_output
│       └── ggir_variables
│   
└── Radar
    │
    ├── Readme.txt
    │
    ├── Sleep
    │   ├── raw
    │   ├── analysis
    │   └── code
    │
    ├── CR
    │   ├── raw
    │   ├── analysis
    │   └── code
    │
    └── Envir
        ├── raw
        ├── analysis
        └── code
```
<br>  

### Variable Naming  
Questionnaire raw data variables will be named as: [instrument][i], where instrument is the name of the questionnaire and i is the question number.  For example, data from question 4 from the Stopbang questionnaire would be stored in a variable called sb4. Raw data variable names generated by data processing using GGIR and VitalThings (Somnofy Research Platform) will not be renamed.  Variables derived from these data will be named according to the following convention: [domain][instrument][variable description], where variable description is a name taken from previous studies where possible, or constructed to represent the variable data.  For example, a variable used to store data from radar sensors on sleep efficiency would be named radar_sleep_efficiency  

<br>  

### Data Dictionary  
A data dictionary will be prepared for all variables used in Ambient-BD detailing each variable name, the type of data stored, the units and range [link].  

<br>  

### Ambient-BD Database  
A master database will be created in MS Access that will link to raw data files for each instrument stored in their respective "raw" folder.  Separate tables will be created in MS Access based on the instruments with each table linked by the 4-digit identification number for each participant (primary key, "studyID").  This database will facilitate collation of the derived parameters from each instrument.
<br>  

Participant Feedback
Selected data will be extracted from the results and presented in an rmarkdown file to facilitate return of meaningful data to each particpant at the end of the study. 
 The rmarkdown code is [here]( returned to the participants 

###  Software  
All data processing and analysis will be performed in R and MS Access.  Accelerometery, radar and polysomnography sensors will be programmed using software supplied by the manufacturer (Axivity = OMGUI [link], Somnofy = health/VitalThings (  ) and MiniView (Lowenstein Medical).  Data will be stored locally on a server and backed up to a onedrive location on a weekly basis.  Version control of code files will be maintained with github.
<br>  

### Data Reuse  
Data will be open access under a Creative Commons (c0) licence following anonomysation at the end of the project (June 2026).  No data will be shared outside the study team prior to that.
