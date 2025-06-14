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

GITURL=https://bitbucket.org/wpgenius/$theme_slug

#Choices
read -p "Do you wish to add default files to child theme? (Yes/No) " child_theme_default_files_yn
echo -e "Have you created bitbucket repository at this address ${GREEN}$GITURL${NC}?"
read -p "Do you wish to sync child theme to bitbucket repository? (Yes/No) " git_yn
read -p "Is this e-commerce website? (Yes/No) " ecommerce_yn
read -p "Do you wish to install Astra WP portfolio plugin? (Yes/No) " portfolio_yn

mkdir -p ~/public_html/$foldername && cd ~/public_html/$foldername

URL=https://tyche.work/$foldername/

#WordPress Installation
wp core download --quiet

echo -e "${GREEN}Creating databse configuration for ${BLUE}$foldername${NC}"
wp config create --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --dbprefix="$dbprefix" --force=y --quiet

#Default Password
PASSWORD=p@55w0rd!
pass_file=~/.pass-file
if [ -r "$pass_file" ]; then
	NEWPASS=$(<"$pass_file")
	if [[ -n "$NEWPASS" ]]; then
		PASSWORD=$NEWPASS
	fi
fi

echo -e "${GREEN}Installing WordPress for ${BLUE}$foldername${NC}"
wp core install --url="$URL" --title="$TITLE" --admin_user=makarand --admin_email=mane.makarand@gmail.com --admin_password="$PASSWORD" --skip-email=n --quiet
#Un-comment below lines if above command asks for URL parameter
#wp option update siteurl "$URL"
#wp option update home "$URL"
echo -e "${GREEN}WordPress installed & configured : ${BLUE}$URL ${NC}"

wp config set WP_MEMORY_LIMIT 256M  --quiet

#Install astra theme then create & switch to child theme
wp theme install astra --activate --quiet

#Install necessory plugins
echo -e "${GREEN}Installing necessory plugin on ${BLUE}$foldername${NC}"
wp plugin install contact-form-7 --quiet
wp plugin install https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-addon-plugin.zip --quiet
wp plugin install https://wpgenius.github.io/WP-Setup-Automate/bundle/ultimate-elementor.zip --quiet
wp plugin install https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-premium-sites.zip --quiet
wp plugin install advanced-cf7-db --quiet
wp plugin install wordpress-seo --quiet
wp plugin install elementor --quiet
wp plugin activate astra-addon astra-pro-sites contact-form-7 elementor ultimate-elementor --quiet

#Install WooCommerce to preapre store
case $ecommerce_yn in
    [Yy]* ) 
    echo -e "${GREEN}Preparing your store with WooCommerce... ${NC}"
    wp plugin install woocommerce-google-analytics-integration --quiet
    wp plugin install woo-gst --activate --quiet
    wp plugin install woo-razorpay --activate --quiet
    wp plugin install woocommerce --activate --quiet
    #Update some default options for WooCommmerce
    wp option update woocommerce_email_footer_text "{site_title}" --quiet
    wp option update woocommerce_analytics_enabled 0 --quiet
    wp option update woocommerce_show_marketplace_suggestions 0 --quiet
    wp option update woocommerce_default_country "IN:MH" --quiet
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
wp option update admin_email "teamwpgenius@gmail.com" --quiet
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
wp option update elementor_google_font 0 --quiet
wp option update elementor_css_print_method "internal" --quiet
wp option update elementor_meta_generator_tag 1 --quiet
wp option update elementor_experiment-container "inactive" --quiet
wp option update elementor_unfiltered_files_upload 0 --quiet
wp option update elementor_load_fa4_shim "no" --quiet
wp option update elementor_experiment-landing-pages "inactive" --quiet
wp option update elementor_experiment-e_element_cache "inactive" --quiet
wp option update elementor_experiment-cloud-library "inactive" --quiet
wp option update elementor_experiment-e_local_google_fonts "inactive" --quiet
wp option update elementor_font_display "swap" --quiet
wp option update permalink_structure '/%postname%/' --quiet

#Delete unwanted data
echo -e "${GREEN}Removing unwanted plugins, themes & posts from ${BLUE}$foldername${NC}"
wp plugin delete hello akismet --quiet
wp post delete 1 --force --quiet
wp theme delete twentytwentyone twentytwentytwo twentytwentythree twentytwentyfour twentytwentyfive --quiet

#Update all plugins that have updates will be updated
wp cron event run wp_update_plugins --quiet
wp plugin update --all --quiet

