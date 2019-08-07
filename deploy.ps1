 $configFile = ".\deploy.config"

#Read the config file

Write-Host "configFile = $configFile"

    if(Test-Path $configFile) {
        Try {
            #Load config resourceGroups
            $global:resourceGroups = @{}
            $config = [xml](get-content $configFile)
            foreach ($resourceGroupNode in $config.configuration.resourceGroups.add) {	
                if ($resourceGroupNode.Value.Contains(',')) {
                    # Array case
                    $value = $resourceGroupNode.Value.Split(',')
                        for ($i = 0; $i -lt $value.length; $i++) { 
                            $value[$i] = $value[$i].Trim() 
			    
                        }
                }
                else {
                    # Scalar case
                    $value = $resourceGroupNode.Value
		    #Write-Host "Here"	
		    #Write-Host $value
                }

            $global:resourceGroups[$resourceGroupNode.Key] = $value
            }

	    $global:parameters = @{}	
	    foreach ($parameterNode in $config.configuration.parameters.add) {	
		
                if ($parameterNode.Value.Contains(',')) {
                    # Array case
                    $value = $parameterNode.Value.Split(',')
                        for ($i = 0; $i -lt $value.length; $i++) { 
                            $value[$i] = $value[$i].Trim() 
			    
                        }
                }
                else {
                    # Scalar case
                    $value = $parameterNode.Value
		    #Write-Host "Here"	
		    #Write-Host $value
                }
            $global:parameters[$parameterNode.Key] = $value
            }
        }
        Catch [system.exception]{
	Write-Host "No Config File"
        }
    }



$resourceGroupNameDC = $resourceGroups["resourceGroupDC"]
$resourceGroupNameAPP = $resourceGroups["resourceGroupAPP"]
$resourceGroupNameDB = $resourceGroups["resourceGroupDB"]

$subscription = $parameters["subscription"]

$Customer = $parameters["customer"]
$Environment = $parameters["environment"]

$virtualNetworkName = $parameters["virtualNetworkName"]
$virtualNetworkResourceGroup = $parameters["virtualNetworkResourceGroup"]

$dcSubNetName = $parameters["dcSubNetName"]
$appSubNetName = $parameters["appSubNetName"]
$dbSubNetName = $parameters["dbSubNetName"]


$adminUserName = $parameters["adminUserName"]
$adminPassword = $parameters["adminPassword"]

$appLoadBalancerPrivateIPAddress  = $parameters["appLoadBalancerPrivateIPAddress"]
$dbLoadBalancerPrivateIPAddress  = $parameters["dbLoadBalancerPrivateIPAddress"]



$DCAddressPrefix=$parameters["dcAddressPrefix"]
$sqlAddressPrefix=$parameters["sqlAddressPrefix"]
$webAddressPrefix=$parameters["webAddressPrefix"]
$mgtAddressPrefix=$parameters["mgtAddressPrefix"]
$gwAddressPrefix=$parameters["gwdcAddressPrefix"]


$Prefix=$Customer + "-" + $Environment
$DCVM1= $Prefix + "-" + "DC1-VM" 
$DCVM2=$Prefix  + "-" + "DC2-VM" 
$APPVM=$Prefix  + "-" + "APP-VM" 
$MGTVM=$Prefix  + "-" + "MGT-VM" 
$SQLVM1=$Prefix  + "-" + "SQL1-VM" 
$SQLVM2=$Prefix  + "-" + "SQL2-VM" 

$DCVM1nic=$Prefix + "-" + "DC1-nic"
$DCVM2nic=$Prefix + "-" + "DC2-nic"
$APPVMnic=$Prefix  + "-" + "APP-nic"
$MGTVMnic=$Prefix  + "-" + "MGT-nic"




((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%DCVM1%%',$DCVM1) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%DCVM2%%',$DCVM2) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%APPVM%%',$APPVM) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%MGTVM%%',$MGTVM) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%SQLVM1%%',$SQLVM1) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%SQLVM2%%',$SQLVM2) | Set-Content -Path .\AzureDeploy.json


