#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#TEMPLATE (GWBRecursiveModules, 'GWB Find Recursive Modules'),FAMILY('ABC'),Family('Cw20')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#! MAINTENANCE
#! Created 2015-02-05 GWB
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#UTILITY(GWBExternalModulesToCSV, 'Output External Modules for ALL applications to Passed CSV File')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
#DECLARE(%OutputFile)
#SET(%OutputFile,extract(%UtilityArguments,'outputfile',0))
#IF(%OutputFile = '')
  #SET(%OutputFile,'_AllExternalModules.csv')
#ENDIF  
#OPEN(%OutputFile)
#INSERT(%GWBExportExternalModules)
#CLOSE(%OutputFile)
#!--------------------------------------------------
#GROUP(%GWBExportExternalModules)
#! External Modules list
#!-----------------------------------------------
#!
#DECLARE(%GWBApplication)
#DECLARE(%GWBModules),UNIQUE
#DECLARE(%GWBHasExternals)
#SET(%GWBApplication, LOWER(%Application))
#SET(%GWBHasExternals,0)
#FOR(%Module),WHERE(%ModuleExtension = '.lib')
  #SET(%GWBHasExternals,1)
#ENDFOR
#IF(%GWBHasExternals = 0)
  #ADD(%GWBModules,%GWBApplication)
#ELSE  
  #FOR(%Module),WHERE(%ModuleExtension = '.lib')
    #ADD(%GWBModules,LOWER(SUB(%Module,1,LEN(%Module) - 4)))
  #ENDFOR
#ENDIF     
#FOR(%GWBModules)
%GWBApplication,%GWBModules
#ENDFOR
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#UTILITY(GWBRecursiveCalls, 'Output External Module Calls showing circular calls')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
#DECLARE(%InputFile)
#DECLARE(%OutputFile)
#DECLARE(%ErrorMessage)
#DECLARE(%GWBModuleCounter)
#DECLARE(%GWBApplication),UNIQUE
#DECLARE(%GWBCalledModule,%GWBApplication),UNIQUE
#DECLARE(%GWBApplication2),UNIQUE
#DECLARE(%GWBCalledModule2,%GWBApplication2),UNIQUE
#SET(%InputFile,extract(%UtilityArguments,'inputfile',0))
#IF(%InputFile = '')
  #SET(%InputFile,'_AllExternalModules.csv')
#ENDIF  
#IF(NOT FILEEXISTS(%InputFile))
  #SET(%ErrorMessage,'The input file specified - ' & %InputFile & ' does not exist, cannot continue')
  #ERROR(%ErrorMessage)
  #ABORT
#ENDIF
#SET(%OutputFile,extract(%UtilityArguments,'outputfile',0))
#IF(%OutputFile = '')
  #SET(%OutputFile,'_CircularCalls_' & %Application & '.csv')
#ENDIF  
#INSERT(%GWBImportInputFile)
#SET(%GWBModuleCounter,0)
#CREATE(%OutputFile)
#INSERT(%GWBFindDirectCalls,%GWBApplication)
#FIX(%GWBApplication,%Application)
#!INSERT(%GWBModuleCallTree,%GWBApplication,'')
#CLOSE(%OutputFile)
#!
#!--------------------------------------------------
#GROUP(%GWBImportInputFile)
#! Import Modules list
#!--------------------------------------------------
#!
#DECLARE(%FileLine)
#DECLARE(%FileApplication)
#DECLARE(%FileModule)
#OPEN(%InputFile),READ
#LOOP
	#READ(%FileLine)
	#IF(%FileLine = %EOF)
		#BREAK
	#ENDIF	
  #SET(%FileApplication,SUB(%FileLine,1,INSTRING(',',%FileLine,1,1)-1))
  #SET(%FileModule,SUB(%FileLine,INSTRING(',',%FileLine,1,1)+1,LEN(%FileLine)))
	#ADD(%GWBApplication,%FileApplication)
	#ADD(%GWBCalledModule,%FileModule)
	#ADD(%GWBApplication2,%FileApplication)
	#ADD(%GWBCalledModule2,%FileModule)
