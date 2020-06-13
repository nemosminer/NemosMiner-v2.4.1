using module ..\Includes\Include.psm1

$Path = ".\Bin\CPU-ccminerverushash38\ccminer.exe"
$Uri = "https://github.com/Minerx117/miner-binaries/releases/download/3.8/ccminer3.8cpu.7z"
$Commands = [PSCustomObject]@{ 
    "verus"     = "" #Verus
    "verushash" = "" #Verushash
}
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName
$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object { 
    switch ($_) { 
        default { $ThreadCount = $Variables.ProcessorCount - 1 }
    }
    $Algo = Get-Algorithm($_)
    [PSCustomObject]@{ 
        Type      = "CPU"
        Path      = $Path
        Arguments = "-t $($ThreadCount) -N 1 -R 1 -b $($Variables.CPUMinerAPITCPPort) -o stratum+tcp://$($Pools.$Algo.Host):$($Pools.$Algo.Port) -a verus -u $($Pools.$Algo.User) -p $($Pools.$Algo.Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{$Algo = $Stats."$($Name)_$($Algo)_HashRate".Week }
        API       = "ccminer"
        Port      = $Variables.CPUMinerAPITCPPort
        Wrap      = $false
        URI       = $Uri
        User      = $Pools.$Algo.User
        Host      = $Pools.$Algo.Host
        Coin      = $Pools.$Algo.Coin
    }
}
