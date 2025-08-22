install: git curl wget cursor slack spotify thunderbird chromium zoom docker zsh ohmyzsh hstr nextcloud dbeaver emote peek gitkraken tweaks signal discord mattermost vim ssh-key keeweb

APT=sudo apt-get
APT_INSTALL=$(APT) install -y
ADD_APT_REPO=sudo add-apt-repository -y
LSB_RELEASE=$(shell lsb_release -cs)
ARCH=$(shell dpkg --print-architecture)

git:
	$(APT_INSTALL) git

curl:
	$(APT_INSTALL) curl

wget:
	$(APT_INSTALL) wget

zsh:
	$(APT_INSTALL) zsh
	chsh -s /usr/bin/zsh ${whoami}
	sudo chsh -s /usr/bin/zsh root

ohmyzsh:
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
	source ~/.zshrc

docker:
	$(APT_INSTALL) apt-transport-https ca-certificates gnupg lsb-release
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo "deb [arch=$(ARCH) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(LSB_RELEASE) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	$(APT_INSTALL) docker-ce docker-ce-cli containerd.io

zoom:
	wget https://cdn.zoom.us/prod/6.5.11.4015/zoom_amd64.deb
	sudo apt --fix-broken -y install ./zoom_amd64.deb
	rm zoom_amd64.deb*

snap:
	sudo snap install --classic $(APP)

spotify:
	make snap APP=spotify

slack:
	make snap APP=slack

gitkraken:
	make snap APP=gitkraken

peek:
	make snap APP=peek

emote:
	make snap APP=emote

phpstorm:
	make snap APP=phpstorm

signal:
	make snap APP=signal-desktop

nextcloud:
	make snap APP=nextcloud-desktop-client

dbeaver:
	make snap APP=dbeaver-ce

discord:
	make snap APP=discord

mattermost:
	make snap APP=mattermost-desktop

hstr:
	$(ADD_APT_REPO) ppa:ultradvorka/ppa
	$(APT) update
	$(APT_INSTALL) hstr
	hstr --show-configuration >> ~/.zshrc

ssh-key:
	ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""

thunderbird:
	make snap APP=thunderbird

tweaks:
	$(APT_INSTALL) gnome-tweaks

chrome:
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	$(APT_INSTALL) ./google-chrome-stable_current_amd64.deb
	rm google-chrome-stable_current_amd64.deb*
	
keeweb:
	wget https://github.com/keeweb/keeweb/releases/download/v1.18.7/KeeWeb-1.18.7.linux.x64.deb
	$(APT_INSTALL) ./KeeWeb-1.18.7.linux.x64.deb
	rm KeeWeb-1.18.7.linux.x64.deb

ulauncher:
	$(ADD_APT_REPO) universe -y && sudo $(ADD_APT_REPO) ppa:agornostal/ulauncher -y && $(APT) update && $(APT) install ulauncher
