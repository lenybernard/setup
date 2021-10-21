install: git curl wget phpstorm slack spotify thunderbird chrome docker docker-compose zsh ohmyzsh hstr nextcloud dbeaver emote peek gitkraken tweaks signal discord mattermost vim ssh-key

APT=sudo apt-get
APT_INSTALL=$(APT) install -y
ADD_APT_REPO=sudo add-apt-repository -y

git:
	$(APT_INSTALL) git

curl:
	$(APT_INSTALL) curl

wget:
	$(APT_INSTALL) wget

zsh:
	$(APT_INSTALL) zsh
	chsh -s /usr/bin/zsh leny
	sudo chsh -s /usr/bin/zsh root

ohmyzsh:
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
	cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
	source ~/.zshrc

docker:
	$(APT_INSTALL) apt-transport-https ca-certificates gnupg lsb-release
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	sudo apt-get update
	$(APT_INSTALL) docker-ce docker-ce-cli containerd.io

docker-compose:
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

zoom:
	wget https://zoom.us/client/latest/zoom_amd64.deb
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

dbeaver:
	make snap APP=dbeaver-ce

hstr:
	$(ADD_APT_REPO) ppa:ultradvorka/ppa
	$(APT) update
	$(APT_INSTALL) hstr
	hstr --show-configuration >> ~/.zshrc

thunderbird:
	make snap APP=thunderbird

gnome-tweaks:
	$(APT_INSTALL) gnome-tweaks

chrome:
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	$(APT_INSTALL) ./google-chrome-stable_current_amd64.deb
	rm google-chrome-stable_current_amd64.deb*