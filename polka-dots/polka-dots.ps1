# Base64 encoder and decoder tool
# e.g. .\polka-dots.ps1 -in somefile.txt -out output.txt -action decode
# Params:
# [string]$in: path to your input file
# [string]$out: optional output file destination, otherwise input is overwritten
# [string]$action: operation to perform. Valid options are encode and decode

param (
    [Parameter(Mandatory=$true)][string]$in,
    [Parameter(Mandatory=$true)][string]$out,
    [Parameter(Mandatory=$true)][ValidateSet('decode', 'encode')][string]$action
)

function testFile([string]$path) {
    if (-not (Test-Path $path)) {
        throw [System.IO.FileNotFoundException] "$path, Does not exist"
    } else {
        return $true
    }
}

function readFile([string]$path) {
    $data = Get-Content $path
    return $data
}

function writeToFile($data) {
    if ($out) {
        $data | Out-File $out
    } else {
        $data | Out-File $in
    }
}

function base64([String]$data, [bool]$encode) {
    if ($encode) {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($data)
        $encodedBytes = [System.Convert]::ToBase64String($bytes)
        return $encodedBytes
    } else {
        $decodedBytes = [System.Convert]::FromBase64String($data)
        $printableString = [System.Text.Encoding]::UTF8.GetString($decodedBytes)
        return $printableString
    }
    
}

if (testFile $in) {
    $fileData = readFile $in

    if ($action.ToLower() -eq 'encode') {
        $result = base64 $fileData $true
        writeToFile $result
    } elseif ($action.ToLower() -eq 'decode') {
        $result = base64 $fileData $false
        writeToFile $result
    } else {
        Write-Output "Could not perform action requested: $action"
    }
}
