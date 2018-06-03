# loaduck

PowerShell script bootstrapper for the Hak5 USB Rubber Ducky.

Written in PowerShell.

Targets Windows 7 and Windows 10, YMMV otherwise.

# How

PowerShell files can be dragged on to loaduck.ps1 to generate a .ps1.ducky.txt
file that can be used on the ducky.

Or you can use a command like:

    powershell .\loaduck.ps1 [ps1 filename]

This will generate:

    [ps1 filename].ducky.txt

The wrapper script minimises your source PowerShell into a single line, then
injects it in an (almost) invisible payload that's fired from Win-R.

### Example

For example, given a (really annoying) PowerShell script of:

```powershell
For ($i=0; $i -le 2; $i++) {
    start https://www.youtube.com/watch?v=dQw4w9WgXcQ
}
rundll32.exe user32.dll,LockWorkStation
```

Firstly, that script will be semi-minified to:

```powershell
For($i=0;$i -le 2;$i++){start https://www.youtube.com/watch?v=dQw4w9WgXcQ};rundll32.exe user32.dll,LockWorkStation
```

The the script will be encoded into the following Ducky Script:

```
DELAY 5000
GUI r
DELAY 250
ALT SPACE
STRING M
LEFT
REPEAT 40
ENTER
STRING powershell -w hidden iex '(Add-Type n -pas -m ''[DllImport(\"user32\")]public static extern int ShowWindow(int h,int n);'')::ShowWindow((gps -Id $pid).MainWindowHandle,0);Read-Host|iex'
ENTER
DELAY 1000
STRING For($i=0;$i -le 2;$i++){start https://www.youtube.com/watch?v=dQw4w9WgXcQ};rundll32.exe user32.dll,LockWorkStation
ENTER
```

The long PowerShell script creates the hidden PowerShell window that listens
for keystrokes (our minified annoying script in this case) and then runs them
when it receives and Enter key.

# Licence

This script is licensed MIT *except* for the minification folder which
contains a script that is MPL 1.1 licensed - see in there for details.
