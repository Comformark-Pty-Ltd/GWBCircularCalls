::@ECHO OFF

FOR %%x IN (*.app) DO C:\Clarion91\BIN\clarionCL  -ConfigDir C:\Clarion91\Bin\Settings /win /aru %%x GWBExternalModulesToCSV(GWBRecursiveModules) outputfile(_ExternalModuleList.csv)
 
PAUSE