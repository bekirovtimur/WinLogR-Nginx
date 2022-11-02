# Import configuration
Get-Content ".\config.ini" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }
$7zip=$h.Get_Item("7zip")
$PsExec=$h.Get_Item("PsExec")
$LogsDir=$h.Get_Item("LogsDir")
$ArchiveDir=$h.Get_Item("ArchiveDir")
$TempDir=$h.Get_Item("TempDir")
$LogFilesList=$h.Get_Item("LogFilesList")
$NginxDir=$h.Get_Item("NginxDir")
$ArchiveTTL=$h.Get_Item("ArchiveTTL")

# Generate random number
$RndNum=(Get-Random -Minimum 100000 -Maximum 999999)

# Get current date
$Year=Get-Date -Format "yyyy"
$Month=Get-Date -Format "MM"
$Day=Get-Date -Format "dd"
$PathToCurrentArchive="$ArchiveDir\$Year-$Month-$Day"

# Create Folders
New-Item -ItemType "directory" -Path "$PathToCurrentArchive" -Force
New-Item -ItemType "directory" -Path "$TempDir\$RndNum" -Force

# Make log archives and clean log files
  foreach($line in Get-Content $LogFilesList) {
    $InputFile="$LogsDir\$line"
	  $TempFile="$TempDir\$RndNum\$line"
    $UnixEpochTime=[DateTimeOffset]::Now.ToUnixTimeSeconds()
    $ArchiveName="$PathToCurrentArchive\$line.$UnixEpochTime.7z"
	  Move-Item -Path "$InputFile" -Destination "$TempFile"
    Start-Process -NoNewWindow -Wait -FilePath "$PsExec" -ArgumentList "-s $NginxDir\nginx.exe -p $NginxDir -s reopen"
	  Start-Process -NoNewWindow -Wait -FilePath "$7zip" -ArgumentList "a -t7z $ArchiveName $TempFile"
  	Remove-Item -Path "$TempFile" -Force
  }

# Remove temp folder
Remove-Item -Path "$TempDir\$RndNum" -Recurse -Force

# Delete old archives (TTL)
Get-ChildItem -Path "$ArchiveDir" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-$ArchiveTTL))} | Remove-Item -Recurse -Force
