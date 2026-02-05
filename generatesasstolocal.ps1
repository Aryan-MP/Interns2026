# ===============================
# USER CONFIGURATION
# ===============================
$ResourceGroupName = "siva-rsg"
$StorageAccountName = "sivastoragedemo"
$ContainerName = "sivacontainer"
$BlobName = "DerangulaSivaKumar-onboarding form.pdf"

# Local file path (Downloads folder)
$LocalFilePath = "$env:USERPROFILE\Downloads\blob-sas-details.txt"

# SAS expiry (1 hour)
$SasExpiryTime = (Get-Date).AddHours(3)

# ===============================
# GET STORAGE CONTEXT
# ===============================
$StorageAccount = Get-AzStorageAccount `
    -ResourceGroupName $ResourceGroupName `
    -Name $StorageAccountName

$Context = $StorageAccount.Context

# ===============================
# GENERATE READ-ONLY SAS
# ===============================
$SasUrl = New-AzStorageBlobSASToken `
    -Container $ContainerName `
    -Blob $BlobName `
    -Permission r `
    -ExpiryTime $SasExpiryTime `
    -Context $Context `
    -FullUri

# Extract token from URL
$SasToken = $SasUrl.Split("?")[1]

# ===============================
# SAVE SAS DETAILS LOCALLY
# ===============================
$SasDetails = @"
SAS URL:
$SasUrl

SAS Token:
$SasToken

Expiry Time:
$SasExpiryTime
"@

$SasDetails | Out-File -FilePath $LocalFilePath -Encoding UTF8

Write-Host "SAS details saved successfully to:"
Write-Host $LocalFilePath
