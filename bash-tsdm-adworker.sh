echo "bash-tsdm-adworker sequence - by Alcatraz"

# Code definition
####################################################
AD_STATUS_CODE_SUCCESS=0
AD_STATUS_CODE_PERIOD_TOO_SHORT=-4
AD_STATUS_CODE_UNKNOWN=-3
AD_STATUS_CODE_CHEAT=-5
AD_STATUS_CODE_LOGIN_EXPIRED=-6
AD_STATUS_CODE_SERVER_HEAVY_LOAD=-7

# Ad worker [1]
####################################################
echo "Performing ad worker - 1"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=clickad" 2>&1)
if [[ "$ad_request" == "1" ]]; then
    echo -e "Adworker[1] -\e[1;32m Success \e[0m"
else
    if [[ "$ad_request" == *"必须与上一次间隔"* ]]; then
        echo -e "Adworker[1] -\e[1;31m Failed(Already got ad reward) \e[0m"
        exit $AD_STATUS_CODE_PERIOD_TOO_SHORT
    fi
    if [[ "$ad_request" == *"登录"* ]]; then
        echo -e "Adworker[1] -\e[1;31m Failed(login expired)\e[0m"
        exit $AD_STATUS_CODE_LOGIN_EXPIRED
    else
        echo -e "Adworker[1] -\e[1;31m Failed($ad_request)\e[0m"
        exit $AD_STATUS_CODE_UNKNOWN
    fi
fi

echo "Performing ad worker - 1 - sleep"
sleep 1s

# Ad worker [2]
####################################################
echo "Performing ad worker - 2"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=clickad" 2>&1)
if [[ "$ad_request" == "2" ]]; then
    echo -e "Adworker[2] -\e[1;32m Success \e[0m"
else
    echo -e "Adworker[2] -\e[1;31m Failed($ad_request)\e[0m"
    exit $AD_STATUS_CODE_UNKNOWN
fi

echo "Performing ad worker - 2 - sleep"
sleep 2s

# Ad worker [3]
####################################################
echo "Performing ad worker - 3"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=clickad" 2>&1)
if [[ "$ad_request" == "3" ]]; then
    echo -e "Adworker[3] -\e[1;32m Success \e[0m"
else
    echo -e "Adworker[3] -\e[1;31m Failed($ad_request)\e[0m"
    exit $AD_STATUS_CODE_UNKNOWN
fi

echo "Performing ad worker - 3 - sleep"
sleep 3s

# Ad worker [4]
####################################################
echo "Performing ad worker - 4"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=clickad" 2>&1)
if [[ "$ad_request" == "4" ]]; then
    echo -e "Adworker[4] -\e[1;32m Success \e[0m"
else
    echo -e "Adworker[4] -\e[1;31m Failed($ad_request)\e[0m"
    exit $AD_STATUS_CODE_UNKNOWN
fi

echo "Performing ad worker - 4 - sleep"
sleep 1s

# Ad worker [5]
####################################################
echo "Performing ad worker - 5"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=clickad" 2>&1)
if [[ "$ad_request" == "5" ]]; then
    echo -e "Adworker[5] -\e[1;32m Success \e[0m"
else
    echo -e "Adworker[5] -\e[1;31m Failed($ad_request)\e[0m"
    exit $AD_STATUS_CODE_UNKNOWN
fi

echo "Performing ad worker - 5 - sleep"
sleep 2s

# Ad worker [6]
####################################################
echo "Performing ad worker - 6"
ad_url="https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work"
ad_payload="act=clickad"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=clickad" 2>&1)
if [[ "$ad_request" == "6" ]]; then
    echo -e "Adworker[6] -\e[1;32m Success \e[0m"
else
    echo -e "Adworker[6] -\e[1;31m Failed($ad_request)\e[0m"
    exit $AD_STATUS_CODE_UNKNOWN
fi

# Ad worker cre
####################################################
echo "Performing ad worker - cre"
ad_request=$(curl -L -s -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "https://www.tsdm39.net/plugin.php?id=np_cliworkdz:work" -d "act=getcre" 2>&1)
if [[ "$ad_request" == *"您已经成功领取了奖励天使币"* ]]; then
    echo -e "Adworker[cre] -\e[1;32m Success \e[0m"
    exit $AD_STATUS_CODE_SUCCESS
fi

if [[ "$ad_request" == *"作弊"* ]]; then
    echo -e "Adworker[cre] -\e[1;31m Failed(anti cheat)\e[0m"
    exit $AD_STATUS_CODE_CHEAT
fi

if [[ "$ad_request" == *"请先登录再进行点击任务"* ]]; then
    echo -e "Adworker[cre] -\e[1;31m Failed(login expired)\e[0m"
    exit $AD_STATUS_CODE_LOGIN_EXPIRED
fi

if [[ "$ad_request" == *"服务器负荷较重"* ]]; then
    echo -e "Adworker[cre] -\e[1;31m Failed(server under heavy load)\e[0m"
    exit $AD_STATUS_CODE_SERVER_HEAVY_LOAD
fi

echo -e "Adworker[cre] -\e[1;31m Failed(unknown reason), response below\e[0m"
echo "$ad_request"
