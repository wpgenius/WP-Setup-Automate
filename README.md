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

### Advanced Setup & configurations

#### Child theme with default file structure. Added in [v1.2](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.2) & Bugs fixed in [v1.3](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.3)

This is first starter child theme ([Astra Child Theme](https://github.com/wpgenius/Astra-Child-Theme)) for Astra. It have a default file structure to write code for diffrent purpose.
WooCommerce introduced in [v1.2](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.2)

#### Push child theme to Bitbucket [v1.4](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.4) [^4]

In order to sync child theme from staging server with Bitbucket you need to first configure SSH keys. [Click here for documentation](https://support.atlassian.com/bitbucket-cloud/docs/configure-ssh-and-two-step-verification/) to configure keys.

[^1]: Make sure you are in same folder, where you already downloaded it.
[^2]: We don't update these files in this repository.
[^3]: .pst-pro, .wpp-pro, .uae-pro, .astra-pro are hidden files & contains keys. Make sure you have them in your user's home folder
[^4]: You must create Bitbucket repository matching theme folder name before starting setup process.
