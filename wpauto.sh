#!/bin/bash
#Shell colors  https://stackoverflow.com/a/5947802/1124612
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

#Create project folder. Here we consider folder name as domain name of project
echo -e "${GREEN}Enter folder name :${NC} "
while [[ $foldername = "" ]]; do
   read foldername
done
mkdir -p ~/public_html/$foldername && cd ~/public_html/$foldername

#WordPress Installation
wp core download --quiet
echo -e "${GREEN}Create databse configuration for ${BLUE}$foldername${NC}"
wp config create --force=y --prompt=dbname,dbuser,dbpass,dbprefix --quiet
wp core install --url=https://tyche.work/$foldername/ --admin_user=makarand --admin_email=mane.makarand@gmail.com --admin_password=p@55w0rd! --skip-email=n --prompt=title --quiet
#Un-comment below lines if above command asks for URL parameter
#wp option update siteurl https://tyche.work/$foldername/
#wp option update home https://tyche.work/$foldername/
echo -e "${GREEN}WordPress installed & configured : ${BLUE}https://tyche.work/$foldername${NC}"

#Install astra theme then create & switch to child theme
wp theme install astra --quiet
echo -e "${GREEN}Create child theme for ${BLUE}$foldername${NC}"
wp scaffold child-theme --author="Team WPGenius" --author_uri=https://wpgenius.in --parent_theme=astra --theme_uri=https://$foldername/ --activate=y --enable-network=y --force=y --prompt --quiet

#Install necessory plugins
echo -e "${GREEN}Installing necessory plugin on ${BLUE}$foldername${NC}"
wp plugin install elementor contact-form-7 https://wpgenius.github.io/WP-Setup-Automate/astra-addon-plugin.zip --activate --quiet
wp plugin install ga-in wordpress-seo advanced-cf7-db --quiet

#Activate astra pro
pro_key=~/.astra-pro
if [ -r "$pro_key" ]; then
	echo -e "${BLUE}Astra pro key found.${NC}"
	astra_pro_key=$(<"$pro_key")
	if [ -n "$astra_pro_key" ]; then
		wp brainstormforce license activate astra-addon "$astra_pro_key"
		wp plugin update astra-addon --quiet
	fi
fi

#Update WordPress with default options
echo -e "${GREEN}Setting up default configuration${NC}"
wp option update blogdescription "" --quiet
wp option update timezone_string "Asia/Kolkata" --quiet
wp option update blog_public 0 --quiet
wp option update default_pingback_flag 0 --quiet
wp option update default_ping_status 0 --quiet
wp option update default_comment_status 0 --quiet
wp option update comment_registration 1 --quiet
wp option update comment_moderation 1 --quiet
wp option update show_on_front "page" --quiet
wp option update page_on_front "2" --quiet
wp option update elementor_disable_color_schemes "yes" --quiet
wp option update elementor_disable_typography_schemes "yes" --quiet
wp option update permalink_structure '/%postname%/' --quiet

#Delete unwanted data
echo -e "${GREEN}Removing unwanted plugins, themes & posts from ${BLUE}$foldername${NC}"
wp plugin delete hello akismet --quiet
wp post delete 1 --force --quiet
wp theme delete twentynineteen twentytwenty twentytwentyone --quiet

#Create additional users
echo -e "${GREEN}Create first developer users account on ${BLUE}$foldername${NC}"
wp user create pooja pooja@wpgenius.in --role=administrator --user_pass= --display_name=pooja --send-email=y  --quiet
wp user reset-password makarand --skip-email --quiet
echo -e "${GREEN}Staging setup is ready ${BLUE}https://tyche.work/$foldername/${NC}"
curl -d "user_login=makarand&amp;redirect_to=&amp;wp-submit=Get New Password" -X POST https://tyche.work/$foldername/wp-login.php?action=lostpassword
