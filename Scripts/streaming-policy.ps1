 # declare variables

$tenantId="28175648-558e-4741-b151-8c149a233509"
$subscriptionId="7ae6fd51-c510-4ef8-bd1a-3129ae1dd660"
$rgName="nerr-media-services-test-ne"
$amsName="nerrmsatestne"
$assetId="Test-Audio-1_ContentAwareEncode_Output_20230517-124703"
$streamingPolicyName=""

# login to azure tenant
az login --tenant $tenantId
# set the default subscription id
az account set --subscription $subscriptionId
# login to azure powershell
Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId



# Get the existing streaming policy list
$streamingPolicyList=$(az ams streaming-policy list --resource-group $rgName --account-name $amsName --output json)

# Sow the list of streaming policies
$streamingPolicyList | ConvertFrom-Json

# display the streaming policy list
echo $streamingPolicyList | jq

# Get the streaming policy name
streamingPolicyName=$(echo $streamingPolicyList | jq -r '.[0].name')

# show a table of all the streaming policies
az ams streaming-policy list --resource-group $rgName --account-name $amsName --output table

# Get the streaming policy details
az ams streaming-policy show --resource-group $rgName --account-name $amsName --name $streamingPolicyName --output json

# Create a streaming policy that allows all drm types and aes encryption
$newStreamingPolicy = $(az ams streaming-policy create --resource-group $rgName --account-name $amsName --name "Test-Streaming-Policy-1" --no-encryption-protocols "Dash, HLS, SmoothStreaming" --clear-key-configuration '{"enabledProtocols": ["Dash", "HLS", "SmoothStreaming"]}' --envelope-key-configuration '{"enabledProtocols": ["Dash", "HLS", "SmoothStreaming"]}' --play-ready-configuration '{"licenseType": "NonPersistent"}' --widevine-configuration '{"licenseType": "NonPersistent"}' --output json)
$newStreamingPolicy = $(az ams streaming-policy create --resource-group $rgName --account-name $amsName --name "Test-Streaming-Policy-4" `
    --cbcs-protocols Dash HLS SmoothStreaming `
    --cenc-protocols Dash HLS SmoothStreaming `
    --envelope-protocols Dash HLS SmoothStreaming `
    --output json)

az ams streaming-policy create --resource-group $rgName --account-name $amsName --name "Test-Streaming-Policy-1" --no-encryption-protocols "Dash HLS SmoothStreaming" --cbcs-protocols "Dash HLS SmoothStreaming" --cenc-protocols "Dash HLS SmoothStreaming" --envelope-protocols "Dash HLS SmoothStreaming" --proto --output json


# Sow the list of streaming policies
$newStreamingPolicy | ConvertFrom-Json

az ams streaming-policy show --resource-group $rgName --account-name $amsName --name "Predefined_ClearKey" --output json
az ams streaming-policy show --resource-group $rgName --account-name $amsName --name "Test-Streaming-Policy-4" --output json