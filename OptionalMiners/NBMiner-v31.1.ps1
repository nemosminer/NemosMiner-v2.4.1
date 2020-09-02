using module ..\Includes\Include.psm1

$Name = "$(Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName)"
$Path = ".\Bin\$($Name)\nbminer.exe"
$Uri = "https://github.com/NebuTech/NBMiner/releases/download/v31.1/NBMiner_31.1_Win.zip"
$DeviceEnumerator = "Type_Slot"

$Commands = [PSCustomObject[]]@(
    [PSCustomObject]@{ Algorithm = @("Eaglesong");           Fee = @(0.01);       MinMemGB = 0.1; MinMemGBWin10 = 0.1; Type = "AMD";    Command = " --algo eaglesong --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Eaglesong", "Ethash"); Fee = @(0.01, 0.01); MinMemGB = 4;   MinMemGBWin10 = 4;   Type = "AMD";    Command = " --algo eaglesong_ethash --fee 1" }
#   [PSCustomObject]@{ Algorithm = @("Ethash");              Fee = @(0.0065);     MinMemGB = 4;   MinMemGBWin10 = 4;   Type = "AMD";    Command = " --algo ethash" } #BMiner & PhoenixMiner are fastest
    [PSCustomObject]@{ Algorithm = @("Handshake");           Fee = @(0.01);       MinMemGB = 0.1; MinMemGBWin10 = 0.1; Type = "AMD";    Command = " --algo hns --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Handshake", "Ethash"); Fee = @(0.01, 0.01); MinMemGB = 4;   MinMemGBWin10 = 4;   Type = "AMD";    Command = " --algo hns_ethash --fee 1" }
    [PSCustomObject]@{ Algorithm = @("KawPoW");              Fee = @(0.01);       MinMemGB = 3;   MinMemGBWin10 = 3;   Type = "AMD";    Command = " --algo kawpow --fee 1" }

    [PSCustomObject]@{ Algorithm = @("Cuckaroo29bfc");       Fee = @(0.01);       MinMemGB = 5;   MinMemGBWin10 = 6;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo bfc --fee 1" }
#   [PSCustomObject]@{ Algorithm = @("CuckarooD29");         Fee = @(0.01);       MinMemGB = 4;   MinMemGBWin10 = 5;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo cuckarood --fee 1" } #GMiner-v2.22 is fastest
    [PSCustomObject]@{ Algorithm = @("Cuckaroo29s");         Fee = @(0.01);       MinMemGB = 5;   MinMemGBWin10 = 6;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo cuckaroo_swap --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Cuckatoo31");          Fee = @(0.01);       MinMemGB = 8;   MinMemGBWin10 = 10;  MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo cuckatoo --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Cuckatoo32");          Fee = @(0.01);       MinMemGB = 8;   MinMemGBWin10 = 10;  MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo cuckatoo32 --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Cuckoo29");            Fee = @(0.01);       MinMemGB = 5;   MinMemGBWin10 = 6;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo cuckoo_ae --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Eaglesong");           Fee = @(0.01);       MinMemGB = 0.1; MinMemGBWin10 = 0.1; MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo eaglesong --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Eaglesong", "Ethash"); Fee = @(0.01, 0.01); MinMemGB = 4;   MinMemGBWin10 = 4;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo eaglesong_ethash --fee 1" }
#   [PSCustomObject]@{ Algorithm = @("Ethash");              Fee = @(0.0065);     MinMemGB = 4;   MinMemGBWin10 = 4;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo ethash" } #BMiner & PhoenixMiner are fastest
    [PSCustomObject]@{ Algorithm = @("Handshake");           Fee = @(0.01)      ; MinMemGB = 0.1; MinMemGBWin10 = 0.1; MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo hns --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Handshake", "Ethash"); Fee = @(0.01, 0.01); MinMemGB = 4;   MinMemGBWin10 = 4;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo hns_ethash --fee 1" }
    [PSCustomObject]@{ Algorithm = @("KawPoW");              Fee = @(0.01)      ; MinMemGB = 3;   MinMemGBWin10 = 3;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo kawpow --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Sero");                Fee = @(0.01)      ; MinMemGB = 2;   MinMemGBWin10 = 2;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo progpow_sero --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Sipc");                Fee = @(0.01)      ; MinMemGB = 1;   MinMemGBWin10 = 1;   MinCUDAComputeCapability = 6.0; Type = "NVIDIA"; Command = " --algo sipc --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Tensority");           Fee = @(0.01)      ; MinMemGB = 0.1; MinMemGBWin10 = 0.1; MinCUDAComputeCapability = 6.1; Type = "NVIDIA"; Command = " --algo tensority --fee 1" }
    [PSCustomObject]@{ Algorithm = @("Tensority", "Ethash"); Fee = @(0.01, 0.01); MinMemGB = 4;   MinMemGBWin10 = 4;   MinCUDAComputeCapability = 6.1; Type = "NVIDIA"; Command = " --algo tensority_ethash --fee 1" }
)

