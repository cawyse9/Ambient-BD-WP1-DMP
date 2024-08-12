<div align="center">
	<img src="./images/Questionnaire_header.svg", width=150%>
</div>  


# Ambient and passive collection of sleep and circadian rhythm data in bipolar disorder to understand symptom trajectories and clinical outcomes (AMBIENT-BD)
<br>
<br>  

## Work Package 1 - Acceptability, feasibility and validity of novel ambient and passive data collection methods for sleep, circadian rhythmicity and light exposure  

Bipolar disorder is defined by extreme variability in mood, activity, sleep and circadian timing recurring over weeks and months. To date, studies of sleep/circadian rhythms in bipolar disorder
have been cross-sectional and based on only 1-2 weeks of monitoring: we urgently need new approaches that can assess longer-term individual-level changes in sleep, activity and mood, to
better understand symptom trajectories and mechanisms of relapse. In Ambient-BD, we will optimize innovative ambient and passive data collection methods over long time periods and test their feasibility and
performance against gold standards. 

#### Contributors at Maynooth University
* Dr Lorna Lopez  
* Professor Andrew Coogan  
* Dr Cathy Wyse  
* Sean Farrell  
* Christiane O'Brien  
See www.ambientbd.com for details of the entire Ambient-BD research team  

#### Start date  
2024-06-01  

#### Finish date  
2026-06-01  
<br>  

<br>  

## Methodological Information  

### [Questionnaires](/Questionnaires)   

1. Morning Eveningness Questionnaire 
2. Concensus Sleep Diary
4. Insomnia Severity Index
5. Demography 
6. Stopbang Questionnaire

Questionnaire data are collected online using onlinesurveys.ac.uk ([link](https://www.onlinesurveys.ac.uk/)) and downloaded as coded csv files.  The coding translations are [here](Questionnaires/questionaire_coding.xlsx)   
<br>  

### Radar Sensing  
A radar sensing unit (Somnofy, VitalThings, Norway https://vitalthings.com/en/products/somnofy/) will be placed approximately 40cm from the edge of the bed.  Data are acquired to a cloud-based platform continuously.  Data are downloaded to the servers at MU on a weekly basis and stored in individual participant folders (Z:\Somnofy\data)  
<br>  

### Accelerometry  
Data will be collected using an AX6 wrist worn accelerometer (Axivity, UK; [link to datasheet]) over a three month duration.  The Axivity devices will be programmed to collect acceleration data from X, Y and Z axis at 12.5 Hz with a sensitivity of 8g [link to readme].  Data will be downloaded from the device in *.cwa (Continuous Wave Accelerometry) format and stored on the MU server (Z:\Axivity\cwa_files).  Accelerometry data will be processed using the R-package GGIR (link) to derive parameters describing sleep and circadian rhythms by running script runGGIR {  }  
<br>  

### Polysomnography  

<br>  

### Dim Light Melatonin Onset  
<br>

## Data Storage  
<br>  

### File Formats and Size  
Questionnaire raw data are stored in CSV format, somnofy data as json files and accelerometry data in .cwa format.  All other data are stored in csv format.  Code and metadata wil be stored in .txt files. The entire project dataset will take less than 100GB storage space.  W3C/ISO 8601 date standard, which specifies the international standard notation of YYYY-MM-DD or YYYY-MM-DDThh:mm:ss will be used in all data collection and processing.  Data will be stored on dedicated workspace on an MU server mapped as Z: and on FamilyGenomics sharepoint ()  
<br>  

### Participant Identification  

Participants will be identified by a sequence of 4 random numbers that uniquely identifies preceeded by ABD to denote the project (primary identification key).  Random numbers were allocated using the RAND() function in MS Excel, with no replacement and are stored at this location [  ].  These data will be called "studyID" in all datasets and used as the primary key in a relational database stored in MS Access.  

<br>  

### Dataset and Folder Overview  

A file and folder naming schema will be used to organise the data based on the domain and measurement instrument.  The folder and file name schema are closely related (see below) and data from each participant will be easily identified across the datasets by their primary identification key (individual_ID)  
<br>  

### File Naming  
File names will reflect folder structure and be inform the user of the domain, modality and participant (for individual level data). The three letter file extension will convey information on the file format.   
<br>  

Files will be named as:  
[domain][instrument][date]  

Date format in this case will be YYMMDD. Domains and their abbreviations are  

* Questionnaires (que)
* Radar (rad)
* Accelerometery (acc)
* Dim light melatonin onset (DLMO)
* Polysomnography (PSG)

Instruments and their abbreviations are: 
* Morning Eveningness Questionnaire (meq)
* Demography (demo)
* Insomnia Severity Index (ISI)
*
* sleep (slp), circadian rhythms (cr), temperature (temp), light (lit), noise (nse) and physical activity (pa).  The individual variable names are defined in the data dictionnary (link).  

For example, a file containing data on sleep derived from accelerometry data saved on 2024-02-22 would be called:  
    acc_sleep_240222

Version control is implemented by the 6 digit date in each file name.  Each folder will contain an archive where old versions of data files will be archived.  

<br>  

### Folder Naming
In the top folder of the folder structure, there will be a .txt format file (a ReadMe file) with a description of the structure and data contained and where any changes can be documented.  The folder names will follow the naming convention of the files.  The top folders will be the domain names, Questionnaires, Radar, Accelerometery, Polysomnography, DLMO.  Sub-directory names will be the instruments, Morning Eveningness Questionnaire.  

Each instrument folder will contain a sub-directory for storage of raw data files called (raw), analysis (anal) and code (code)  

```
Ambient_BD
│
├── Questionnaires
│   │
│   ├── Readme.txt
|   |
│   ├── MEQ
│   │   ├── raw
│   │   ├── analysis
│   │   └── code
│   │
│   ├── ISI
│   │   ├── raw
│   │   ├── analysis
│   │   └── code
│   │
│   ├── Demo
│   │   ├── raw
│   │   ├── analysis
│   │   └── code
│   │
│   └── Stopbang
│   │   ├── raw
│   │   ├── analysis
│   │   └── code
│   │ 
│   └── Stopbang
│       ├── raw
│       ├── analysis
│       └── code
│    
│   
├── Accelerometry
│   │
│   ├── Readme.txt
│   │
│   ├── Sleep
│   │   ├── raw
│   │   ├── analysis
│   │   └── code
│   │   │
│   └── Circadian Rhythms
│       ├── raw
│       ├── analysis
│       └── code
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

## Data Processing  
<br>  

### Ambient-BD Database  
A master database will be created in MS Access that will link to raw data files for each instrument stored in their respective "raw" folder.  Separate tables will be created in MS Access based on the instruments with each table linked by the 4-digit identification number for each participant (primary key, "studyID").  This database will facilitate collation of the derived parameters from each instrument.
<br>  

###  Software  
All data processing and analysis will be performed in R and MS Access.  Accelerometery, radar and polysomnography sensors will be programmed using software supplied by the manufacturer (Axivity = OMGUI [link], Somnofy = VitalThings (  ) and Sonata (  )).  Data will be backed up to a onedrive location on a weekly basis, and version control of code files will be maintained with github.
<br>  

### Data Reuse  
Data will be open access following anonymousiation at the end of the project (June 2026).  No data will be shared outdise the study team prior to that.
