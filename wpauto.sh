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

URL=https://tyche.work/$foldername/

#WordPress Installation
wp core download --quiet
echo -e "${GREEN}Create databse configuration for ${BLUE}$foldername${NC}"
wp config create --force=y --prompt=dbname,dbuser,dbpass,dbprefix --quiet
wp core install --url="$URL" --admin_user=makarand --admin_email=mane.makarand@gmail.com --admin_password=p@55w0rd! --skip-email=n --prompt=title --quiet
#Un-comment below lines if above command asks for URL parameter
#wp option update siteurl "$URL"
#wp option update home "$URL"
echo -e "${GREEN}WordPress installed & configured : ${BLUE}$URL ${NC}"

wp config set WP_MEMORY_LIMIT 256M

#Install astra theme then create & switch to child theme
wp theme install astra --quiet
echo -e "${GREEN}Create child theme for ${BLUE}$foldername${NC}"
wp scaffold child-theme --author="Team WPGenius" --author_uri=https://wpgenius.in --parent_theme=astra --theme_uri=https://$foldername/ --activate=y --enable-network=y --force=y --prompt --quiet

#Install necessory plugins
echo -e "${GREEN}Installing necessory plugin on ${BLUE}$foldername${NC}"
wp plugin install elementor contact-form-7 https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-addon-plugin.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/ultimate-elementor.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-premium-sites.zip --activate --quiet
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

#Activate Ultimate addon for elementor
uae_key=~/.uae-pro
if [ -r "$uae_key" ]; then
	echo -e "${BLUE}Ultimate addon for elementor key found.${NC}"
	uae_pro_key=$(<"$uae_key")
	if [ -n "$uae_pro_key" ]; then
		wp brainstormforce license activate uael "$uae_pro_key"
		wp plugin update ultimate-elementor --quiet
	fi
fi


#Activate Premium Starter sites
pst_key=~/.pst-pro
if [ -r "$pst_key" ]; then
	echo -e "${BLUE}Premium Starter sites key found.${NC}"
	pst_pro_key=$(<"$pst_key")
	if [ -n "$pst_pro_key" ]; then
		wp brainstormforce license activate astra-pro-sites "$pst_pro_key"
		wp plugin update astra-pro-sites --quiet
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
wp theme delete twentynineteen twentytwenty twentytwentyone twentytwentytwo --quiet

wp config set DISALLOW_FILE_EDIT true --raw
wp config set EMPTY_TRASH_DAYS 60 --raw
wp config set WP_POST_REVISIONS 40 --raw
wp config set AUTOSAVE_INTERVAL 180 --raw
wp config set WP_ENVIRONMENT_TYPE staging

#Create additional users
echo -e "${GREEN}Create first developer users account on ${BLUE}$foldername${NC}"
wp user create snehal snehal@wpgenius.in --role=administrator --user_pass= --display_name=snehal --send-email=y  --quiet
wp user reset-password makarand --skip-email --quiet
echo -e "${GREEN}Staging setup is ready ${BLUE}$URL ${NC}"
curl -d "user_login=makarand&amp;redirect_to=&amp;wp-submit=Get New Password" -X POST "$URL"wp-login.php?action=lostpassword
