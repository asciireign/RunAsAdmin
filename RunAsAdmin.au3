#Region ToDo
#cs


#ce
#EndRegion ToDo

#Region Includes
#Include <MsgBoxConstants.au3>
#Include <Crypt.au3>
#EndRegion Includes

#Region Variables
$sDomain = @ComputerName
$sUser = "Administrator"
$sPassword = "ENCRYPTEDPASSWORD"
$sEncryptText = "thisisthekey"
#EndRegion Variables

#Region Workflow
;_RunAs("test.exe","1")
;_RegAdd('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', '"Key"="Value"')
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
  MsgBox($MB_SYSTEMMODAL,"Script finished!","Everything should work as ecpected.")
Else
  InputBox("Script aborted!", _
  "Filesize does not match or application not found:"&$iFileSizeCheck&" _
  does not match ",FileGetSize($sApplication))
  Exit
EndIf
EndFunc

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
EndFunc

Func _EncryptPassword($sClearTextPass)
  $sPassword = StringEncrypt(True,$sClearTextPass,$sEncryptText)
  InputBox("Password encrypted","Your encrypted password below:",$sPassword)
EndFunc

Func _DecryptPassword($sEncryptedPass)
  $sPassword = StringEncrypt(False,$sEncryptedPass,$sEncryptText)
  InputBox("Password decrypted","Your decrypted password below:",$sPassword)
  Return $sPassword
EndFunc

Func StringEncrypt($bEncrypt, $sData, $sPassword)
  _Crypt_Startup() ; Start the Crypt library.
  Local $sReturn = ''
  If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
      $sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
  Else
      $sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
  EndIf
  _Crypt_Shutdown() ; Shutdown the Crypt library.
  Return $sReturn
EndFunc   ;==>StringEncrypt
#EndRegion Functions
