# README - This script will create a new streaming policy in the Azure Media Service account
# replace the variables below with your own values
# ========================================================================

# declare variables
$tenantId = "276d0956-0f29-4e02-83bb-f16796b3bf6a" #Change this to your tenant id
$subscriptionId = "3ebeeb7f-655c-41de-9d9d-0e9c97e202eb" #Change this to your subscription id
$rgName = "AQA-NEX-DEV-62-EUW" #Change this to your resource group name
$amsName = "aqanexdev62euwmeds" #Change this to your Azure Media Service account name
$streamingPolicyName="AQA-All-Streaming-Policy-1" #Change this to your chosen NEW streaming policy name

# login to azure tenant
az login --tenant $tenantId
# set the default subscription id
az account set --subscription $subscriptionId
# login to azure powershell
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId

# set the powershell subscription context
Set-AzContext -Subscription $subscriptionId

# Get the existing streaming policy list
$(az ams streaming-policy list --resource-group $rgName --account-name $amsName --output json)

# show a table of all the streaming policies
az ams streaming-policy list --resource-group $rgName --account-name $amsName --output table

# Get the streaming policy details
az ams streaming-policy show --resource-group $rgName --account-name $amsName --name $streamingPolicyName --output json

# Create a streaming policy that allows all drm types and aes encryption
# ========================================================================
$(az ams streaming-policy create --resource-group $rgName --account-name $amsName --name $streamingPolicyName `
    --cbcs-protocols Dash HLS SmoothStreaming `
    --cenc-protocols Dash HLS SmoothStreaming `
    --envelope-protocols Dash HLS SmoothStreaming `
    --output json)
# ========================================================================

# Show the new streaming policy details
az ams streaming-policy show --resource-group $rgName --account-name $amsName --name $streamingPolicyName --output json

# Get the existing streaming policy list
$(az ams streaming-policy list --resource-group $rgName --account-name $amsName --output json)