#ENDLOOP
#CLOSE(%InputFile)
#!
#!--------------------------------------------------
#GROUP(%GWBModuleCallTree,%GWBThisApplication,%GWBLevel)
#! External Modules list
#!--------------------------------------------------
#!
#FIX(%GWBApplication,%GWBThisApplication)
#SET(%GWBModuleCounter,%GWBModuleCounter + 1)
#IF(INSTRING(%GWBThisApplication,%GWBLevel,1,1))
%6GWBModuleCounter %GWBLevel-> %GWBThisApplication (Circular)
  #SET(%GWBLevel,'')
#ELSE
  #SET(%GWBLevel,%GWBLevel & '->' & %GWBApplication)
  #IF(%GWBModuleCounter < 10000)
    #FOR(%GWBCalledModule)
#INSERT(%GWBModuleCallTree, %GWBCalledModule,%GWBLevel)
    #ENDFOR
  #ENDIF  
#ENDIF  
#!
#!--------------------------------------------------
#GROUP(%GWBFindDirectCalls,%GWBThisApplication)
#! External Modules list
#!--------------------------------------------------
#!
#FOR(%GWBApplication)
  #FOR(%GWBCalledModule)
#INSERT(%GWBCheckCalledModules,%GWBApplication,%GWBCalledModule)
  #ENDFOR
#ENDFOR
#!
#!--------------------------------------------------
#GROUP(%GWBCheckCalledModules,%GWBThisApplication,%GWBCalledApplication)
#! External Modules list
#!--------------------------------------------------
#!
#FIX(%GWBApplication2,%GWBCalledApplication)
#FOR(%GWBCalledModule2)
  #IF(%GWBCalledModule2 = %GWBThisApplication)
%GWBThisApplication <--> %GWBCalledApplication      
  #ENDIF
#ENDFOR
#!
#!--------------------------------------------------
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#UTILITY(GWBExportTemplatesUsedToCSV, 'Output Templates Used for ALL applications to Passed CSV File')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
#! NOTE Designed to be called from a batch file
#!
#DECLARE(%OutputFile)
#SET(%OutputFile,extract(%UtilityArguments,'outputfile',0))
#IF(%OutputFile = '')
  #SET(%OutputFile,'_AllTemplatesUsed.csv')
#ENDIF  
#OPEN(%OutputFile)
#INSERT(%GWBExportTemplatesUsed)
#CLOSE(%OutputFile)
#!--------------------------------------------------
#GROUP(%GWBExportTemplatesUsed)
#! All Templates Used in current app
#!-----------------------------------------------
#!
#DECLARE(%GWBApplication)
#SET(%GWBApplication, LOWER(%Application))
#FOR(%Procedure)
  #FOR(%ActiveTemplate)
%GWBApplication,%Procedure,%ActiveTemplate
  #ENDFOR
#ENDFOR
#!
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#UTILITY(GWBExportWindowControlsToCSV, 'Output Window Controls Used for ALL applications to Passed CSV File')
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
#! NOTE Designed to be called from a batch file - to find where ?G_CalButton is used
#!
#DECLARE(%OutputFile)
#SET(%OutputFile,extract(%UtilityArguments,'outputfile',0))
#IF(%OutputFile = '')
  #SET(%OutputFile,'_AllWindowControlsUsed.csv')
#ENDIF  
#OPEN(%OutputFile)
#INSERT(%GWBExportWindowControlsUsed)
#CLOSE(%OutputFile)
#!--------------------------------------------------
#GROUP(%GWBExportWindowControlsUsed)
#! All Templates Used in current app
#!-----------------------------------------------
#!
#DECLARE(%GWBApplication)
#DECLARE(%GWBProcedure),UNIQUE
#DECLARE(%GWBControlName,%GWBProcedure),UNIQUE
#SET(%GWBApplication, LOWER(%Application))
#FOR(%Procedure)
  #ADD(%GWBProcedure,LOWER(%Procedure))
  #FOR(%Control)
    #ADD(%GWBControlName,SUB(LOWER(%Control),1,12))
  #ENDFOR
#ENDFOR
#FOR(%GWBProcedure)
  #FOR(%GWBControlName),WHERE(%GWBControlName = '?g_calbutton' OR SUB(%GWBControlName,1,6) = '?imagn' OR SUB(%GWBControlName,1,6) = '?calen' OR SUB(%GWBControlName,1,6) = '?gwbim')
%GWBApplication,%GWBProcedure,%GWBControlName
  #ENDFOR
#ENDFOR
#!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!
