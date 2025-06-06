::Generate a list of all modules and the external modules they call, using a Clarion utility template
FOR %%x IN (*.app) DO C:\Clarion91\BIN\clarionCL /win /aru %%x GWBExternalModulesToCSV(GWBRecursiveModules) outputfile(_ExternalModuleList.csv)

:: Batch file calls utility template to output circular calls to _CircularCalls_APPNAME.csv - where APPNAME is the name of a specific app
:: C:\Clarion91\BIN\clarionCL  -ConfigDir C:\Clarion91\Bin\Settings /win /aru APPNAME.app GWBRecursiveCalls(GWBRecursiveModules) inputfile(_ExternalModuleList.csv)
PAUSE