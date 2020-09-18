#!/bin/bash

#######################
#    ^...^  `^...^´   #
#   / o,o \ / O,O \   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2019      #
#######################
# Toca da Coruja
# Códigos Binários, Funções de Onda e Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX
#
# Script de personalização para Xubuntu Core 18.04
# Versão 1.0
# Revisão 17 09 2020
# 
# DEPENDÊNCIAS:
# Pastas
# -applications (contém atalhos para programas)
# -tema (tema de borda das janelas)
# -fontes_ttf (fontes true type)
# -painel (configurações do painel)
# -apps (configurações de programas)
# -icones (ícones estilo Windows)


xtdc_insta_ppa(){
sudo apt update 
sudo apt dist-upgrade 	
#INSTALA PPA

#LISTA DE PPAS
xtdc_ppas=(
	rvm/smplayer
	nilarimogard/webupd8
	jtaylor/keepass
	maarten-baert/simplescreenrecorder
)
for ppas in "${xtdc_ppas[@]}"
	do
	sudo add-apt-repository -y ppa:"$ppas"
done

#LIMPA SOURCES.LIST
sudo sed -i.bkp -e '/^\s*#.*$/d' -e '/^\s*$/d' /etc/apt/sources.list
sudo sort /etc/apt/sources.list | uniq -u
sudo apt-get update
}


xtdc_insta_pkg(){
sudo apt-get update
sudo apt-get install -y curl
#curl https://rclone.org/install.sh | sudo bash
SISTEMA="xfswitch-plugin xfpanel-switch menulibre file-roller numlockx synaptic dconf-tools catfish thunar-archive-plugin p7zip-full rar unrar"
FERRAMENTAS="bleachbit gparted geany keepassx speedcrunch baobab gnome-system-tools gnome-system-monitor copyq"
MULTIMIDIA="audacity smplayer simplescreenrecorder"
INTERNET="transmission rclone-browser"
GRAFICOS="pinta eog evince shotwell"
IDIOMA="language-pack-pt language-pack-pt-base language-pack-gnome-pt language-pack-gnome-pt-base"
OUTROS="gvfs-backends gvfs-fuse samba-libs fusesmb"
for pkg in $SISTEMA $FERRAMENTAS $MULTIMIDIA $INTERNET $GRAFICOS $IDIOMA $OUTROS
do sudo apt install -y "$pkg" --no-install-recommends
done
}


xtdc_segunda(){
sudo sed '/^END LC_TIME.*/i first_weekday 2' -i /usr/share/i18n/locales/pt_BR; sudo locale-gen && xfce4-panel -r; }


xtdc_insta_painel(){
#PAINEL

xfce4-panel-profiles load./painel/xtdc20_painel.tar.bz2

xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-show -s false
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 0

}


xtdc_insta_chrome(){
#INSTALA PPA E CHROME COM AS EXTENSÕES
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable --no-install-recommends

#ATALHOS DO CHROME
sudo cat <<EOF | sudo tee /usr/share/applications/google-chrome.desktop
[Desktop Entry]
Version=1.0
Name=Google Chrome
GenericName=Web Browser
GenericName[pt_BR]=Navegador da Internet
# Gnome and KDE 3 uses Comment.
Comment=Access the Internet
Comment[pt_BR]=Acessar a internet
Exec=/usr/bin/google-chrome-stable %U
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Name[pt_BR]=Nova janela
Exec=/usr/bin/google-chrome-stable

[Desktop Action new-private-window]
Name=New Incognito Window
Name[pt_BR]=Nova janela anônima
Exec=/usr/bin/google-chrome-stable --incognito
EOF

sudo cat <<EOF | sudo tee /usr/share/applications/google-chrome-incognito.desktop
[Desktop Entry]
Version=1.0
Name=Google Chrome ANÔNIMO
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Navegador ANÔNIMO
Comment=Navegar na internet sem deixar rastros
Exec=/usr/bin/google-chrome-stable --incognito
Terminal=false
Icon=/usr/share/icons/xtdc/apps/google-chrome-incognito.svg
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;
Path=
StartupNotify=false
EOF


exts=(
	inst_chrome_ext emngkmlligggbbiioginlkphcmffbncb #AdBlock no YouTube™
	inst_chrome_ext cfhdojbkjhnklbpkdaibdccddilifddb #Adblock Plus - bloqueador de anúncios grátis
	inst_chrome_ext fngmhnnpilhplaeedifhccceomclgfbg #EditThisCookie
	inst_chrome_ext abjcfabbhafbcdfjoecdgepllmpfceif #Magic Actions for YouTube™
	inst_chrome_ext cmedhionkhpnakcndndgjdbohmhepckk #Os anúncios bloqueados para Youtube™
	inst_chrome_ext jfchnphgogjhineanplmfkofljiagjfb #Downloads
	inst_chrome_ext aapbdbdomjkkjkaonfhkkikfgjllcleb #Google Tradutor
)
for ext in "${exts[@]}"
	do
	preferences_dir_path="/opt/google/chrome/extensions"
	pref_file_path="$preferences_dir_path/$ext.json"
	upd_url="https://clients2.google.com/service/update2/crx"
	sudo mkdir -p "$preferences_dir_path"
	sudo chmod 777 -R "$preferences_dir_path"
	echo "{" > "$pref_file_path"
	echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
	echo "}" >> "$pref_file_path"
	echo Added \""$pref_file_path"\" ["$ext"]
	done

}


