echo "bash-tsdm-checkin sequence - by Alcatraz"

# Code definition
####################################################
CHECKIN_STATUS_CODE_SUCCESS=0
CHECKIN_STATUS_CODE_ALREADY_CHECKED_IN=-2
CHECKIN_STATUS_CODE_HANDSHAKE_FAIL=-1
CHECKIN_STATUS_CODE_CHECKIN_FAIL_UNKNOWN=-3

# Checkin
####################################################
echo "Performing handshake to checkin url -> https://www.tsdm39.net/plugin.php?id=dsu_paulsign:sign"
checkin_handshake_request=$(curl -v -L -S -c cookie.txt -b cookie.txt -H "Connection: Keep-Alive" -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=dsu_paulsign:sign" 2>&1)
if [[ "$checkin_handshake_request" == *"200 OK"* ]]; then
    echo -e "Handshake -\e[1;32m Success \e[0m"
else
    echo -e "Handshake -\e[1;31m Failed \e[0m"
    exit $CHECKIN_STATUS_CODE_HANDSHAKE_FAIL
fi

if [[ "$checkin_handshake_request" == *"您今天已经签到过了"* ]]; then
    echo -e "Checkin -\e[1;31m Failed(Already checked in) \e[0m"
    exit $CHECKIN_STATUS_CODE_ALREADY_CHECKED_IN
fi

checkin_formhash_elem=$(echo "$checkin_handshake_request" | grep formhash | tail -n 1 | cut -d " " -f4)
checkin_formhash=${checkin_formhash_elem:7:8}
echo -e "Got formhash - $checkin_formhash"

# Checkin
####################################################
echo "Performing checkin"
checkin_url="https://www.tsdm39.net/plugin.php?id=dsu_paulsign:sign&operation=qiandao&infloat=1&sign_as=1&inajax=1"
checkin_payload="formhash=$checkin_formhash&qdxq=fd&qdmode=3&todaysay=&fastreply=1"
checkin_request=$(curl -v -L -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "$checkin_url" -d "$checkin_payload" 2>&1)

if [[ "$checkin_request" == *"200 OK"* ]]; then
    echo -e "Checkin -\e[1;32m Success \e[0m"
    exit $CHECKIN_STATUS_CODE_SUCCESS
else
    echo -e "Checkin -\e[1;31m Failed \e[0m"
    exit $CHECKIN_STATUS_CODE_CHECKIN_FAIL_UNKNOWN
fi
