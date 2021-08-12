#!/usr/bin/env bash


DIR=$PWD/ZapReports
if [ ! -d "$DIR" ]; then
   sudo echo "Creating Report directory"
   sudo mkdir -p "$DIR"
   sudo chmod -R 777 "$DIR"
fi

CONTAINER_ID=$(docker run -v $PWD/ZapReports:/zap/reports -u zap -p 2375:2375 -d owasp/zap2docker-weekly zap.sh -daemon -port 2375  -host 127.0.0.1 -config api.disablekey=true -config scanner.attackOnStart=true -config view.mode=attack -config connection.dnsTtlSuccessfulQueries=-1 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true)

# the target URL for ZAP to scan
TARGET_URL=$1

docker exec $CONTAINER_ID zap-cli -p 2375 status -t 120 && docker exec $CONTAINER_ID zap-cli -p 2375 open-url $TARGET_URL

docker exec $CONTAINER_ID zap-cli -p 2375 spider $TARGET_URL
docker exec $CONTAINER_ID mkdir reports

docker exec $CONTAINER_ID zap-cli -p 2375 alerts
docker exec $CONTAINER_ID zap-cli -p 2375 report -o reports/ZAP_Report_Alert.html -f html


# docker logs [container ID or name]
divider==================================================================
printf "\n"
printf "$divider"
printf "ZAP-daemon log output follows"
printf "$divider"
printf "\n"

docker logs $CONTAINER_ID

docker stop $CONTAINER_ID
