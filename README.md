# WinLogR Nginx
Simple [Windows Nginx](https://nginx.org/en/docs/windows.html) Log Rotation powershell script

![alt tag](icon.png)

## ✅ Prerequisites
* [7zr](https://7-zip.org/download.html) - Command line 7zip archiver. [Direct link](https://7-zip.org/a/7zr.exe)
* [PsExec](https://learn.microsoft.com/en-us/sysinternals/downloads/psexec) - Sysinternals command-line tool.

## ✳️ Configuration
1. Set correct paths to config.ini
2. Set Lifetime of archived logs in ArchiveTTL option (Default 90 days) at config.ini
3. Specify all log files in logslist.ini
4. Correct path in run.cmd script
5. Add run.cmd script to Windows Task Scheduler (for example, run every day at 23:55)

## ❎ Warning
The author is not responsible for the possible loss or damage of your data.
Before running the script, carefully read its contents and make the necessary corrections.
Be sure to conduct preliminary testing on the stand.