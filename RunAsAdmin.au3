#Region ToDo
#cs


#ce
#EndRegion ToDo

#Region Includes
#Include <MsgBoxConstants.au3>
#Include <Crypt.au3>
;#Include <passwordlist.au3>
#EndRegion Includes

#Region Variables
$sDomain = @ComputerName
$sUser = "Administrator"
$sPassword = "ENCRYPTEDPASSWORD"
$sEncryptText = "thisisthekey"
#EndRegion Variables

#Region Workflow
_ImageSwitch(_GetImage())
_RunAs("test.exe","1")
;_RegAdd('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', '"Key"="Value"')
MsgBox($MB_SYSTEMMODAL,"Script finished!",_ImageSwitch(_GetImage()))
;_EncryptPassword(InputBox("Passwordencryptor","Insert password to encrypt:",$sPassword))
;_DecryptPassword(InputBox("Passworddecryptor","Insert password to decrypt:",$sPassword))
#EndRegion Workflow

#Region Functions

Func _RunAs($sApplication,$iFileSizeCheck)
  $sApplication = @ScriptDir&"\"&$sApplication
If $iFileSizeCheck = FileGetSize($sApplication) _
Then
  $pid = RunAsWait($sUser,$sDomain,_DecryptPassword($sPassword),0, _
  $sApplication,@SystemDir,@SW_HIDE)
  MsgBox($MB_SYSTEMMODAL,"Script finished!","Everything should work as expected.")
Else
  InputBox("Script aborted!", _
  "Filesize does not match or application not found:"&$iFileSizeCheck& _
  " does not match ",FileGetSize($sApplication))
  Exit
EndIf
EndFunc;==>_RunAs

Func _RegAdd($sRegFolder,$sRegKey)
  $sRegFolder = '['&$sRegFolder&']'
  FileWrite(@TempDir & "\TheReg.reg", _
    'Windows Registry Editor Version 5.00' & @crlf & _
    @crlf & _
    $sRegFolder & @crlf & _
    $sRegKey & @crlf)
    RunAsWait($sUser,$sDomain,_DecryptPassword($sPassword),0, _
    @Windowsdir & '\regedit.exe /s "' & @TempDir & '\TheReg.reg"','')
  FileDelete(@Tempdir & "\TheReg.reg")
EndFunc;==>_RegAdd

Func _GetImage()
  $ComputerDescription = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters","srvcomment")
  Return $ComputerDescription
EndFunc;==>_GetImage

Func _EncryptPassword($sClearTextPass)
  $sPassword = _StringEncrypt(True,$sClearTextPass,$sEncryptText)
  InputBox("Password encrypted","Your encrypted password below:",$sPassword)
EndFunc;==>_EncryptPassword

Func _DecryptPassword($sEncryptedPass)
  $sPassword = _StringEncrypt(False,$sEncryptedPass,$sEncryptText)
  ;InputBox("Password decrypted","Your decrypted password below:",$sPassword)
  Return $sPassword
EndFunc;==>_DecryptPassword

Func _StringEncrypt($bEncrypt, $sData, $sPassword)
  _Crypt_Startup() ; Start the Crypt library.
  Local $sReturn = ''
  If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
      $sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
  Else
      $sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
  EndIf
  _Crypt_Shutdown() ; Shutdown the Crypt library.
  Return $sReturn
EndFunc   ;==>_StringEncrypt

#Comments-Start
;Externalized passwordlist for security resons see passwordlist.au3
Func _ImageSwitch($ImageName)
  Select
  Case $ImageName = 'Image1'
    $sPassword = 'encryptedPassword1'
  Case $ImageName = 'Image2'
    $sPassword = 'encryptedPassword2'
  Case $ImageName = 'Image3' OR $ImageName = 'Image4' OR $ImageName = 'Image5'
    $sPassword = 'encryptedPassword3'
  Case $ImageName = 'Image6' OR $ImageName = 'Image7'
    $sPassword = 'encryptedPassword4'
  Case Else
    MsgBox ( 0, "Image-Name unknown", "The image: "& $ImageName & " is not recognized.")
    Exit
  EndSelect
  Return $sPassword
EndFunc
#Comments-End
#EndRegion Functions