((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%DCVM1nic%%',$DCVM1nic) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%DCVM2nic%%',$DCVM2nic) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%APPVMnic%%',$APPVMnic) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%MGTVMnic%%',$MGTVMnic) | Set-Content -Path .\AzureDeploy.json


((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%DCAddressPrefix%%',$DCAddressPrefix) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%sqlAddressPrefix%%',$sqlAddressPrefix) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%webAddressPrefix%%',$webAddressPrefix) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%mgtAddressPrefix%%',$mgtAddressPrefix) | Set-Content -Path .\AzureDeploy.json
((Get-Content -path .\AzureDeploy.json -Raw) -replace '%%gwAddressPrefix%%',$gwAddressPrefix) | Set-Content -Path .\AzureDeploy.json


<#
Write-Host "resourceGroupNameDC = $resourceGroupNameDC"
Write-Host "resourceGroupNameAPP = $resourceGroupNameAPP"
Write-Host "resourceGroupNameDB = $resourceGroupNameDB"

Write-Host "customer = $Customer"
Write-Host "environment = $Environment"

Write-Host "dcSubNetName = $dcSubNetName" 
Write-Host "appSubNetName = $appSubNetName"
Write-Host "dbSubNetName = $dbSubNetName"

Write-Host "virtualNetworkName = $virtualNetworkName" 
Write-Host "virtualNetworkResourceGroup = $virtualNetworkResourceGroup" 

Write-Host "appLoadBalancerPrivateIPAddress  = $appLoadBalancerPrivateIPAddress"
Write-Host "dbLoadBalancerPrivateIPAddress  = $dbLoadBalancerPrivateIPAddress"

Write-Host "adminUserName  = $adminUserName" 

Write-Host "adminPassword  = $adminPassword" 

#Do a replace on the parameters file for the customer, environment etc for the DC Group

