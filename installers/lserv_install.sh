cash=$(basename "$SHELL")


echo "****Welcome to the 'List Services' installer****"
echo "Do you want install in all users? (y/n)"
read choose


if [ "${choose,,}" == y ];then
    if [ "$USER" == root ];then
        echo "Installing in all users..."
        echo "Sorry this function no work yet"
        sleep 2
    else
        echo "Please, for installing this tool in all users it's necessary be logged as root user"
    fi    
elif [ "${choose,,}" == n ]; then
    echo "Instaling only this user: $USER"
    sleep 2
#ROOT INSTALLATION
    if [ "$USER" == root ];then
    function_content=$(awk '/^function lserv\(\)/,/^}/' /root/."$cash"rc)
    if [ "$function_content" == "" ];then
               cat << 'EOF' >> /root/."$cash"rc
    function lserv() {
    action=$1
    if [[ "$action" == "-a" ]]; then
        respost="active"
    elif [[ "$action" == "-f" ]]; then
        respost="failed"
    else
        echo "Invalid status -f = Faileds, -a = Actives"
        return 1
    fi
    systemctl list-units --type=service --state="$respost"
    }
EOF
source /root/.cash
else
   echo "It's already installed"
fi
#ROOT INSTALLATION END   
else
#USER INSTALLATION
function_content=$(awk '/^function lserv\(\)/,/^}/' /home/"$USER"/."$cash"rc)       
if [ "$function_content" == "" ];then

        cat << 'EOF' >> /home/$USER/."$cash"rc
function lserv() {
    action=$1
    if [[ "$action" == "-a" ]]; then
        respost="active"
    elif [[ "$action" == "-f" ]]; then
        respost="failed"
    else
        echo "Invalid status -f = Faileds, -a = Actives"
        return 1
    fi
    systemctl list-units --type=service --state="$respost"
}
EOF
source /home/$USER/."$cash"rc

else

    echo "It's already installed"

fi
#USER INSTALLATION END
fi
    echo "Working, Try lserv -f or lserv -a"
    rm ./lserv_install.sh
else 
    echo "Try again with valid input"
   ./lserv.sh
fi