If ($Commands = $Commands | Where-Object { ($Pools.($_.Algorithm[0]).Host -and -not $_.Algorithm[1]) -or ($PoolsSecondaryAlgorithm.($_.Algorithm[0]).Host -and $Pools.($_.Algorithm[1]).Host) }) { 

    #Intensities for 2. algorithm
    $Intensities2 = [PSCustomObject]@{ 
        "Eaglesong" = @(1, 2, 3, 4, 5, 6, 7, 8) #default 6
        "Handshake" = @(1, 2, 3, 4, 5, 6, 7, 8) #default 6
        "Tensority" = @(1, 2, 3, 4, 5, 6, 7, 8) #default 6
    }

    # Build command sets for intensities
    $Commands = $Commands | ForEach-Object { 
        $Command = $_ 
        If ($_.Algorithm[1]) { 
            $Intensities2.($_.Algorithm[0]) | Select-Object | ForEach-Object { 
                $Command | Add-Member Intensity2 ([Uint16]$_) -Force
                $Command | ConvertTo-Json | ConvertFrom-Json
            }
        }
        Else { 
            $Command
        }
    }

    $Devices | Where-Object Type -in @("AMD", "NVIDIA") | Select-Object Type, Model -Unique | ForEach-Object { 
        If ($SelectedDevices = @($Devices | Where-Object Type -EQ $_.Type | Where-Object Model -EQ $_.Model)) { 
            $MinerAPIPort = [UInt16]($Config.APIPort + ($SelectedDevices | Sort-Object Id | Select-Object -First 1 -ExpandProperty Id) + 1)

            $Commands | Where-Object Type -EQ $_.Type | ForEach-Object { 
                $MinCUDAComputeCapability = $_.MinCUDAComputeCapability
                $MinMemGB = $_.MinMemGB

                #Windows 10 requires more memory on some algos
                If ([System.Environment]::OSVersion.Version -ge [Version]"10.0.0.0") { $MinMemGB = $_.MinMemGBWin10 }

                If ($Miner_Devices = @($SelectedDevices | Where-Object { ($_.OpenCL.GlobalMemSize / 1GB) -ge $MinMemGB } | Where-Object { $_.CUDAComputeCapability -ge $MinCUDAComputeCapability })) { 

                    #Get commands for active miner devices
                    #$_.Command = Get-CommandPerDevice -Command $_.Command -ExcludeParameters @("algo") -DeviceIDs $Miner_Devices.$DeviceEnumerator

                    $Miner_Name = (@($Name) + @($Miner_Devices.Model | Sort-Object -Unique | ForEach-Object { $Model = $_; "$(@($Miner_Devices | Where-Object Model -eq $Model).Count)x$Model" }) + @($_.Algorithm[0]) + @($_.Intensity2) | Select-Object) -join '-'

                    If ($_.Algorithm[0] -match "^Ethash*|^Cuck*") { 
                        $Protocol = If ($Pools.($_.Algorithm[0]).Name -match "^MPH*|^NiceHash*") { "nicehash+tcp://" } Else { "ethproxy+tcp://" } 
                    }
                    Else { $Protocol = "stratum+tcp://" }
                    If ($Pools.($_.Algorithm[0]).SSL) { $Protocol = $Protocol -replace '\+tcp\://$', '+ssl://' }

                    $_.Command += " --url $($Protocol)$($Pools.($_.Algorithm[0]).Host):$($Pools.($_.Algorithm[0]).Port) --user $($Pools.($_.Algorithm[0]).User):$($Pools.($_.Algorithm[0]).Pass)"

                    If ($_.Algorithm[1]) { 
                        $Miner_Name = (@($Name) + @($Miner_Devices.Model | Sort-Object -Unique | ForEach-Object { $Model = $_; "$(@($Miner_Devices | Where-Object Model -eq $Model).Count)x$Model" }) + @($_.Algorithm[0]) + @($_.Intensity2) | Select-Object) -join '-'

                        If ($_.Algorithm[1] -match "^Ethash*|^Cuck*") { 
                            $Protocol2 = If ($Pools.($_.Algorithm[1]).Name -match "MPH*|NiceHash*") { "nicehash+tcp://" } Else { "ethproxy+tcp://" } 
                        }
                        Else { $Protocol2 = "stratum+tcp://" }
                        If ($Pools.($_.Algorithm[1]).SSL) { $Protocol2 = $Protocol2 -replace '\+tcp\://$', '+ssl://' }

                        $_.Command += " --secondary-url $($Protocol2)$($Pools.$($_.Algorithm[1]).Host):$($Pools.$($_.Algorithm[1]).Port) --secondary-user $($Pools.$($_.Algorithm[1]).User):$($Pools.($_.Algorithm[0]).Pass)$(If($_.Intensity2 -ge 0) { " --secondary-intensity $($_.Intensity2)" })"
                    }
                    Else { 
                        $Miner_Name = (@($Name) + @($Miner_Devices.Model | Sort-Object -Unique | ForEach-Object { $Model = $_; "$(@($Miner_Devices | Where-Object Model -eq $Model).Count)x$Model" }) | Select-Object) -join '-'
                    }

                    #Optionally disable dev fee mining
                    If ($Config.DisableMinerFees) { 
                        $_.Fee = @(0) * ($_.Algorithm | Select-Object).count
                    }

                    [PSCustomObject]@{ 
                        Name       = $Miner_Name
                        DeviceName = $Miner_Devices.Name
                        Type       = $_.Type
                        Path       = $Path
                        Arguments  = ("$($_.Command) --no-watchdog --api 127.0.0.1:$($MinerAPIPort) --devices $(($Miner_Devices | Sort-Object $DeviceEnumerator | ForEach-Object { '{0:x}' -f $_.$DeviceEnumerator }) -join ',')" -replace "\s+", " ").trim()
                        Algorithm  = ($_.Algorithm[1], $_.Algorithm[0]) | Select-Object
                        API        = "NBMiner"
                        Port       = $MinerAPIPort
                        Wrap       = $false
                        URI        = $Uri
                        Fee        = $_.Fee
                        MinerUri   = "http://localhost:$($MinerAPIPort)"
                    }
                }
            }
        }
    }
}