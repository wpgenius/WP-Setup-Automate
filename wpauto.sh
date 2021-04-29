#Create project folder. Here we consider folder name as domain name of project
echo "Enter folder name : "
read foldername
mkdir -p ~/public_html/$foldername && cd ~/public_html/$foldername

#WordPress Installation
wp core download 
wp config create --force=y --prompt=dbname,dbuser,dbpass,dbprefix
wp core install --admin_user=makarand --admin_email=mane.makarand@gmail.com --url=tyche.work/$foldername --admin_password= --skip-email=n --prompt

#Install astra theme then create & switch to child theme
wp theme install astra
wp scaffold child-theme --author=TeamWPGenius --author_uri=https://wpgenius.in --parent_theme=astra --theme_uri=https://$foldername/ --activate=y --enable-network=y --force=y --prompt

#Install necessory plugins
wp plugin install elementor contact-form-7 https://wpgenius.github.io/WP-Setup-Automate/astra-addon-plugin.zip --activate
wp plugin install ga-in wordpress-seo

#Update WordPress with default options
wp option update blogdescription ""
wp option update timezone_string "Asia/Kolkata"
wp option update blog_public "yes"
wp option update default_pingback_flag "no"
wp option update default_ping_status "no"
wp option update default_comment_status "no"
wp option update comment_registration "yes"
wp option update comment_moderation "yes"
wp option update permalink_structure '/%postname%/'

#Delete unwanted data
wp plugin delete hello akismet
wp post delete 1
wp theme delete twentynineteen twentytwenty twentytwentyone

#Create additional users
wp user create pooja pooja@wpgenius.in --role=administrator --user_pass= --display_name=pooja --send-email=y
