Koike Lab Realtime EEG to Cortical Current Source Estimation Program

 Overview
===========================
This program can estimate and visualize cortical current source from EEG
signal in realtime. The current source is estimated by applying inverse
filter generated from VBMEG (or any filter with compatible format) to 
incoming EEG signal.

 System Requirements
===========================
- MATLAB (2016a tested)
- VBMEG Toolbox
- EEGLAB Toolbox
- One of any supported acquisition software

 Supported Acquisition Software
=================================
- FieldTrip Buffer
- LabStreamingLayer (LSL)
- Actiview TCP/IP Streaming

 Installation
===========================
1. Place the ‘Realtime EEG-CCS Program’ folder into your desired location.
2. Install data acquisition software of your choice. 

 Execution
===========================
1. Set up data acquisition according to your software of choice.
2. Point MATLAB current directory to ‘Realtime EEG-CCS Program’ directory.
3. Type ‘REC’ command into MATLAB command window and run.

 Profile File Guide
===========================
1. Generate profile in the form of MATLAB '.mat' file containing the neccessary
    parameter in a variable named 'profile'.
2. The contents of the profile file can be generated using VBMEG, and can be manually
    consolidate into a profile file according to the following structure.
    
    profile
        +filter
        |   +KW
        |   +SB_cov
        |   +Hj
        |   +sx
        +current
        |   +Jinfo
        +brain
            +V
            +F
            +xx
            +inf_C

 Developers Guide
===========================
- To add additional mode of acquisition, implement a class that inherit the ‘RECInputBuffer’ class.
- Contains the buffer data in objects of class ‘BufferData’.
- To add additional process on estimated current source, create a class that
   operates on the objects of class ‘CurrentSource’.
- Newly generated 'CurrentSource' is accessible from 'currentSourceAvailableListener_Callback'

- To add additional view, create another GUIDE GUI view that keeps a variable pointing to handles of the
    main window. Then add a listener to the event of interest using source from main window's handles,
    and make a callback function to update new view.
   
 Acknowledgement
===========================
- VBMEG : ATR Neural Information Analysis Labs., Kyoto, Japan
   for cortical current source estimation algorithm.
   
- EEGLAB : Swartz Center for Computational Neuroscience, UCSD
   for EEG signal processing algorithm.
   
 Development Team
============================
EEG Processing Specialist 
 Alejandra Mejía Tobar
 Sorawit Stapornchaisit
 Hyeonseok Kim
 Yu Katsui

Software Developer
 Supat Saetia

Project Supervisor
 Natsue Yoshimura
 Yasuharu Koike