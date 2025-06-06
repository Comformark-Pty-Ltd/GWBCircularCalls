::@ECHO OFF

FOR %%x IN (*.app) DO C:\Clarion91\BIN\clarionCL /win /aru %%x GWBExportTemplatesUsedToCSV(GWBRecursiveModules) outputfile(_TemplateUsedByProcedures.csv)
 
PAUSE