xtdc_insta_icones(){
sudo tar xf ./icones/xtdc.tar.gz -C /usr/share/icons
sudo tar xf ./icones/xtdcwin.tar.gz -C /usr/share/icons
sudo chmod 777 -R /usr/share/icons
sudo cp -r ./icones/xubuntu-logo.png /usr/share/pixmaps/xubuntu-logo.png
sudo cp -r ./icones/xubuntu-logo-menu.png /usr/share/pixmaps/xubuntu-logo-menu.png
sudo cp -r ./icones/xubuntu-logo.svg /usr/share/pixmaps/xubuntu-logo.svg
}


xtdc_insta_tema(){
sudo tar xf ./tema/xtdc_theme.tar.gz -C /usr/share/themes
sudo chmod 777 -R /usr/share/themes
xfconf-query -c xsettings -p /Net/IconThemeName -s xtdc
xfconf-query -c xfwm4 -p /general/theme -s xtdc
sudo cp -r ./painel/whiskermenu-1.rc "$HOME"/.config/xfce4/panel/whiskermenu-1.rc
sudo cp -r ./painel/xfce-applications.menu "$HOME"/.config/menus/xfce-applications.menu
xfce4-panel -r
}


xtdc_insta_ttf(){
sudo chmod 777 -R /usr/share/fonts/truetype
sudo tar xf ./fontes_ttf/xtdc_ttf.tar.gz -C /usr/share/fonts/truetype
}


xtdc_fundo_preto(){
sudo rm -rf /usr/share/backgrounds/xfce/*
sudo rm -rf /usr/share/xfce4/backdrops/*
sudo chmod 777 /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
sudo cat <<EOF | tee /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
[greeter]
background=#000000

theme-name=Ambiance
icon-theme-name=LoginIcons
font-name=Ubuntu 11
xft-antialias=true
xft-dpi=96
xft-hintstyle=slight
xft-rgba=rgb
indicators=~host;~spacer;~session;~language;~a11y;~clock;~power;
clock-format=%d %b, %H:%M
EOF
sudo chmod 777 /usr/share/lightdm/lightdm-gtk-greeter.conf.d/30_xubuntu.conf
sudo cat <<EOF | tee /usr/share/lightdm/lightdm-gtk-greeter.conf.d/30_xubuntu.conf
[greeter]
background=#000000

theme-name=Greybird
icon-theme-name=elementary-xfce-dark
font-name=Noto Sans 9
keyboard=onboard
screensaver-timeout=60
EOF
 }


xtdc_senha_min(){
sudo chmod 777 /etc/pam.d/common-password
sudo cp -r ./apps/common-password /etc/pam.d/common-password

}



xtdc_lista_func(){
grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' "${BASH_SOURCE[0]}"
}


xtdc_ex() { curl -sIL "$1" 2>&1 | awk "/^Location/ {print $2}" | tail -n1;}
