echo "Enter folder name : "
read foldername
mkdir -p ~/public_html/$foldername && cd ~/public_html/$foldername
wp core download 
wp config create --force=y --prompt=dbname,dbuser,dbpass,dbprefix
wp core install --admin_user=makarand --admin_email=mane.makarand@gmail.com --skip-email=n --prompt
wp plugin delete hello akismet
wp theme install astra --activate
wp scaffold child-theme --author=WPGenius --author_uri=WPGenius --activate=y --enable-network=y --force=y --prompt
wp theme delete twentynineteen twentytwenty twentytwentyone
wp plugin install elementor contact-form-7 --activate
wp plugin install ga-google-analytics wordpress-seo
wp option update blogdescription ""
wp option update timezone_string "Asia/Kolkata"
wp option update blog_public "yes"
wp option update default_pingback_flag "no"
wp option update default_ping_status "no"
wp option update default_comment_status "no"
wp option update comment_registration "yes"
wp option update comment_moderation "yes"
wp option update permalink_structure '/%postname%/'
wp post delete 1
wp user create pooja pooja@wpgenius.in --role=administrator --user_pass=123 --display_name=pooja --send-email=y --porcelain=y