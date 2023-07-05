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

echo -e "${GREEN}Enter slug for child theme :${NC} "
while [[ $theme_slug = "" ]]; do
   read theme_slug
done

echo -e "${GREEN}Enter the site title:${NC} "
while [[ $TITLE = "" ]]; do
   read TITLE
done

echo -e "${GREEN}Enter the database name :${NC} "
while [[ $dbname = "" ]]; do
   read dbname
done

echo -e "${GREEN}Enter the database user name :${NC} "
while [[ $dbuser = "" ]]; do
   read dbuser
done

echo -e "${GREEN}Enter the database user password :${NC} "
while [[ $dbpass = "" ]]; do
   read dbpass
done

echo -e "${GREEN}Enter the database table prefix :${NC} "
while [[ $dbprefix = "" ]]; do
   read dbprefix
done

echo -e "${GREEN}Enter first developer username :${NC} "
while [[ $dev_name = "" ]]; do
   read dev_name
done

#Choices
read -p "Do you wish to add default files to child theme? (Yes/No) " child_theme_default_files_yn
read -p "Is this e-commerce website? (Yes/No) " ecommerce_yn
read -p "Do you wish to install Astra WP portfolio plugin? (Yes/No) " portfolio_yn

mkdir -p ~/public_html/$foldername && cd ~/public_html/$foldername

URL=https://tyche.work/$foldername/

#WordPress Installation
wp core download --quiet

echo -e "${GREEN}Creating databse configuration for ${BLUE}$foldername${NC}"
wp config create --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --dbprefix="$dbprefix" --force=y --quiet

echo -e "${GREEN}Installing WordPress for ${BLUE}$foldername${NC}"
wp core install --url="$URL" --title="$TITLE" --admin_user=makarand --admin_email=mane.makarand@gmail.com --admin_password=p@55w0rd! --skip-email=n --quiet
#Un-comment below lines if above command asks for URL parameter
#wp option update siteurl "$URL"
#wp option update home "$URL"
echo -e "${GREEN}WordPress installed & configured : ${BLUE}$URL ${NC}"

wp config set WP_MEMORY_LIMIT 256M  --quiet

#Install astra theme then create & switch to child theme
wp theme install astra --quiet
echo -e "${GREEN}Creating child theme for ${BLUE}$foldername${NC}"
wp scaffold child-theme $theme_slug --theme_name="$TITLE theme" --author="Team WPGenius" --author_uri=https://wpgenius.in --parent_theme=astra --theme_uri=https://$foldername/ --activate=y --enable-network=y --force=y --prompt --quiet

#Install necessory plugins
echo -e "${GREEN}Installing necessory plugin on ${BLUE}$foldername${NC}"
wp plugin install contact-form-7 https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-addon-plugin.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/ultimate-elementor.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-premium-sites.zip advanced-cf7-db wordpress-seo elementor --quiet
wp plugin activate astra-addon astra-pro-sites contact-form-7 elementor ultimate-elementor --quiet

#Install WooCommerce to preapre store
case $ecommerce_yn in
    [Yy]* ) 
    echo -e "${GREEN}Preparing your store with WooCommerce... {NC}"
    wp plugin install woo-gst woocommerce-google-analytics-integration woo-razorpay woocommerce --quiet
    wp option update woocommerce_email_footer_text "{site_title}" --quiet
    wp plugin activate woocommerce woo-razorpay woo-gst --quiet
    wp option update woocommerce_analytics_enabled 0 --quiet
    wp option update woocommerce_show_marketplace_suggestions 0 --quiet
    wp option update woocommerce_currency INR --quiet
    wp option update woocommerce_email_from_address orders@tyche.work --quiet
    wp post create --post_type=page --post_title="Terms & Conditions" --post_name="terms-conditions" --post_status="publish" --post_author=1 --quiet
    wp option update woocommerce_terms_page_id $(wp post list --field=ID --post_type=page --posts_per_page=1) --quiet
    ;;
esac

#Activate astra pro
pro_key=~/.astra-pro
if [ -r "$pro_key" ]; then
	echo -e "${BLUE}Astra pro key found.${NC}"
	astra_pro_key=$(<"$pro_key")
	if [ -n "$astra_pro_key" ]; then
		wp brainstormforce license activate astra-addon "$astra_pro_key"
	fi
