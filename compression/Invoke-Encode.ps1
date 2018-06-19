<#
    Changes by Robert Wallhead (thisismyrobot)

    https://github.com/thisismyrobot/loaduck/compare/4bd150a...master#diff-d36e9afee0b578300581569656ccd2da
#>
function Invoke-Encode
{
<#
.SYNOPSIS
Script for Nishang to encode and compress plain data.

.DESCRIPTION
The script asks for a path to a plain file or string, encodes it and writes to standard output.

.PARAMETER DataToEncode
The path of the file to be decoded. Use with -IsString to enter a string.

.PARAMETER IsString
Use this to specify the data/command to be encodedif you are passing a string in place of a filepath.

.LINK
http://www.darkoperator.com/blog/2013/3/21/powershell-basics-execution-policy-and-code-signing-part-2.html
https://github.com/samratashok/nishang

#>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True)]
        [String]
        $DataToEncode,

        [Switch]
        $IsString
    )

    if($IsString -eq $true)
    {
       $Enc = $DataToEncode
    }
    else
    {
        $Enc = Get-Content $DataToEncode -Encoding Ascii
    }

    #Compression logic from http://www.darkoperator.com/blog/2013/3/21/powershell-basics-execution-policy-and-code-signing-part-2.html
    $ms = New-Object IO.MemoryStream
    $action = [IO.Compression.CompressionMode]::Compress
    $cs = New-Object IO.Compression.DeflateStream ($ms,$action)
    $sw = New-Object IO.StreamWriter ($cs, [Text.Encoding]::ASCII)
    $Enc | ForEach-Object {$sw.WriteLine($_)}
    $sw.Close()
    
    # Base64 encode stream
    $Compressed = [Convert]::ToBase64String($ms.ToArray())

    #http://www.darkoperator.com/blog/2013/3/21/powershell-basics-execution-policy-and-code-signing-part-2.html
    $command = "`sal n New-Object;iex `$(n IO.StreamReader(" +

    "`$(n IO.Compression.DeflateStream(" +

    "`$(n IO.MemoryStream(,"+

    "`$([Convert]::FromBase64String('$Compressed'))))," +

    "[IO.Compression.CompressionMode]::Decompress))"+

    ")).ReadToEnd();"

    Write-Output $command
}

