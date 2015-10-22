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
$sPassword = "Password"
$sEncryptText = "thisisthekey"
#EndRegion Variables

#Region Workflow
_RunAs("test.exe","1")
;_EncryptPassword(InputBox("Passwordencryptor","Insert password to encrypt:",$sPassword))
;_DecryptPassword(InputBox("Passworddecryptor","Insert password to decrypt:",$sPassword))
#EndRegion Workflow

#Region Functions

Func _RunAs($sApplication,$iFileSizeCheck)
$sApplication = @ScriptDir&"\"&$sApplication
If $iFileSizeCheck = FileGetSize($sApplication) _
Then
$pid = RunAsWait($sUser,$sDomain,_DecryptPassword($sPassword),0,$sApplication,@SystemDir,@SW_HIDE)
;Else
MsgBox($MB_SYSTEMMODAL,"Script finished!","Everything should work as ecpected.")
Else
InputBox("Script aborted!","Filesize does not match or application not found:"&$iFileSizeCheck&" does not match ",FileGetSize($sApplication))
;Exit
EndIf
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