#Create additional users
echo -e "${GREEN}Creating first developer ${BLUE}$dev_name's ${GREEN}account on ${BLUE}$foldername${NC}"
wp user create $dev_name $dev_name@wpgenius.in --role=administrator --user_pass= --display_name=$dev_name --send-email=y  --quiet

#Reset default password
if [ $PASSWORD = "p@55w0rd!" ]; then
	wp user reset-password makarand --skip-email --quiet
	curl -d "user_login=makarand&amp;redirect_to=&amp;wp-submit=Get New Password" -X POST "$URL"wp-login.php?action=lostpassword
fi

#Necessory config file variable
wp config set WP_DEBUG_LOG true --raw --quiet
wp config set DISALLOW_FILE_EDIT true --raw --quiet
wp config set WP_MEMORY_LIMIT 256 --raw --quiet
wp config set EMPTY_TRASH_DAYS 60 --raw --quiet
wp config set WP_POST_REVISIONS 40 --raw --quiet
wp config set AUTOSAVE_INTERVAL 180 --raw --quiet
wp config set WP_ENVIRONMENT_TYPE staging --quiet
wp config set WP_DISABLE_FATAL_ERROR_HANDLER true --raw --quiet
wp config set WP_DEFAULT_THEME astra --quiet

#Prepare child theme
case $child_theme_default_files_yn in
    [Yy]* )
        #Add child theme by WPGenius available at https://github.com/wpgenius/Astra-Child-Theme
        echo -e "${GREEN}Preparing child theme made by WPGenius for Astra...${NC}"
        cd wp-content/themes/ && wget https://github.com/wpgenius/Astra-Child-Theme/archive/refs/heads/main.zip -q && unzip -q main.zip &&  mv Astra-Child-Theme-main $theme_slug && rm main.zip
        #Replace words in child theme
        find ./ -type f -exec sed -i "s/Astra Child Theme/$TITLE/gI"  {} \;
        find ./ -type f -exec sed -i "s/astra-child-theme/$theme_slug/g"  {} \;
        find ./ -type f -exec sed -i "s/project-url/$foldername/g"  {} \;
        echo -e "\n${GREEN}Child theme $theme_slug is ready. ${BLUE}Activating child theme. ${NC} \n"
        wp theme activate $theme_slug --quiet #Theme activation hook fires wp easy_setup command. No need execute seperately.
        
        #Import custom layouts
        echo -e "${GREEN}Importing custom layouts for 404 template & analytics code...${NC}"
        wp plugin install wordpress-importer --activate --quiet
        wget https://raw.githubusercontent.com/wpgenius/WP-Setup-Automate/main/bundle/custom-layouts.xml -q && wp import custom-layouts.xml --authors=create --quiet && rm custom-layouts.xml
        wp plugin deactivate wordpress-importer --quiet && wp plugin delete wordpress-importer --quiet
        wp theme activate astra && wp option delete WPG_child_activate --quiet
        #Instructions for things to do manually
        echo -e "\n${BLUE}NOTICE :${NC}"
        echo -e "\n${GREEN}1. Open WAE settings & deactivate all options. \n2. Switch to child theme $theme_slug \n3. Hit permalink page again.${NC}"
    ;;
    
    *)
        echo -e "${GREEN}Creating child theme for ${BLUE}$foldername${NC}"
        wp scaffold child-theme $theme_slug --theme_name="$TITLE theme" --author="Team WPGenius" --author_uri=https://wpgenius.in --parent_theme=astra --theme_uri=https://$foldername/ --activate=y --enable-network=y --force=y --prompt --quiet
	;;
esac

#Sync child theme to bitbucket repository
case $git_yn in
    [Yy]* ) 
    echo -e "\n${GREEN}Pushing child theme to bitbucket repository... ${NC}"
    cd ~/public_html/$foldername/wp-content/themes/$theme_slug
    git init --quiet
    git add -A && git commit -m "Initial commit" --quiet
    git remote add origin git@bitbucket.org:wpgenius/$theme_slug.git && git push -u origin master --quiet #Push Master branch
    git branch dev && git checkout dev --quiet && git push -u origin dev --quiet  #Create & Push dev branch
    rm -rf .git 
    echo -e "${GREEN}Check commit at ${BLUE}$GITURL/commits/${NC}"
    ;;
esac

#Flush rewrite rules
wp rewrite flush --quiet

echo -e "\n${GREEN}Staging setup is ready ${BLUE}$URL ${NC} \n"
