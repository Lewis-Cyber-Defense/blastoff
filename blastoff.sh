#!/bin/bash

# Credit to John Hammond for base script and colors
# Define colors...
RED=`tput bold && tput setaf 1`
GREEN=`tput bold && tput setaf 2`
YELLOW=`tput bold && tput setaf 3`
BLUE=`tput bold && tput setaf 4`
NC=`tput sgr0`

function RED(){
	echo -e "\n${RED}${1}${NC}"
}
function GREEN(){
	echo -e "\n${GREEN}${1}${NC}"
}
function YELLOW(){
	echo -e "\n${YELLOW}${1}${NC}"
}
function BLUE(){
	echo -e "\n${BLUE}${1}${NC}"
}

# Testing if root...
if [ $EUID -ne 0 ]
then
	RED "[!] You must run this script as root!" && echo
	exit
fi

distro=$(uname -a | grep -i -c "kali") # distro check
if [ $distro -ne 1 ]
then 
	RED "[!] Kali Linux Not Detected - This script will not work with anything other than Kali!" && echo
	exit
fi

BLUE "[*] Pimping my kali..."
git clone https://github.com/Dewalt-arch/pimpmykali.git /home/kali/pimpmykali
cd /home/kali/pimpmykali
sudo ./pimpmykali.sh --all
cd -

BLUE "[*] Installing virtualenv..."
sudo apt install -y virtualenv

BLUE "[*] Installing pyftpdlib..."
sudo -u kali pip3 install -U pyftpdlib 

BLUE "[*] Installing xclip..."
sudo apt install -y xclip

BLUE "[*] Installing mingw-w64..."
sudo apt install -y mingw-w64

BLUE "[*] Installing terminator..."
sudo apt install -y terminator

BLUE "[*] Getting enum4linux-ng..."
git clone https://github.com/cddmp/enum4linux-ng.git /opt/enum4linux-ng

BLUE "[*] Installing rustscan..."
sudo apt install -y rustscan

BLUE "[*] Installing ffuf..."
sudo apt install -y ffuf

BLUE "[*] Installing feroxbuster..."
sudo apt install -y feroxbuster

BLUE "[*] Installing Bloodhound..."
sudo apt install -y bloodhound
sudo apt install -y neo4j
sudo -u kali pip3 install -U bloodhound

BLUE "[*] Installing seclists..."
sudo apt install -y seclists

BLUE "[*] Installing gdb..."
sudo apt install -y gdb

BLUE "[*] Installing pwndbg..."
git clone https://github.com/pwndbg/pwndbg /opt/pwndbg
chown -R kali:kali /opt/pwndbg
cd /opt/pwndbg
./setup.sh
cd -

BLUE "[*] Installing ghidra..."
sudo apt install -y ghidra

BLUE "[*] Installing pwntools and other binary exploitation tools..."
sudo -u kali pip3 install -U pwntools ropper
sudo gem install one_gadget seccomp-tools

BLUE "[*] Installing codium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo apt install codium -y

BLUE "[*] Installing docker..."
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo usermod -aG docker kali

BLUE "[*] Installing various cryptography tools..."
sudo apt install libgmp-dev libmpc-dev libmpfr-dev
sudo -u kali pip3 install PyCryptodome gmpy2 pwntools
sudo docker pull hyperreality/cryptohack:latest

BLUE "[*] Installing guessing tools..."
sudo apt install -y steghide
sudo gem install zsteg
sudo -u kali pip3 install -U stegoveritas
/home/kali/.local/bin/stegoveritas_install_deps

BLUE "[*] Installing some lighter forensics tools..."
sudo -u kali pip3 install -U oletools
sudo -u kali pip3 install -U pyshark
sudo apt install -y strace ltrace
wget https://didierstevens.com/files/software/DidierStevensSuite.zip -O /opt/DidierStevensSuite.zip
chown kali:kali /opt/DidierStevensSuite.zip

BLUE "[*] Installing Nim..."
sudo -u kali curl https://nim-lang.org/choosenim/init.sh -sSf | sh
echo 'export PATH=/home/kali/.nimble/bin:$PATH' >> /home/kali/.zshrc

YELLOW "Please read!"
BLUE "   The kali default shell is zsh, which has some minor differences from how bash works."
BLUE "   If you would like to swap your default shell to bash, please type Y, otherwise, type N"
read -n1 -p "   Please type Y or N : " userinput

case $userinput in
	y|Y) BLUE "[*] Swapping to bash..."; chsh -s /bin/bash kali ;;
	n|N) BLUE "[*] Sticking to zsh..." ;;
	*) RED "[!] Invalid response, keeping zsh...";;
esac

GREEN "[++] All done! Happy hacking! Remember to reboot and login again to see the full changes!"

