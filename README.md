# Odoo database and filestore backup with Dropbox

## For Odoo deployments through Docker, clone repository with root user in Ubuntu server

> sudo su

> git clone https://github.com/QaidjoharBarbhaya/odoo-backup-shell-scripts.git

> chmod 755 backup.sh

> chmod 755 dropbox-sync.py

> crontab -e

Add following line at end of the file

> 0 0 * * * /root/odoo-backup-shell-scripts/backup.sh

## Get client_id and client_secret from your Dropbox App

Go to https://dropbox.com/developers and configure new app. The app has the client_id and client_secret.

## Get refresh token (Used to renew token automatically as it has the validity of 4 hours)

In web browser, paste the following url:

https://www.dropbox.com/oauth2/authorize?token_access_type=offline&response_type=code&client_id=<App key\>

Use the received code in below command:

> curl https://api.dropbox.com/oauth2/token -d code=<received code> -d grant_type=authorization_code -u <App key>:<App secret>

Note the refresh token.

## Acknowledgement

1. [Dropbox Forum](https://www.dropboxforum.com/t5/Dropbox-API-Support-Feedback/python-upload-big-file-example/td-p/166626)
2. [Dropbox Forum](https://www.dropboxforum.com/t5/Dropbox-API-Support-Feedback/Issue-in-generating-access-token/td-p/592667)
