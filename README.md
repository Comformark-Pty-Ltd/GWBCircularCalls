# GWBCircularCalls
Find Circular Calls between Clarion DLLs

### Note:
This template was created and used 10 years ago to help untangle the calls between DLLs in a complex Clarion multi-DLL application. It has not been used by me since then and I'm a little bit vague about the dteails of how to use it!

If it's not making sense or giving you the output that you need, **PLEASE DON'T WASTE TIME WITH IT!**

## Components
### GWBCircularModules.TPL
This is a Clarion Utility template which you can save in your Clarion/Accessory/Template/win/ folder. Open Clarion and register this template.

The primary purpose of this template is to recursively process the specified application and its related external Apps.
The template has two main utilites for finding circular calls between DLLs and several secondary utilities which make also use of the recursive functionality.

I'm not sure if the template has any use when called as a "utility" within a Clarion app, it is intended to be called using the following batch files.

### Batch Files
**You will need to edit ALL these batch files and update the path to your Clarion installation.**

These batch files are intended to run within your application folder, or you can edit them to specify a folder where your apps are located. You could probably copy your apps and .dct to a folder and copy the batch files to that folder and run them there. This is probably the best option for simplicity and security.

No changes are made to your apps by running these batch files and template, but just to be safe, it's probably best to use them on a copy of your apps and dct.

#### _Batch01_ExportExternalModuleList.bat
This batch file generates a list of modules (DLLs) and all the external modules that are called, for each module.
You can edit this batch file to call all the apps in the folder (*.app) or provide a comma separated list of apps if you want to process them in a particular order (app1.app, app2.app, etc.app)

This batch file specifies an output file "_ExternalModuleList.csv" containing the app name and all the external apps that this app calls. An example file is supplied.

#### _Batch02_FindCircularCalls.bat
This batch file should be run after _Batch01_ExportExternalModuleList.bat because it uses the _ExternalModuleList.csv file that it generated as an **input file**.

This batch file will generate a tree of DLLs with circular calls.

Two example files are supplied "_CircularCalls_p_ma.csv" and "_ModuleCalls.csv"

**NOTE:** I can't remember the details of how these files were generated for the project it was used on, or why the structures are different? (Sorry about that!)

**NOTE:** These files are not "csv" format, you could edit the template to make comma separated output so they could be opened in Excel??

#### _Batch03_ProcedureList.bat ##
This batch file generates a csv file with a list of **app, procedure, procedure's external app** to help you find offending circular procedure calls.

"_AllProceduresFileList.csv" is an example of the output.

### Additonal Functionality ###
The following two batch files were intended to help with an update of the project from Clarion 5 to Clarion 9

#### _Batch04_ExportTemplatesUsedToCSV.bat ####
This batch file generates a list of all templates used in a project.

#### _Batch05_ExportWindowControlsToCSV.bat ####
This batch file generates a list of window controls used in a project.

