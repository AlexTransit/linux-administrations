#PS1 = "\[\033[1;33;1;32m\]:\[\033[1;31m\]\w$ \[\033[0m\]\[\033[0m\]"
alias rap="ssh -oStrictHostKeyChecking=no $(ip neigh |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"

# (robo 00) - select wifi network 0 (AlexMobile) in robot 00 and connect to a robot via phone AP

function getroboip() {
roboip=$(ip neigh |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
}

aaa() {
getroboip
echo $roboip
}

robo() {
ssh vm$1s 'sudo wpa_cli select_network 0 && sudo wpa_cli enable_network 1 && sudo systemctl restart wg-quick@robot.service'
ssh -oStrictHostKeyChecking=no $(ip neigh |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
}

ba() {
echo -e "\033[32m ----- backup all from connected robot \033[0m"
list_files=(
/etc/hostname
/etc/hosts
/etc/wpa_supplicant/wpa_supplicant.conf
/etc/wireguard/robot.conf
/etc/systemd/journald.conf
/lib/systemd/system/fstrim.timer
/home/vmc/tele.hcl
/home/vmc/config.hcl
/home/vmc/local.hcl
/home/vmc/.ssh/config
/home/vmc/.ssh/id_ed25519
/home/vmc/.ssh/id_ed25519.pub
/home/vmc/vender-db/inventory/*
)
getroboip
ssh $roboip sudo tar cvf - "${list_files[@]}" > vm.tar
if [ $? != 0 ]; then
        echo -e "\033[41m ------ FAILLLLLL  ----------  \033[0m"
else
        echo -e "\033[32m ----- backup complete \033[0m"
fi
}

# restore all to connected robot
ra() {
echo -e "\033[32m ----- restore to connected \033[0m"
getroboip
echo $roboip
scp vm.tar $roboip:
ssh $roboip 'sudo tar xvf vm.tar -C /'
echo -e "\033[32m ----- restore complete \033[0m"
}