fi

#Activate Ultimate addon for elementor
uae_key=~/.uae-pro
if [ -r "$uae_key" ]; then
	echo -e "${BLUE}Ultimate addon for elementor key found.${NC}"
	uae_pro_key=$(<"$uae_key")
	if [ -n "$uae_pro_key" ]; then
		wp brainstormforce license activate uael "$uae_pro_key"
	fi
fi

#Activate Premium Starter sites
pst_key=~/.pst-pro
if [ -r "$pst_key" ]; then
	echo -e "${BLUE}Premium Starter sites key found.${NC}"
	pst_pro_key=$(<"$pst_key")
	if [ -n "$pst_pro_key" ]; then
		wp brainstormforce license activate astra-pro-sites "$pst_pro_key"
	fi
fi

#Install Astra wp portfolio plugin if choosen to do so.
case $portfolio_yn in
    [Yy]* ) 
    wp plugin install https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-portfolio.zip --activate --quiet
    #Activate Premium Starter sites
    wpp_key=~/.wpp-pro
    if [ -r "$wpp_key" ]; then
    	echo -e "${BLUE}Astra WP Portfolio key found.${NC}"
    	wpp_pro_key=$(<"$wpp_key")
    	if [ -n "$wpp_pro_key" ]; then
    		wp brainstormforce license activate astra-portfolio "$wpp_pro_key"
    	fi
    fi
    ;;
esac

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
wp theme delete twentytwentyone twentytwentytwo twentytwentythree --quiet

#Update all plugins that have updates will be updated
wp cron event run wp_update_plugins --quiet
wp plugin update --all --quiet

#Create additional users
echo -e "${GREEN}Creating first developer ${BLUE}$dev_name's ${GREEN}account on ${BLUE}$foldername${NC}"
wp user create $dev_name $dev_name@wpgenius.in --role=administrator --user_pass= --display_name=$dev_name --send-email=y  --quiet
wp user reset-password makarand --skip-email --quiet

curl -d "user_login=makarand&amp;redirect_to=&amp;wp-submit=Get New Password" -X POST "$URL"wp-login.php?action=lostpassword

#Necessory config file variable
wp config set DISALLOW_FILE_EDIT true --raw --quiet
wp config set EMPTY_TRASH_DAYS 60 --raw --quiet
wp config set WP_POST_REVISIONS 40 --raw --quiet
wp config set AUTOSAVE_INTERVAL 180 --raw --quiet
wp config set WP_ENVIRONMENT_TYPE staging --quiet
wp config set WP_DISABLE_FATAL_ERROR_HANDLER true --raw --quiet
wp config set WP_DEFAULT_THEME astra --quiet

#Add default files to child theme
case $child_theme_default_files_yn in
    [Yy]* )
    echo -e "${GREEN}Adding default files to child theme...${NC}"
    cd wp-content/themes/ && wget https://github.com/wpgenius/Astra-Child-Theme/archive/refs/heads/main.zip -q && unzip -q main.zip && rm Astra-Child-Theme-main/style.css main.zip
    mv Astra-Child-Theme-main/* $theme_slug && rm -r Astra-Child-Theme-main
    #Replace words in child theme
    find ./ -type f -exec sed -i "s/Astra Child Theme/$TITLE/gI"  {} \;
    find ./ -type f -exec sed -i "s/astra-child-theme/$theme_slug/g"  {} \;
    #Now fire command made in child theme
    wp easy_setup    
    #Import custom layouts
    echo -e "${GREEN}Importing custom layouts for 404 template & analytics code...${NC}"
    wp plugin install wordpress-importer --activate --quiet
    wget https://raw.githubusercontent.com/wpgenius/WP-Setup-Automate/main/bundle/custom-layouts.xml -q && wp import custom-layouts.xml --authors=create --quiet && rm custom-layouts.xml
    wp plugin deactivate wordpress-importer --quiet && wp plugin delete wordpress-importer --quiet
    ;;
esac

#Flush rewrite rules
wp rewrite flush --quiet

echo -e "\n${GREEN}Staging setup is ready ${BLUE}$URL ${NC}"
