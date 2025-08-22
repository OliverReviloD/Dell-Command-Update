Function Convert-DcuApplicableUpdatesXml-to-PsCustomObject{
    Param(  [Parameter(Mandatory=$true)][String]$DCUReport_XmlFile)
    
    Write-Log -logLevel 1 -Message "Convert-DcuApplicableUpdatesXml-to-PsCustomObject() - read '$DCUReport_XmlFile' and create/return an array of PSCustomObjects"

    
    <# 
        $XPath="//updates/update/release"
        [xml](Get-Content $DCUReportFile  )|Select-Xml –Xpath $XPath | Select-Object –ExpandProperty "node" 

        <update>
            <release>562FN</release>
            <name>Killer AX1650 and Intel AX200/AX201/9260/9560/9462/8265/8260/7265/3165 Bluetooth UWD Driver</name>
            <version>21.110.0.3</version>
            <date>December 23, 2020</date>
            <urgency>Urgent</urgency>
            <type>Driver</type>
            <category>Network</category>
            <file>FOLDER06413469M/10/Killer-AX1650-and-Intel-AX200-AX201-9260-9560-9462-8265-8260-7265-3165_562FN_WIN_21.110.0.3_A21_07.EXE</file>
            <bytes>47060304</bytes>
        </update>
    #> 

     
    <#
        $MissingUpdate = [PSCustomObject]@{  
            release    = '562FN'
            name       = 'Killer AX1650 and Intel AX200/AX201/9260/9560/9462/8265/8260/7265/3165 Bluetooth UWD Driver'
            version    = '21.110.0.3'
            date       = 'December 23, 2020'
            urgency    = 'Urgent'
            type       = 'Driver'
            category   = 'Network'
            file       = 'FOLDER06413469M/10/Killer-AX1650-and-Intel-AX200-AX201-9260-9560-9462-8265-8260-7265-3165_562FN_WIN_21.110.0.3_A21_07.EXE'
            bytes      = '47060304'
            }
    
    #>
    
    $arrayMissingUpdates = @()

    $ScanResult = [xml](Get-Content $DCUReport_XmlFile  )
    $XPath="//updates/update"
    $Count = ($ScanResult | Select-Xml -Xpath $XPath).count
    
    $ComputerModel = (Get-WMIObject Win32_ComputerSystem).Model
    $ScanDate = (Get-Date -Format "yyyy-MM-dd")

    for ($num = 1 ; $num -le $Count ; $num++)
        {
        [String]$FileRealtivePath = $ScanResult | Select-XML "/updates/update[$num]/file" 

        $MissingUpdate = [PSCustomObject]@{  
            release    = $ScanResult | Select-XML "/updates/update[$num]/release" 
            name       = $ScanResult | Select-XML "/updates/update[$num]/name" 
            version    = $ScanResult | Select-XML "/updates/update[$num]/version" 
            date       = $ScanResult | Select-XML "/updates/update[$num]/date" 
            urgency    = $ScanResult | Select-XML "/updates/update[$num]/urgency" 
            type       = $ScanResult | Select-XML "/updates/update[$num]/type" 
            category   = $ScanResult | Select-XML "/updates/update[$num]/category" 
            file       = $ScanResult | Select-XML "/updates/update[$num]/file" 
            bytes      = $ScanResult | Select-XML "/updates/update[$num]/bytes" 
            
            #   added by script for better analysis / reporting
            filename   = $FileRealtivePath.Split("/") | Select-Object -Last 1
            WebSite    = "https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=" + $($ScanResult | Select-XML "/updates/update[$num]/release" )
            ComputerModel = $ComputerModel
            HostName      = $env:COMPUTERNAME
            DcuScanDate     = $ScanDate
            }
        $arrayMissingUpdates += $MissingUpdate
        }
    return $arrayMissingUpdates
    }
