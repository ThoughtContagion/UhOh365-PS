param (
    [Parameter(Mandatory = $true,
		HelpMessage = 'Select the method to enumerate emails: Single or File')]
	[ValidateSet('SINGLE', 'FILE',
		IgnoreCase = $true)]
	[string] $enumMethod
)

Function Invoke-UhOh365 {

    If ($enumMethod -eq "Single") {
        $emails = Read-Host -Prompt "Enter an email to enumerate"
    }

    If ($enumMethod -eq "File"){
        $global:FileName = $null

        # Get the .nessus file to import and parse
        If ($PSVersionTable.PSVersion.Major -eq 5){
            Add-Type -AssemblyName System.Windows.Forms

            $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
                InitialDirectory = "$env:DOCUMENTS" 
                    Filter = 'Text File (*.txt)|*.txt'
            }

            $FileBrowser.ShowDialog() | Out-Null

            $global:FileName = $FileBrowser.FileName
        }
        Elseif ($PSVersionTable.PSVersion.Major -ge 6){
            If ($IsWindows) {
                Add-Type -AssemblyName System.Windows.Forms

                $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
                    InitialDirectory = "$env:DOCUMENTS" 
                    Filter = 'Text File (*.txt)|*.txt'
                }

                $FileBrowser.ShowDialog() | Out-Null

                $global:FileName = $FileBrowser.FileName
            }
            Else{
                $global:FileName = Read-Host -Prompt "Enter the full path to the file containing the list of users: (eg, ~/users.txt)"
            }
        }

        $emails = Get-Content $global:FileName
    }


    Foreach ($email in $emails) {
        $uri = "https://outlook.office365.com/autodiscover/autodiscover.json/v1.0/$($email)?Protocol=Autodiscoverv1"

        Try {
            $request = (Invoke-RestMethod -Method Get -Uri $uri -UserAgent $user_agent -ContentType 'application/json' -ErrorAction Stop)

            If ($request) {
                Write-Host '[+]' -ForegroundColor Green -NoNewline
                Write-Host " $email found!" -ForegroundColor Yellow
            }
        }
        Catch {
            $exception = $_.Exception

            If ($exception <#-like "*The user cannot be found*"#>) {
                Write-Host '[-]' -ForegroundColor Red -NoNewline
                Write-Host " $email not found." -ForegroundColor Yellow
            }
        }
    }
}

Invoke-UhOh365