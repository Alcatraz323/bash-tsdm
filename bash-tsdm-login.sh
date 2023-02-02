echo "bash-tsdm-login sequence - by Alcatraz"

# Code definition
####################################################
LOGIN_STATUS_CODE_SUCCESS=0
LOGIN_STATUS_CODE_ALREADY_LOGGED_IN=-2
LOGIN_STATUS_CODE_HANDSHAKE_FAIL=-1
LOGIN_STATUS_CODE_CAPTCHA_FAIL=-4
LOGIN_STATUS_CODE_LOGIN_FAIL_UNKNOWN=-3

# Please enter the account and password below
####################################################

account=""
password=""

####################################################

echo "=============================================="
echo "Parameters are set as below"
echo "Account => $account"
echo "Password => $password"
echo "=============================================="

# Handshake
####################################################

echo "Performing handshake to login url -> https://www.tsdm39.net/member.php?mod=logging&action=login"
login_handshake_request=$(curl -v -L -S -c cookie.txt -b cookie.txt -H "Connection: Keep-Alive" -A "Openwrt" --url "https://www.tsdm39.net/member.php?mod=logging&action=login" 2>&1)
if [[ "$login_handshake_request" == *"200 OK"* ]]; then
    echo -e "Handshake -\e[1;32m Success \e[0m"
else
    echo -e "Handshake -\e[1;31m Failed \e[0m"
    exit $LOGIN_STATUS_CODE_HANDSHAKE_FAIL
fi

if [[ "$login_handshake_request" == *"欢迎您回来"* ]]; then
    echo -e "Handshake -\e[1;32m Already logged in \e[0m"
    exit $LOGIN_STATUS_CODE_ALREADY_LOGGED_IN
fi

login_formhash_elem=$(echo "$login_handshake_request" | grep formhash | head -n 1 | cut -d " " -f4)
login_formhash=${login_formhash_elem:7:8}
echo -e "Got formhash - $login_formhash"

loginhash_elem=$(echo "$login_handshake_request" | grep loginhash | head -n 1 | cut -d "?" -f2 | cut -d "=" -f5)
loginhash=${loginhash_elem:0:5}
echo -e "Got loginhash - $loginhash"

# Captcha & IO
####################################################

echo "Performing captcha request"
captcha_request=$(curl -v -L -S -c cookie.txt -b cookie.txt -H "Connection: Keep-Alive" -A "Openwrt" -O --url "https://www.tsdm39.net/plugin.php?id=oracle:verify" 2>&1)
if [[ "$captcha_request" == *"200 OK"* ]]; then
    echo -e "Captcha request -\e[1;32m Success \e[0m"
else
    echo -e "Captcha request -\e[1;31m Failed \e[0m"
    exit -$LOGIN_STATUS_CODE_CAPTCHA_FAIL
fi
mv "plugin.php?id=oracle:verify" captcha.png

echo "Captcha image saved as captcha.png, pls check it and enter below"
read -p "Enter your captcha: " captcha_input
echo "=============================================="
echo "Captcha is set as below"
echo "Captcha => $captcha_input"
echo "=============================================="

# Login
####################################################
echo "Performing login"
login_url="https://www.tsdm39.net/member.php?mod=logging&action=login&loginsubmit=yes&handlekey=ls&loginhash=$loginhash"
login_payload="formhash=$login_formhash&referer=https%3A%2F%2Fwww.tsdm39.net%2Fforum.php%3Fmod%3Dviewthread%26tid%3D706954&loginfield=username&username=$account&password=$password&tsdm_verify=$captcha_input&questionid=0&answer=&cookietime=2592000&loginsubmit=true"
login_request=$(curl -v -L -S -c cookie.txt -b cookie.txt -A "Openwrt" --url "$login_url" -d "$login_payload" 2>&1)
if [[ "$login_request" == *"欢迎您回来"* ]]; then
    echo -e "Login -\e[1;32m Success \e[0m"
else
    echo -e "Login -\e[1;31m Failed \e[0m"
fi
