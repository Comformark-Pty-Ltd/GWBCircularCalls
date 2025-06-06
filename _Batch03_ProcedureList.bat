::@ECHO OFF

Del _AllProceduresFileList.csv

FOR %%x IN (*.app) DO C:\Clarion91\BIN\clarionCL -ConfigDir C:\Clarion91\Bin\Settings /win /aru %%x GWBExportProcedureListByModuleCSV(GWBTools) outputfile(_AllProceduresFileList.csv)

::for %%x in (app1.app, app2.app, app3.app, etc.app) DO C:\Clarion91\BIN\clarionCL /win /aru %%x GWBExportProcedureListByModuleCSV(GWBTools) outputfile(_ShortProcedureFileList.csv)

 
PAUSE