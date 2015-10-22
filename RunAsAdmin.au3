#Region ToDo
#cs


#ce
#EndRegion ToDo

#Region Includes
#Include <MsgBoxConstants.au3>
#EndRegion Includes

#Region Variables
$sDomain = @ComputerName
$sUser = "Administrator"
$sPassword = "Password"
#EndRegion Variables

#Region Workflow
_RunAs(".exe","1")

#EndRegion Workflow

#Region Functions

Func _RunAs($sApplication,$iFileSizeCheck)
$sApplication = @ScriptDir&"\"&$sApplication
If $iFileSizeCheck = FileGetSize($sApplication) _
Then
$pid = RunAsWait($sUser,$sDomain,$sPassword,0,$sApplication,@SystemDir,@SW_HIDE)
;Else
MsgBox($MB_SYSTEMMODAL,"Script finished!","Everything should work as ecpected.")
Else
InputBox("Script aborted!","Filesize does not match or application not found:"&$iFileSizeCheck&" does not match ",FileGetSize($sApplication))
;Exit
EndIf
EndFunc
#EndRegion Functions
