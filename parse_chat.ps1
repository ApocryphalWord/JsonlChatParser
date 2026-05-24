param(
    [Parameter(Mandatory=$true)][string]$InputPath,
    [Parameter(Mandatory=$true)][string]$OutputPath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $InputPath)) {
    Write-Error "Input file not found: $InputPath"
    exit 1
}

# Stream the file line-by-line so very large JSONL files don't blow up memory.
$reader = [System.IO.File]::OpenText((Resolve-Path -LiteralPath $InputPath))
$writer = New-Object System.IO.StreamWriter($OutputPath, $false, [System.Text.UTF8Encoding]::new($false))

$lineNum = 0
$written = 0
$skipped = 0

try {
    while (($line = $reader.ReadLine()) -ne $null) {
        $lineNum++
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) { continue }

        try {
            $obj = $trimmed | ConvertFrom-Json
        } catch {
            Write-Warning "Line $lineNum`: invalid JSON, skipped."
            $skipped++
            continue
        }

        $name = $obj.sender_name
        $msg  = $obj.message

        if ([string]::IsNullOrEmpty($name)) { $name = '(unknown)' }
        if ($null -eq $msg) { $msg = '' }

        # Normalize line endings inside the message so markdown renders cleanly.
        $msg = $msg -replace "`r`n", "`n"

        $writer.WriteLine("### $name")
        $writer.WriteLine()
        $writer.WriteLine($msg)
        $writer.WriteLine()
        $written++
    }
}
finally {
    $reader.Close()
    $writer.Close()
}

Write-Host "Parsed $written message(s) from $lineNum line(s); $skipped skipped."