((Get-Content -path .\DCAvailabilitySet.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\DCAvailabilitySet.Parameters.json
((Get-Content -path .\DCAvailabilitySet.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\DCAvailabilitySet.Parameters.json

((Get-Content -path .\DCNetworkSecurityGroup.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\DCNetworkSecurityGroup.Parameters.json
((Get-Content -path .\DCNetworkSecurityGroup.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\DCNetworkSecurityGroup.Parameters.json

((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\DCVirtualMachine.Parameters.json
((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\DCVirtualMachine.Parameters.json

((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%virtualNetworkName%',$virtualNetworkName) | Set-Content -Path .\DCVirtualMachine.Parameters.json
((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%virtualNetworkResourceGroup%',$virtualNetworkResourceGroup) | Set-Content -Path .\DCVirtualMachine.Parameters.json
((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%SubNetName%',$dcSubNetName) | Set-Content -Path .\DCVirtualMachine.Parameters.json
((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%adminUserName%',$adminUserName) | Set-Content -Path .\DCVirtualMachine.Parameters.json
((Get-Content -path .\DCVirtualMachine.Parameters.json -Raw) -replace '%adminPassword%',$adminPassword) | Set-Content -Path .\DCVirtualMachine.Parameters.json

#Do a replace on the parameters file for the customer, environment etc for the APP Group

((Get-Content -path .\APPAvailabilitySet.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\APPAvailabilitySet.Parameters.json
((Get-Content -path .\APPAvailabilitySet.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\APPAvailabilitySet.Parameters.json

((Get-Content -path .\APPNetworkSecurityGroup.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\APPNetworkSecurityGroup.Parameters.json
((Get-Content -path .\APPNetworkSecurityGroup.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\APPNetworkSecurityGroup.Parameters.json

((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\APPVirtualMachine.Parameters.json
((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\APPVirtualMachine.Parameters.json

((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%virtualNetworkName%',$virtualNetworkName) | Set-Content -Path .\APPVirtualMachine.Parameters.json
((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%virtualNetworkResourceGroup%',$virtualNetworkResourceGroup) | Set-Content -Path .\APPVirtualMachine.Parameters.json
((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%SubNetName%',$appSubNetName) | Set-Content -Path .\APPVirtualMachine.Parameters.json
((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%loadBalancerPrivateIPAddress%',$appLoadBalancerPrivateIPAddress) | Set-Content -Path .\APPVirtualMachine.Parameters.json
((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%adminUserName%',$adminUserName) | Set-Content -Path .\APPVirtualMachine.Parameters.json
((Get-Content -path .\APPVirtualMachine.Parameters.json -Raw) -replace '%adminPassword%',$adminPassword) | Set-Content -Path .\APPVirtualMachine.Parameters.json


#Do a replace on the parameters file for the customer, environment etc for the DB Group

((Get-Content -path .\DBAvailabilitySet.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\DBAvailabilitySet.Parameters.json
((Get-Content -path .\DBAvailabilitySet.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\DBAvailabilitySet.Parameters.json

((Get-Content -path .\DBNetworkSecurityGroup.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\DBNetworkSecurityGroup.Parameters.json
((Get-Content -path .\DBNetworkSecurityGroup.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\DBNetworkSecurityGroup.Parameters.json

((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%customer%',$customer) | Set-Content -Path .\DBVirtualMachine.Parameters.json
((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%environment%',$environment) | Set-Content -Path .\DBVirtualMachine.Parameters.json

((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%virtualNetworkName%',$virtualNetworkName) | Set-Content -Path .\DBVirtualMachine.Parameters.json
((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%virtualNetworkResourceGroup%',$virtualNetworkResourceGroup) | Set-Content -Path .\DBVirtualMachine.Parameters.json
((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%SubNetName%',$dbSubNetName) | Set-Content -Path .\DBVirtualMachine.Parameters.json
((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%loadBalancerPrivateIPAddress%',$dbLoadBalancerPrivateIPAddress) | Set-Content -Path .\DBVirtualMachine.Parameters.json

((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%adminUserName%',$adminUserName) | Set-Content -Path .\DBVirtualMachine.Parameters.json
((Get-Content -path .\DBVirtualMachine.Parameters.json -Raw) -replace '%adminPassword%',$adminPassword) | Set-Content -Path .\DBVirtualMachine.Parameters.json

((Get-Content -path .\DBStorageAccount.Parameters.json -Raw) -replace '%customer%',$customer.ToLower()) | Set-Content -Path .\DBStorageAccount.Parameters.json
((Get-Content -path .\DBStorageAccount.Parameters.json -Raw) -replace '%environment%',$environment.ToLower()) | Set-Content -Path .\DBStorageAccount.Parameters.json

Login-AzureRmAccount -SubscriptionName $subscription

$resourceGroupName = $resourceGroupNameDC 

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dcavailabilitySet.json" -TemplateParameterFile ".\dcAvailabilitySet.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dcNetworkSecurityGroup.json" -TemplateParameterFile ".\dcNetworkSecurityGroup.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dcVirtualMachine.json" -TemplateParameterFile ".\dcVirtualMachine.parameters.json"



$resourceGroupName = $resourceGroupNameAPP 

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\appAvailabilitySet.json" -TemplateParameterFile ".\appAvailabilitySet.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\appNetworkSecurityGroup.json" -TemplateParameterFile ".\appNetworkSecurityGroup.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\appVirtualMachine.json" -TemplateParameterFile ".\appVirtualMachine.parameters.json"



$resourceGroupName = $resourceGroupNameDB 

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dbAvailabilitySet.json" -TemplateParameterFile ".\dbAvailabilitySet.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dbNetworkSecurityGroup.json" -TemplateParameterFile ".\dbNetworkSecurityGroup.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dbVirtualMachine.json" -TemplateParameterFile ".\dbVirtualMachine.parameters.json"

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Incremental -TemplateFile ".\dbStorageAccount.json" -TemplateParameterFile ".\dbStorageAccount.parameters.json"


#>