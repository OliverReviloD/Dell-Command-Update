Function Get-DcuCliExe-FilePath {
    # return: full path to DCU-CLI.EXE  ( or $NULL )
    
    # is DCU installed on the local system ?

    # Function_DCU__Get-DcuCliExe-FilePath.PS1
    
    [String]$DcuCliClassic = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" 
    [String]$DcuCliUwp     = "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" 
    [String]$DcuCliExeFilePath = $Null

    if ( test-path $DcuCliClassic ) 
        {
        $DcuCliExeFilePath = $DcuCliClassic
        $DcuVersion        = (Get-Item $DcuCliExeFilePath).VersionInfo.FileVersion  # .FileVersionRaw
        $MsgString         = "Dell Command Upate (Classic) is installed at '$DcuCliExeFilePath' - v $DcuVersion"
        }
    elseif ( test-path $DcuCliUwp ) 
        {
        $DcuCliExeFilePath = $DcuCliUwp
        $DcuVersion        = (Get-Item $DcuCliExeFilePath).VersionInfo.FileVersionRaw
        $MsgString         = "Dell Command Upate (UWP) is installed at '$DcuCliExeFilePath' - v $DcuVersion"
        }
    else
        {
        $DcuCliExeFilePath = $Null
        $MsgString         = "Dell Command Upate (Classic / UWP) is -------- not installed --------"
        }
    Write-Host "Get-DcuCliExe-FilePath() - $MsgString"
    return $DcuCliExeFilePath
    }
<#
    [String]$DcuCliExeFilePath = Get-DcuCliExe-FilePath
    # Write-Host "DcuCliExeFilePath '$DcuCliExeFilePath'"
    if ( $DcuCliExeFilePath -eq $Null -or $DcuCliExeFilePath -eq "" )
        {
        Write-Error      "'Dell Command Update' is not installed - E X I T"
        return 1
        }
#>
