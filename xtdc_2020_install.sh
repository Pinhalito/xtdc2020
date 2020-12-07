#!/bin/bash
#######################
#    ^...^  `^...^´   #
#   / o,o \ / O,O \   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2020      #
#######################
# Toca das Corujas
# Códigos Binários, Funções de Onda e Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX

xtdc_ppa(){
xtdc_ppas=(
cubic-wizard/release
rvm/smplayer
jtaylor/keepass
maarten-baert/simplescreenrecorder
hluk/copyq
otto-kesselgulasch/gimp
mozillateam/ppa
webupd8team/y-ppa-manager
geany-dev/ppa
ubuntu-x-swat/updates
)

for ppas in "${xtdc_ppas[@]}"
do
sudo add-apt-repository -y ppa:"$ppas"
done

#LIMPA SOURCES.LIST
sudo sudo sed -i.bkp -e '/^\s*#.*$/d' -e '/^\s*$/d' /etc/apt/sources.list
sort /etc/apt/sources.list  uniq -u
sudo apt-get update
}


xtdc_pkg(){
sudo apt-get update
sudo apt-get install -y curl
curl https://rclone.org/install.sh | sudo bash

#GRUPOS DE PROGRAMAS
SISTEMA="xfpanel-switch menulibre file-roller synaptic catfish thunar-archive-plugin p7zip-full rar unrar tree zenity"
FERRAMENTAS="bleachbit geany speedcrunch baobab gnome-system-tools gnome-system-monitor gnome-disk-utility"
MULTIMIDIA="smplayer simplescreenrecorder"
INTERNET="transmission rclone-browser"
GRAFICOS="eog evince shotwell"
IDIOMA="language-pack-pt language-pack-pt-base language-pack-gnome-pt language-pack-gnome-pt-base"
OUTROS="gvfs-backends gvfs-fuse samba-libs fusesmb xclip"


for pkg in $SISTEMA $FERRAMENTAS $MULTIMIDIA $INTERNET $GRAFICOS $IDIOMA $OUTROS
do
sudo apt install -y "$pkg" --no-install-recommends
done

#ANYDESK
sudo wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | apt-key add -
sudo echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install -y anydesk
}


xtdc_chrome(){
#INSTALA PPA E CHROME COM AS EXTENSÕES
sudo wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable --no-install-recommends

#EXTENSÕES
exts=(
inst_chrome_ext cfhdojbkjhnklbpkdaibdccddilifddb #Adblock Plus - bloqueador de anúncios grátis
inst_chrome_ext cmedhionkhpnakcndndgjdbohmhepckk #Os anúncios bloqueados para Youtube
inst_chrome_ext ponfpcnoihfmfllpaingbgckeeldkhle #Configurações especiais para Youtube
inst_chrome_ext jfchnphgogjhineanplmfkofljiagjfb #Downloads
inst_chrome_ext aapbdbdomjkkjkaonfhkkikfgjllcleb #Google Tradutor
inst_chrome_ext felcaaldnbdncclmgdcncolpebgiejap #Planilhas
inst_chrome_ext aohghmighlieiainnegkcijnfilokake #Documentos
inst_chrome_ext ghbmnnjooekpmoecnnnilnnbdlolhkhi #Documentos OFFILNE
)
for ext in "${exts[@]}"
do
preferences_dir_path="/opt/google/chrome/extensions"
pref_file_path="$preferences_dir_path/$ext.json"
upd_url="https://clients2.google.com/service/update2/crx"
mkdir -m 777 "$preferences_dir_path"
echo "{" > "$pref_file_path"
echo "  \"external_update_url\": \"$upd_url\"" >> "$pref_file_path"
echo "}" >> "$pref_file_path"
echo "Adicionada extensão" \""$pref_file_path"\" ["$ext"]
done
}


xtdc_limpa_pkg(){
sudo apt-get purge -y apport apport-symptoms yelp yelp-xsl snapd aspell
sudo apt-get autoremove
sudo apt-get autoclean
sudo rm -rf /var/cache/apt/archives/*.deb
}


xtdc_limpa_atalhos(){
sudo rm -rf /usr/share/xubuntu/applications/xfhelp4.desktop
atalhos=(/usr/share/applications/*.desktop)
for ata in "${atalhos[@]}"
do
sudo sed -i "$ { s/^.*$/&\n\NoDisplay\=true/ }" "$ata"
sudo sed -i '/Name\[/d' "$ata"
sudo sed -i '/Comment\[/d' "$ata"
sudo sed -i '/Icon\[/d' "$ata"
sudo sed -i '/Keywords\[/d' "$ata"
sudo sed -i '/GenericName/d' "$ata"
#LIMPA LINHA VAZIAS
sudo sed -i '/^$/d' "$ata"
#LIMPA COMENTÁRIOS
sudo sed -i '/^[[:blank:]]*#/d;s/#.*//' "$ata"
done
}


