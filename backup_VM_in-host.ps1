##################################################################

#                   User Defined Variables

##################################################################

# Names of VMs to backup separated by comma (Mandatory). For instance, $VMNames = “VM1”,”VM2”

$VMNames = "exch-lab", "win10-vm", "Gateway-vpn","draw.io","AD-vsanlab","AD-bdc", "mooc"
 
# Name of vCenter or standalone host VMs to backup reside on (Mandatory)

$HostName = "172.20.10.7"

# Directory that VM backups should go to (Mandatory; for instance, C:\Backup)

$Directory = "C:\Backup"

#Optionally, you can change compression level and desired retention, disable VMware quiescence, enable encryption or even notification settings:

# Desired compression level (Optional; Possible values: 0 - None, 4 - Dedupe-friendly, 5 - Optimal, 6 - High, 9 - Extreme)

$CompressionLevel = "5"

# Quiesce VM when taking snapshot (Optional; VMware Tools or Hyper-V Integration Components are required for this in the guest OS; Possible values: $True/$False)

$EnableQuiescence = $True

# Protect resulting backup with encryption key (Optional; $True/$False)

$EnableEncryption = $False

# Encryption Key (Optional; path to a secure string)

$EncryptionKey = ""

# Retention settings (Optional; by default, VeeamZIP files are not removed and kept in the specified location for an indefinite period of time.

# Possible values: Never, Tonight, TomorrowNight, In3days, In1Week, In2Weeks, In1Month)

$Retention = "Never"

#If you like to get an email report once the backup is completed, you should additionally fill out the following notification settings.

##################################################################

# Notification Settings

##################################################################

# Enable notification (Optional)

$EnableNotification = $True

# Email SMTP server

$SMTPServer = ""

# Email FROM

$EmailFrom = ""

# Email TO

$EmailTo = ""

# Email subject

$EmailSubject = ""
##################################################################
#                   Email formatting 
##################################################################

$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"

##################################################################
#                   End User Defined Variables
##################################################################

#################### DO NOT MODIFY PAST THIS LINE ################
Asnp VeeamPSSnapin

$Server = Get-VBRServer -name $HostName
$MesssagyBody = @()

foreach ($VMName in $VMNames)
{
  $VM = Find-VBRViEntity -Name $VMName -Server $Server
  
  If ($EnableEncryption)
  {
    $EncryptionKey = Add-VBREncryptionKey -Password (cat $EncryptionKey | ConvertTo-SecureString)
    $ZIPSession = Start-VBRZip -Entity $VM -Folder $Directory -Compression $CompressionLevel -DisableQuiesce:(!$EnableQuiescence) -AutoDelete $Retention -EncryptionKey $EncryptionKey
  }
  
  Else 
  {
    $ZIPSession = Start-VBRZip -Entity $VM -Folder $Directory -Compression $CompressionLevel -DisableQuiesce:(!$EnableQuiescence) -AutoDelete $Retention
  }
  
  If ($EnableNotification) 
  {
    $TaskSessions = $ZIPSession.GetTaskSessions().logger.getlog().updatedrecords
    $FailedSessions =  $TaskSessions | where {$_.status -eq "EWarning" -or $_.Status -eq "EFailed"}
  
  if ($FailedSessions -ne $Null)
  {
    $MesssagyBody = $MesssagyBody + ($ZIPSession | Select-Object @{n="Name";e={($_.name).Substring(0, $_.name.LastIndexOf("("))}} ,@{n="Start Time";e={$_.CreationTime}},@{n="End Time";e={$_.EndTime}},Result,@{n="Details";e={$FailedSessions.Title}})
  }
   
  Else
  {
    $MesssagyBody = $MesssagyBody + ($ZIPSession | Select-Object @{n="Name";e={($_.name).Substring(0, $_.name.LastIndexOf("("))}} ,@{n="Start Time";e={$_.CreationTime}},@{n="End Time";e={$_.EndTime}},Result,@{n="Details";e={($TaskSessions | sort creationtime -Descending | select -first 1).Title}})
  }
  
  }   
}
If ($EnableNotification)
{
$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo
$Message.Subject = $EmailSubject
$Message.IsBodyHTML = $True
$message.Body = $MesssagyBody | ConvertTo-Html -head $style | Out-String
$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer)
$SMTP.Send($Message)
}
