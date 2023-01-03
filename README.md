# WP-Setup-Automate
Install WordPress with latest version on cpanel &amp; configure with default plugins, themes &amp; options

## Setup & installation

Run below command on SSH using Putty or Linux terminal:
```
wget -qO wps https://wpgenius.github.io/WP-Setup-Automate/wpauto.sh && bash wps
```

To start installation process anytime, run command `bash wps` from terminal. [^1]

### Bonus

Download plugins manually. [^2]
```
wp plugin install elementor contact-form-7 https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-addon-plugin.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/ultimate-elementor.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-premium-sites.zip --activate --quiet
```

Activate plugins manually. [^3]
```
wp brainstormforce license activate astra-pro-sites $(cat ~/.pst-pro)
wp brainstormforce license activate astra-portfolio $(cat ~/.wpp-pro)
wp brainstormforce license activate uael $(cat ~/.uae-pro)
wp brainstormforce license activate astra-addon $(cat ~/.astra-pro)
```

[^1]: Make sure you are in same folder, where you already downloaded it.
[^2]: We don't update these files in this repository.
[^3]: .pst-pro, .wpp-pro, .uae-pro, .astra-pro are hidden files & contains keys. Make sure you have them in your user's home folder