xtdc_atalhos(){
#ATALHOS DO CHROME
sudo cat <<EOF > /usr/share/applications/google-chrome.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Name=Google Chrome
Comment=Acesse a Internet
Exec=/usr/bin/google-chrome-stable %U
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=Nova janela
Exec=/usr/bin/google-chrome-stable

[Desktop Action new-private-window]
Name=Nova janela anônima
Exec=/usr/bin/google-chrome-stable --incognito
EOF

sudo cat <<EOF > /usr/share/applications/google-chrome-incognito.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Name=Google Chrome ANÔNIMO
Comment=Navegar na internet sem deixar rastros
Exec=/usr/bin/google-chrome-stable --incognito
Terminal=false
Icon=/usr/share/icons/xtdc_2020_icons/apps/google-chrome-incognito.svg
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;
Path=
StartupNotify=false
EOF

#RCLONE BROWSER
sudo cat <<EOF > /usr/share/applications/rclone-browser.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Rclone Browser
Comment=Gerenciador de contas Dropbox, Google Drive
Exec=/usr/bin/rclone-browser
Icon=rclone-browser.png
Terminal=false
Type=Application
Categories=Network
StartupNotify=false 
EOF

#TRANSMISSION
sudo cat <<EOF > /usr/share/applications/transmission-gtk.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Transmission
Comment=Cliente BitTorrent
Exec=transmission-gtk %U
Icon=transmission
Terminal=false
TryExec=transmission-gtk
Type=Application
StartupNotify=true
MimeType=application/x-bittorrent;x-scheme-handler/magnet;
Categories=Network;
X-AppInstall-Keywords=torrent
Actions=Pause;Minimize;
EOF

#SMPLAYER
sudo cat <<EOF > /usr/share/applications/smplayer.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Type=Application
Name=SMPlayer
Comment=Player de vídeo e música
Icon=smplayer
Exec=smplayer %U
Actions=
MimeType=audio/ac3;audio/mp4;audio/mpeg;audio/vnd.rn-realaudio;audio/vorbis;audio/x-adpcm;audio/x-matroska;audio/x-mp2;audio/x-mp3;audio/x-ms-wma;audio/x-vorbis;audio/x-wav;audio/mpegurl;audio/x-mpegurl;audio/x-pn-realaudio;audio/x-scpls;audio/aac;audio/flac;audio/ogg;video/avi;video/mp4;video/flv;video/mpeg;video/quicktime;video/vnd.rn-realvideo;video/x-matroska;video/x-ms-asf;video/x-msvideo;video/x-ms-wmv;video/x-ogm+ogg;video/x-theora;video/webm;
Categories=AudioVideo;
Keywords=vídeo;música;filme;áudio;player;
EOF

#SIMPLESCREENRECORDER
sudo cat <<EOF > /usr/share/applications/simplescreenrecorder.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Type=Application
Name=Gravador da área de trabalho
Comment=Grave sua área de trabalho
Icon=simplescreenrecorder
Exec=simplescreenrecorder --logfile
Terminal=false
Categories=AudioVideo;
Keywords=gravar;tela;screen recorder;screencast;
EOF

#VOLUME
sudo cat <<EOF > /usr/share/applications/pavucontrol.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Encoding=UTF-8
Name=Controle de Volume
Comment=Controle de Volume
Exec=pavucontrol
Icon=multimedia-volume-control
StartupNotify=true
Type=Application
Categories=AudioVideo;Audio;Mixer;GTK;
Keywords=volume;som;áudio;
EOF

#EVINCE PDF
sudo cat <<EOF > /usr/share/applications/evince.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Visualizador de documentos PDF
Comment=Visualizador de documentos PDF
TryExec=evince
Exec=evince %U
StartupNotify=true
Terminal=false
Type=Application
Icon=evince
Categories=Office
MimeType=application/pdf;application/x-bzpdf;application/x-gzpdf;application/x-xzpdf;application/x-ext-pdf;application/postscript;application/x-bzpostscript;application/x-gzpostscript;image/x-eps;image/x-bzeps;image/x-gzeps;application/x-ext-ps;application/x-ext-eps;application/illustrator;application/x-dvi;application/x-bzdvi;application/x-gzdvi;application/x-ext-dvi;image/vnd.djvu+multipage;application/x-ext-djv;application/x-ext-djvu;image/tiff;application/x-cbr;application/x-cbz;application/x-cb7;application/x-cbt;application/x-ext-cbr;application/x-ext-cbz;application/vnd.comicbook+zip;application/x-ext-cb7;application/x-ext-cbt;application/oxps;application/vnd.ms-xpsdocument;
X-Ubuntu-Gettext-Domain=evince
Keywords=pdf;adobe;documento;
EOF

#GEANY
sudo cat <<EOF > /usr/share/applications/geany.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Type=Application
Name=Geany
Comment=Editor de texto simples (Bloco de Notas)
Exec=geany %F
Icon=/usr/share/icons/xtdc_2020_icons/apps/geany.png
Terminal=false
Categories=Office
MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
StartupNotify=true
Keywords=Text;Editor;bloco;notas;
EOF

#VISUALIZADOR DE IMAGENS
sudo cat <<EOF > /usr/share/applications/eog.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Visualizador de imagens
Comment=Visualizador de imagens
TryExec=eog
Exec=eog %U
Icon=eog
StartupNotify=true
Terminal=false
Type=Application
Categories=Graphics
MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/pjpeg;image/png;image/tiff;image/x-bmp;image/x-gray;image/x-icb;image/x-ico;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-xbitmap;image/x-xpixmap;image/x-pcx;image/svg+xml;image/svg+xml-compressed;image/vnd.wap.wbmp;
Keywords=imagem;fotos;
EOF

#SHOTWELL
sudo cat <<EOF > /usr/share/applications/shotwell.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Gerenciador de fotos
Comment=Gerencia suas fotos, álbuns, etiquetas
Keywords=album;foto;camera;cameras;
Exec=shotwell %U
Icon=shotwell
Terminal=false
Type=Application
MimeType=x-content/image-dcf;
Categories=Graphics;
X-GIO-NoFuse=true
EOF

#THUNAR
sudo cat <<EOF > /usr/share/applications/thunar.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Gerenciador de Arquivos
Comment=Gerenciador de Arquivos (Explorer)
Exec=thunar %F
Icon=Thunar
Terminal=false
StartupNotify=true
Type=Application
Categories=Utility;
Keywords=arquivo;gerenciador;explorer;thunar;
EOF

#BLEACHBIT
sudo cat <<EOF > /usr/share/applications/bleachbit.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Type=Application
Name=Limpeza do sistema
Comment=Limpeza do sistema
TryExec=bleachbit
Exec=bleachbit
Icon=bleachbit
Categories=GTK;System;
Keywords=limpeza;limpa;clean;performances;free;privacy;
StartupNotify=true
EOF

#BLEACHBIT ROOT
sudo cat <<EOF > /usr/share/applications/bleachbit-root.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Type=Application
Name=Limpeza do sistema (como ROOT)
Comment=Limpeza do sistema (como ROOT)
TryExec=pkexec
Exec=pkexec bleachbit
Icon=bleachbit
Categories=GTK;System;
Keywords=limpeza;limpa;clean;performances;free;privacy;
StartupNotify=true
EOF

#GOOGLE PLANILHAS
sudo cat <<EOF > /usr/share/applications/chrome-felcaaldnbdncclmgdcncolpebgiejap-Default.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Terminal=false
Type=Application
Name=Planilhas (Excel Online)
Comment=Editor online de planilhas (Google Planilhas)
Exec=/opt/google/chrome/google-chrome --profile-directory=Default --app-id=felcaaldnbdncclmgdcncolpebgiejap
Icon=/usr/share/icons/xtdc_2020_icons/apps/excel.png
StartupWMClass=crx_felcaaldnbdncclmgdcncolpebgiejap
Categories=Office;
Keywords=excel;planilha;xls;
EOF

#GOOGLE DOCUMENTOS
sudo cat <<EOF > /usr/share/applications/chrome-aohghmighlieiainnegkcijnfilokake-Default.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Terminal=false
Type=Application
Name=Documentos (Word Online)
Comment=Editor online de documentos (Google Docs)
Exec=/opt/google/chrome/google-chrome --profile-directory=Default --app-id=aohghmighlieiainnegkcijnfilokake
Icon=/usr/share/icons/xtdc_2020_icons/apps/word.png
StartupWMClass=crx_aohghmighlieiainnegkcijnfilokake
Categories=Office;
Keywords=word;doc;Text;Editor;
EOF

#CALCULADORA
sudo cat <<EOF > /usr/share/applications/speedcrunch.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Type=Application
Name=Calculadora
Exec=speedcrunch
Icon=speedcrunch
Comment=Calculadora
Categories=Utility;
EOF

#CATFISH
sudo cat <<EOF > /usr/share/applications/catfish.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Procurar Arquivos
Comment=Procurar Arquivos
Keywords=files;find;locate;lookup;search;
Categories=GNOME;GTK;Utility;
Exec=/usr/bin/catfish
Icon=catfish
Terminal=false
Type=Application
EOF

#MONITOR
sudo cat <<EOF > /usr/share/applications/xfce-display-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Monitor
Comment=Monitor
Exec=xfce4-display-settings
Icon=monitor
Terminal=false
Type=Application
Categories=Settings;
StartupNotify=true
OnlyShowIn=XFCE;
X-XfcePluggable=true
X-XfceHelpPage=display
EOF

#TERMINAL
sudo cat <<EOF > /usr/share/applications/xfce4-terminal.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Terminal
Comment=Usar a linha de comando
Exec=xfce4-terminal
Icon=utilities-terminal
Terminal=false
Type=Application
StartupNotify=true
Categories=Utility;
EOF

#ZIPS
sudo cat <<EOF > /usr/share/applications/file-roller.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Gerenciador de arquivos compactados (Winzip)
Comment=Gerenciador de arquivos zip, rar, 7z
Keywords=zip;tar;extract;unpack;
TryExec=file-roller
Exec=file-roller %U
StartupNotify=true
Terminal=false
Type=Application
Icon=file-roller
Categories=Utility
NotShowIn=KDE;
MimeType=application/bzip2;application/gzip;application/vnd.android.package-archive;application/vnd.ms-cab-compressed;application/vnd.debian.binary-package;application/x-7z-compressed;application/x-7z-compressed-tar;application/x-ace;application/x-alz;application/x-ar;application/x-archive;application/x-arj;application/x-brotli;application/x-bzip-brotli-tar;application/x-bzip;application/x-bzip-compressed-tar;application/x-bzip1;application/x-bzip1-compressed-tar;application/x-cabinet;application/x-cd-image;application/x-compress;application/x-compressed-tar;application/x-cpio;application/x-chrome-extension;application/x-deb;application/x-ear;application/x-ms-dos-executable;application/x-gtar;application/x-gzip;application/x-gzpostscript;application/x-java-archive;application/x-lha;application/x-lhz;application/x-lrzip;application/x-lrzip-compressed-tar;application/x-lz4;application/x-lzip;application/x-lzip-compressed-tar;application/x-lzma;application/x-lzma-compressed-tar;application/x-lzop;application/x-lz4-compressed-tar;application/x-ms-wim;application/x-rar;application/x-rar-compressed;application/x-rpm;application/x-source-rpm;application/x-rzip;application/x-rzip-compressed-tar;application/x-tar;application/x-tarz;application/x-tzo;application/x-stuffit;application/x-war;application/x-xar;application/x-xz;application/x-xz-compressed-tar;application/x-zip;application/x-zip-compressed;application/x-zstd-compressed-tar;application/x-zoo;application/zip;application/zstd;
EOF

#APARÊNCIA
sudo cat <<EOF > /usr/share/applications/xfce-ui-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Aparência
Comment=Configuração de ícones e temas
Exec=xfce4-appearance-settings
Icon=preferences-desktop-theme
Terminal=false
Type=Application
Categories=Settings;
StartupNotify=true
OnlyShowIn=XFCE;
X-XfcePluggable=true
X-XfceHelpPage=appearance
EOF

#DRIVERS ADICIONAIS
sudo cat <<EOF > /usr/share/applications/software-properties-drivers.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Keywords=Drivers;
Exec=/usr/bin/software-properties-gtk --open-tab=4
Icon=jockey
Terminal=false
Type=Application
NotShowIn=KDE;
Categories=Settings;
X-AppStream-Ignore=true
Name=Drivers Adicionais
Comment=Drivers Adicionais
X-AppStream-Ignore=true
X-Ubuntu-Gettext-Domain=software-properties
EOF

#TIPOS DE ARQUIVOS
sudo cat <<EOF > /usr/share/applications/xfce4-mime-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Name=Editor de tipos de arquivos
Comment=Associe programas com tipos de arquivos
Exec=xfce4-mime-settings
Icon=application-x-executable
Terminal=false
Type=Application
Categories=Settings;
StartupNotify=true
OnlyShowIn=XFCE;
X-XfcePluggable=true
EOF

#OPÇÕES DE ENERGIA
sudo cat <<EOF > /usr/share/applications/xfce4-power-manager-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Name=Opções de energia
Comment=Opções de energia
Exec=xfce4-power-manager-settings
Icon=xfce4-power-manager-settings
Terminal=false
Type=Application
Categories=Settings;
NotShowIn=GNOME;KDE;Unity;
StartupNotify=true
X-XfcePluggable=true
X-XfceHelpComponent=xfce4-power-manager
X-XfceHelpPage=start
EOF

#MOUSE
sudo cat <<EOF > /usr/share/applications/xfce-mouse-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Name=Mouse
Comment=Mouse
Exec=xfce4-mouse-settings
Icon=preferences-desktop-peripherals
Terminal=false
Type=Application
Categories=Settings;
StartupNotify=true
OnlyShowIn=XFCE;
X-XfcePluggable=true
X-XfceHelpPage=mouse
EOF

#SESSÂO
sudo cat <<EOF > /usr/share/applications/xfce-session-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Inicialização e sessão
Comment=Inicialização e sessão
Exec=xfce4-session-settings
Icon=xfce4-session
Terminal=false
StartupNotify=true
Type=Application
Categories=Settings;
OnlyShowIn=XFCE;
X-XfcePluggable=true
X-XfceHelpComponent=xfce4-session
X-XfceHelpPage=preferences
EOF

#TECLADO
sudo cat <<EOF > /usr/share/applications/xfce-keyboard-settings.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Version=1.0
Name=Teclado
Comment=Teclado
Exec=xfce4-keyboard-settings
Icon=preferences-desktop-keyboard
Terminal=false
Type=Application
Categories=Settings;
StartupNotify=true
OnlyShowIn=XFCE;
X-XfcePluggable=true
X-XfceHelpPage=keyboard
EOF

#GPARTED
sudo cat <<EOF > /usr/share/applications/gparted.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=GParted
X-GNOME-FullName=GParted 
Comment=Editor de partições e discos
Exec=/usr/sbin/gparted %f
Icon=gparted
Terminal=false
Type=Application
Categories=System;
Keywords=Partition;
StartupNotify=true
EOF

#SCREENSAVER
sudo cat <<EOF > /usr/share/applications/xfce4-screensaver-preferences.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Descanso de tela
Comment=Descanso de tela
Icon=preferences-desktop-screensaver
Exec=xfce4-screensaver-preferences
Terminal=false
Type=Application
Categories=Settings;
OnlyShowIn=XFCE;
StartupNotify=true
X-XFCE-Bugzilla-Bugzilla=XFCE
X-XFCE-Bugzilla-Product=xfce4-screensaver
X-XFCE-Bugzilla-Component=general
X-XfcePluggable=true
X-XfceHelpPage=screensaver
EOF

#NOTIFICAÇÕES
sudo cat <<EOF > /usr/share/applications/xfce4-notifyd-config.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Notificações
Comment=Notificações
Exec=xfce4-notifyd-config
Icon=xfce4-notifyd
Terminal=false
StartupNotify=true
Type=Application
OnlyShowIn=XFCE;
Categories=Settings;
X-XfcePluggable=true
X-XfceHelpComponent=notifyd
X-XfceHelpPage=start
Keywords=Notificações
EOF

#USUÁRIOS E GRUPOS
sudo cat <<EOF > /usr/share/applications/users.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Usuários e grupos
Comment=Adicionar usuários ou grupos
Exec=users-admin
Icon=config-users
Terminal=false
Type=Application
Categories=System;
StartupNotify=true
X-Ubuntu-Gettext-Domain=gnome-system-tools
EOF

#BAOBAB
sudo cat <<EOF > /usr/share/applications/org.gnome.baobab.desktop
[Desktop Entry]
XTDC_TRADUZIDO=SIM
Name=Analisador de uso de disco
Comment=Verifique o tamanho de pastas e o espaço disponível em disco
Keywords=armazenamento;espaço;limpeza;
TryExec=baobab
Exec=baobab
Icon=baobab
Terminal=false
Type=Application
StartupNotify=true
MimeType=inode/directory;
Categories=Utility
DBusActivatable=true
EOF

#ANYFILE
sudo cat <<EOF > /usr/share/applications/anydesk.desktop
[Desktop Entry]
Type=Application
Name=AnyDesk
Exec=/usr/bin/anydesk %u
Icon=anydesk
Terminal=false
TryExec=anydesk
Categories=System;
MimeType=x-scheme-handler/anydesk;
EOF

#TIPOS DE ARQUIVOS E PROGRAMAS
sudo cat <<EOF > /usr/share/applications/defaults.list
[Default Applications]
application/csv=google-chrome.desktop
application/excel=google-chrome.desktop
application/msexcel=google-chrome.desktop
application/msword=google-chrome.desktop
application/ogg=smplayer.desktop
application/pdf=evince.desktop
application/postscript=evince.desktop
application/rtf=google-chrome.desktop
application/tab-separated-values=google-chrome.desktop
application/vnd.ms-xpsdocument=evince.desktop
application/x-ar=file-roller.desktop
application/x-arj=file-roller.desktop
application/x-bzip-compressed-tar=file-roller.desktop
application/x-bzip=file-roller.desktop
application/x-compressed-tar=file-roller.desktop
application/x-compress=file-roller.desktop
application/x-dos_ms_excel=google-chrome.desktop
application/x-excel=google-chrome.desktop
application/x-extension-m4a=smplayer.desktop
application/x-extension-mp4=smplayer.desktop
application/x-flac=smplayer.desktop
application/x-gtar=file-roller.desktop
application/x-gzip=file-roller.desktop
application/xhtml+xml=google-chrome.desktop
application/xhtml+xml=google-chrome.desktop
application/xhtml_xml=google-chrome.desktop
application/xls=google-chrome.desktop
application/x-matroska=smplayer.desktop
application/xml=google-chrome.desktop
application/x-mps=google-chrome.desktop
application/x-ms-excel=google-chrome.desktop
application/x-msexcel=google-chrome.desktop
application/x-ogg=smplayer.desktop
application/x-perl=geany.desktop
application/x-rar-compressed=file-roller.desktop
application/x-rar=file-roller.desktop
application/x-tar=file-roller.desktop
application/x-war=file-roller.desktop
application/x-xls=google-chrome.desktop
application/x-zip-compressed=file-roller.desktop
application/x-zip=file-roller.desktop
application/x-zoo=file-roller.desktop
application/zip=file-roller.desktop
audio/3gpp=smplayer.desktop
audio/ac3=smplayer.desktop
audio/basic=smplayer.desktop
audio/flac=smplayer.desktop
audio/midi=smplayer.desktop
audio/mp4=smplayer.desktop
audio/mpeg=smplayer.desktop
audio/mpegurl=smplayer.desktop
audio/ogg=smplayer.desktop
audio/x-ape=smplayer.desktop
audio/x-flac=smplayer.desktop
audio/x-gsm=smplayer.desktop
audio/x-it=smplayer.desktop
audio/x-m4a=smplayer.desktop
audio/x-matroska=smplayer.desktop
audio/x-mod=smplayer.desktop
audio/x-mp3=smplayer.desktop
audio/x-mpeg=smplayer.desktop
audio/x-mpegurl=smplayer.desktop
audio/x-ms-asf=smplayer.desktop
audio/x-ms-asx=smplayer.desktop
audio/x-ms-wax=smplayer.desktop
audio/x-ms-wma=smplayer.desktop
audio/x-musepack=smplayer.desktop
audio/x-pn-aiff=smplayer.desktop
audio/x-pn-au=smplayer.desktop
audio/x-pn-wav=smplayer.desktop
audio/x-pn-windows-acm=smplayer.desktop
audio/x-real-audio=smplayer.desktop
audio/x-realaudio=smplayer.desktop
audio/x-vorbis+ogg=smplayer.desktop
audio/x-vorbis=smplayer.desktop
audio/x-wavpack=smplayer.desktop
audio/x-wav=smplayer.desktop
audio/x-xm=smplayer.desktop
image/bmp=eog.desktop
image/gif=eog.desktop
image/jpeg=eog.desktop
image/jpg=eog.desktop
image/png=eog.desktop
image/x-bmp=eog.desktop
image/x-ico=eog.desktop
image/x-png=eog.desktop
image/x-portable-anymap=eog.desktop
image/x-portable-bitmap=eog.desktop
image/x-portable-graymap=eog.desktop
image/x-portable-pixmap=eog.desktop
image/x-xbitmap=eog.desktop
image/x-xpixmap=eog.desktop
inode/directory=thunar.desktop
multipart/x-zip=file-roller.desktop
text/comma-separated-values=geany.desktop
text/csv=geany.desktop
text/html=google-chrome.desktop;geany.desktop;
text/mathml=geany.desktop
text/plain=geany.desktop
text/richtext=google-chrome.desktop
text/rtf=google-chrome.desktop
text/spreadsheet=google-chrome.desktop
text/tab-separated-values=google-chrome.desktop
text/x-chdr=geany.desktop
text/x-comma-separated-values=google-chrome.desktop
text/x-csrc=geany.desktop
text/x-dtd=geany.desktop
text/xml=geany.desktop
text/x-python=geany.desktop
text/x-sql=geany.desktop
video/3gpp=smplayer.desktop
video/flv=smplayer.desktop
video/mp2t=smplayer.desktop
video/mp4=smplayer.desktop
video/mp4v-es=smplayer.desktop
video/mpeg=smplayer.desktop
video/msvideo=smplayer.desktop
video/ogg=smplayer.desktop
video/quicktime=smplayer.desktop
video/vivo=smplayer.desktop
video/vnd.divx=smplayer.desktop
video/webm=smplayer.desktop
video/x-anim=smplayer.desktop
video/x-avi=smplayer.desktop
video/x-flc=smplayer.desktop
video/x-flic=smplayer.desktop
video/x-fli=smplayer.desktop
video/x-flv=smplayer.desktop
video/x-m4v=smplayer.desktop
video/x-matroska=smplayer.desktop
video/x-mpeg=smplayer.desktop
video/x-ms-asf=smplayer.desktop
video/x-ms-asx=smplayer.desktop
video/x-msvideo=smplayer.desktop
video/x-ms-wm=smplayer.desktop
video/x-ms-wmv=smplayer.desktop
video/x-ms-wmx=smplayer.desktop
video/x-ms-wvx=smplayer.desktop
video/x-nsv=smplayer.desktop
video/x-ogm+ogg=smplayer.desktop
x-content/audio-cdda=smplayer.desktop
x-content/audio-dvd=smplayer.desktop
x-content/audio-player=smplayer.desktop
x-content/image-dcf=shotwell.desktop
x-content/image-picturecd=shotwell.desktop
x-content/video-dvd=smplayer.desktop
x-content/video-svcd=smplayer.desktop
x-content/video-vcd=smplayer.desktop
x-scheme-handler/ftp=google-chrome.desktop
x-scheme-handler/http=google-chrome.desktop
x-scheme-handler/https=google-chrome.desktop
zz-application/zz-winassoc-xls=google-chrome.desktop
EOF
}


