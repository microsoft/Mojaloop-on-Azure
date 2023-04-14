# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Required variables
#namespace="$namespace"
#clusterName="$clusterName"
#resourceGroup="$resourceGroup"
#subscriptionId="$subscriptionId"
#urlMojaCluster_host="$urlMojaCluster_host"
mojarepo="http://mojaloophelm.azurecr.io/helm/mojaloop"
configURL="${serviceName}.configuration.azure-api.net"
paasMySQL_host=$(az mysql flexible-server list --resource-group $resourceGroup --query [0].fullyQualifiedDomainName -o tsv)
CentralLedgerBackendURL="http://central-ledger${urlMojaCluster_host}"
CentralSettlementsSBackendURL="http://central-settlement-service${urlMojaCluster_host}"
FSPIOPSBackendURL="http://central-settlements-service${urlMojaCluster_host}"
#MYSQL install
apk add mysql-client
#MySQL config
az config set extension.use_dynamic_install=yes_without_prompt
az aks install-cli;
cnf="/home/sql.conf"
cat >"$cnf" <<EOF
[client]
user="$dbMySQLAdministratorLogin"
password="$dbMySQLAdministratorLoginPassword"
EOF
#MySQL commands
cp ./mysqlscript.sql /home/sqlscript.sql
#microsoft doesnt work, maybe fixed in future
#az extension add --upgrade -n rdbms-connect
az mysql flexible-server firewall-rule create -r azureaccess --resource-group $resourceGroup --name $dbMySQLServerName --start-ip-address 0.0.0.0
az mysql flexible-server parameter  set --name init_connect --resource-group $resourceGroup --server $dbMySQLServerName --value "SET NAMES utf8mb4"
az mysql flexible-server parameter  set --name collation_server --resource-group $resourceGroup --server $dbMySQLServerName --value "utf8mb4_unicode_ci"
az mysql flexible-server parameter  set --name character_set_server --resource-group $resourceGroup --server $dbMySQLServerName --value "utf8mb4"
az mysql flexible-server parameter  set --name innodb_autoinc_lock_mode --resource-group $resourceGroup --server $dbMySQLServerName --value "2"
az mysql flexible-server parameter  set --name max_connections --resource-group $resourceGroup --server $dbMySQLServerName --value "100"
az mysql flexible-server parameter  set --name thread_cache_size --resource-group $resourceGroup --server $dbMySQLServerName --value "100"
az mysql flexible-server parameter  set --name require_secure_transport --resource-group $resourceGroup --server $dbMySQLServerName --value "OFF"
az mysql flexible-server restart -n $dbMySQLServerName --resource-group $resourceGroup
#az mysql flexible-server execute -n $dbMySQLServerName -u $dbMySQLAdministratorLogin -p $dbMySQLAdministratorLoginPassword -f "./mysqlscript.sql" --resource-group $resourceGroup
mysql --defaults-extra-file="$cnf" -h $paasMySQL_host -P 3306 < "/home/sqlscript.sql"
#Installing Helm cli
curl -o get_helm.sh "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
chmod 700 get_helm.sh
./get_helm.sh
# Add the required prereqs HELM repo's
helm repo add stable https://charts.helm.sh/stable
helm repo add incubator https://charts.helm.sh/incubator
helm repo add kiwigrid https://kiwigrid.github.io
helm repo add kokuwa https://kokuwaio.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add codecentric https://codecentric.github.io/helm-charts
# update the helm repo's after additions above
helm repo update 
# obtain AKS credentials
az aks get-credentials --admin --name $clusterName --resource-group $resourceGroup
# deploy Nginx ingress controller  (can add params to end where/when needed)
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace
# login helm azure registry
helm registry login mojaloophelm.azurecr.io --username mojaloophelm --password 0WGEuTDtNLvGJw3nS1Ekd/w=+tR1SaTe
# Finally - deploy mojaloop
helm --namespace $namespace install moja oci://mojaloophelm.azurecr.io/helm/mojaloop --version 13.1.0 --create-namespace --set global.paasmysql_host=$paasMySQL_host --set global.dnsdomain_host=$urlMojaCluster_host
# Deploy dfspid function
cat deployment.yaml | sed "s/{{namespace}}/$namespace/g" | sed "s/{{urlforcluster}}/$urlMojaCluster_hostdfs/g" | sed "s/{{sqlendpoint}}/$paasMySQL_host/g" | kubectl apply -f -
# Importing api
az apim api import -g $resourceGroup --service-name $serviceAPIName --path 'central-ledger' --service-url $CentralLedgerBackendURL --specification-path './CentralLedgerAPI.json' --specification-format OpenApiJson
az apim api import -g $resourceGroup --service-name $serviceAPIName --path 'central-settlements' --service-url $CentralSettlementsSBackendURL --specification-path './CentralSettlements.json' --specification-format OpenApiJson
#cleanup
#rm "$cnf"
# exporting ip
result=$(kubectl -n ingress-nginx get svc ingress-nginx-controller -o json)
echo $result | jq .status.loadBalancer.ingress | jq -c '{Result: map({dnsip: .ip})}' > $AZ_SCRIPTS_OUTPUT_PATH