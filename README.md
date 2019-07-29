# medical-informatics-gui-manager
A gui to handle local health companies data, show statistics, create reports. 

## notes
This projects has been developed during my bachelor degree in bioengineering. Unfortunately, the whole comments and most variables are in italian. 
One day i'll translate it all in english if you need it.

This page provides you a high level overview of the whole project. Main pages of the GUI are here presented and discussed. 

# Home page 
## screenshot 
![home page + login](https://github.com/gioele8/medical-informatics-gui-manager/blob/master/screenshots/homepage_with_login.png)

## Intro
This is the main page of the application. It allows to access the manager by entering your credentials. These are present into file ***utenti.txt*** and by providing the correct ID and correct password you'll be forwarded to the correct section. A nice voice-over claiming your name will drive you to it.  
Depending on the user's category you belong to you gain access to:
1) Administrator page 
2) Standard user page 

# Administrator page
## screenshot
![first_page](https://github.com/gioele8/medical-informatics-gui-manager/blob/master/screenshots/admin_page.png)

## intro 
This section allows you to 
1) Register a new user (can be admin or standard) 
2) See the timestamps when user accessed to the platform
3) Consult a calendar
4) Send broadcast communications

# Standard user page
## Intro 
Page devoted to statistics and reporting of hospital and ASLs (Local Health Company).
Every button brings to a different page. Several statistics regarding patients and glucose pharmacokinetics modeling are done and showed in different plots. 
Once again, a calendar and the broadcast chat can be accessed from this section. 

### screenshot 
![first_page](https://github.com/gioele8/medical-informatics-gui-manager/blob/master/screenshots/standard_user_page.png)

# XML parser 
## screenshot
![first_page](https://github.com/gioele8/medical-informatics-gui-manager/blob/master/screenshots/first_page.png)
## browse Osp...
This section allows to process large xml files related to hospital and ASL services coded with the DRG coding system. Thousands of services are stored in these files. A summary can be created by clicking 'crea report' after having loaded the hospital (or ASL) report. 

# Nice to see 
This GUI also implements a pretty nice client - server socket communication. If you want to discover more and implement it for you own, take a look to ***client.m*** and ***server.m*** 