xtdc_tema(){
#BAIXANDO PACOTES
cd "/xtdc_2020_files" || exit
xtdc_gred http://bit.do/xtdc_2020_icons xtdc_2020_icons.tar.gz;
xtdc_gred http://bit.do/xtdc_2020_theme xtdc_2020_theme.tar.gz;
xtdc_gred http://bit.do/xtdc_2020_ttf xtdc_2020_ttf.tar.gz;
xtdc_gred http://bit.do/xtdc_2020_painel xtdc_2020_painel.tar.gz;
xtdc_gred http://bit.do/xtdc_2020_skel xtdc_2020_skel.tar.gz;

#ÍCONES
tar xf ./xtdc_2020_icons.tar.gz -C /usr/share/icons
sudo chmod 777 -R /usr/share/icons
cp -f /usr/share/icons/xtdc_2020_icons/meus_icones/xubuntu-logo.png /usr/share/pixmaps/xubuntu-logo.png
cp -f /usr/share/icons/xtdc_2020_icons/meus_icones/xubuntu-logo-menu.png /usr/share/pixmaps/xubuntu-logo-menu.png
cp -f /usr/share/icons/xtdc_2020_icons/meus_icones/xubuntu-logo.svg /usr/share/pixmaps/xubuntu-logo.svg

#TEMA
tar xf ./xtdc_2020_theme.tar.gz -C /usr/share/themes
sudo chmod 777 -R /usr/share/themes

#FONTES TRUE TYPE
sudo chmod 777 -R /usr/share/fonts/truetype
tar xf ./xtdc_2020_ttf.tar.gz -C /usr/share/fonts/truetype

#PAINEL
cp -r ./xtdc_2020_painel.tar.gz /usr/share/xfce4-panel-profiles/layouts/

#SKEL
mv /etc/skel /etc/skel_bkp
tar xf ./xtdc_2020_skel.tar.gz -C /etc

#SEGUNDA COMO PRIMEIRO DIA
sudo sed '/^END LC_TIME.*/i first_weekday 2' -i /usr/share/i18n/locales/pt_BR
locale-gen

#APAGA IMAGENS DE FUNDO E COLOCA FUNDO PRETO NA TELA DE LOGIN
sudo rm -rf /usr/share/backgrounds/xfce/*
sudo rm -rf /usr/share/xfce4/backdrops/*

sudo chmod 777 /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
sudo cat <<EOF > /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
[greeter]
background=#000000
theme-name=Ambiance
icon-theme-name=LoginIcons
font-name=Ubuntu 11
indicators=~host;~spacer;~session;~language;~a11y;~clock;~power;
clock-format=%d %b, %H:%M
EOF

sudo sudo chmod 777 /usr/share/lightdm/lightdm-gtk-greeter.conf.d/30_xubuntu.conf
sudo cat <<EOF > /usr/share/lightdm/lightdm-gtk-greeter.conf.d/30_xubuntu.conf
[greeter]
background=#000000
theme-name=Greybird
font-name=Noto Sans 9
keyboard=onboard
screensaver-timeout=60
EOF

#APAGA ARQUIVOS BAIXADOS
sudo rm -rf /xtdc_2020_files/*.tar.gz
}


xtdc_gred(){
aberto=$(curl -sIL "$1" 2>&1 | awk '/^Location/ {print $2}' | tail -n1);
reduzido=$(echo "$aberto" | cut -d'/' -f 6)
#curl -L -o "$2" "https://drive.google.com/uc?export=download&id=""$reduzido"
wget --no-check-certificate "https://docs.google.com/uc?export=download&id=""$reduzido" -O "$2"
}


xtdc_colors(){
NC='\e[0m'  
#regular colors #bold            #underline       #background    #high intensity  #boldhighint      #highintensityback
bla='\e[0;30m'; bbla='\e[1;30m'; ubla='\e[4;30m'; obla='\e[40m'; ibla='\e[0;90m'; bibla='\e[1;90m'; oibla='\e[0;100m';
red='\e[0;31m'; bred='\e[1;31m'; ured='\e[4;31m'; ored='\e[41m'; ired='\e[0;91m'; bired='\e[1;91m'; oired='\e[0;101m';
gre='\e[0;32m'; bgre='\e[1;32m'; ugre='\e[4;32m'; ogre='\e[42m'; igre='\e[0;92m'; bigre='\e[1;92m'; oigre='\e[0;102m';
yel='\e[0;33m'; byel='\e[1;33m'; uyel='\e[4;33m'; oyel='\e[43m'; iyel='\e[0;93m'; biyel='\e[1;93m'; oiyel='\e[0;103m';
blu='\e[0;34m'; bblu='\e[1;34m'; ublu='\e[4;34m'; oblu='\e[44m'; iblu='\e[0;94m'; biblu='\e[1;94m'; oiblu='\e[0;104m';
pur='\e[0;35m'; bpur='\e[1;35m'; upur='\e[4;35m'; opur='\e[45m'; ipur='\e[0;95m'; bipur='\e[1;95m'; oipur='\e[0;105m';
cya='\e[0;36m'; bcya='\e[1;36m'; ucya='\e[4;36m'; ocya='\e[46m'; icya='\e[0;96m'; bicya='\e[1;96m'; oicya='\e[0;106m';
whi='\e[0;37m'; bwhi='\e[1;37m'; uwhi='\e[4;37m'; owhi='\e[47m'; iwhi='\e[0;97m'; biwhi='\e[1;97m'; oiwhi='\e[0;107m';
}


xtdc_funcs(){
clear
xtdc_colors
vari=$(sudo sed -nr '/\(\)/p' "${BASH_SOURCE[0]}" | sudo sed 's/...$//')
last=$(date -r "${BASH_SOURCE[0]}" "+%Y_%m_%d_%H_%M_%S")
printf "${bbla}${ocya}LISTA DE FUNÇÕES${NC}${NC} ${bgre}XTDC 2020${NC} ${biblu}${owhi}ATUALIZADA EM${NC}${NC} ${bwhi}${ored}$last${NC}${NC}""%s\n"
printf "${bred}${obla}${vari}${NC}${NC}""%s\n" 
}


xtdc_install(){
xtdc_ppa && xtdc_pkg && xtdc_chrome && xtdc_limpa_pkg && xtdc_limpa_atalhos && xtdc_atalhos && xtdc_tema
}
TIMEFORMAT="A instalação demorou %0lR"
time {
xtdc_install
}
echo `date +%Y_%m_%d_%H_%M_%S` >> /xtdc_2020_files/log.txt
