# WP-Setup-Automate
Install the latest version of WordPress on cPanel and configure it with default plugins, themes, and options.

## Setup & Installation

Run the command below on SSH using PuTTY or a Linux terminal:
```bash
wget -qO wps https://wpgenius.github.io/WP-Setup-Automate/wpauto.sh && bash wps
```

To start the installation process anytime, run the command `bash wps` from the terminal. [^1]

### Bonus

Download plugins manually. [^2]
```bash
wp plugin install elementor contact-form-7 https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-addon-plugin.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/ultimate-elementor.zip https://wpgenius.github.io/WP-Setup-Automate/bundle/astra-premium-sites.zip --activate --quiet
```

Activate plugins manually. [^3]
```bash
wp brainstormforce license activate astra-pro-sites $(cat ~/.pst-pro)
wp brainstormforce license activate astra-portfolio $(cat ~/.wpp-pro)
wp brainstormforce license activate uael $(cat ~/.uae-pro)
wp brainstormforce license activate astra-addon $(cat ~/.astra-pro)
```

### Advanced Setup & Configuration

#### Child theme with default file structure. Added in [v1.2](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.2) and bugs fixed in [v1.3](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.3)

This is the first starter child theme ([Astra Child Theme](https://github.com/wpgenius/Astra-Child-Theme)) for Astra. It has a default file structure to write code for different purposes.
WooCommerce was introduced in [v1.2](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.2).

#### Push child theme to Bitbucket [v1.4](https://github.com/wpgenius/WP-Setup-Automate/releases/tag/1.4) [^4]

In order to sync the child theme from the staging server with Bitbucket, you need to configure SSH keys first. [Click here for documentation](https://support.atlassian.com/bitbucket-cloud/docs/configure-ssh-and-two-step-verification/) to configure keys.

[^1]: Make sure you are in the same folder where you already downloaded it.
[^2]: We don't update these files in this repository.
[^3]: .pst-pro, .wpp-pro, .uae-pro, and .astra-pro are hidden files and contain keys. Make sure you have them in your user's home folder.
[^4]: You must create a Bitbucket repository matching the theme folder name before starting the setup process.
