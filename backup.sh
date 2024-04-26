cd odoo-backup-shell-scripts/
docker exec db pg_dump -U odoo kathiawartech > kathiawartech.sql
tar czvf "db_"`date +"%Y-%m-%d"`".tar.gz" kathiawartech.sql
rm kathiawartech.sql
rm "db_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz"
docker exec --user root odoo tar -C /var/lib/odoo/filestore -czpvf /var/lib/odoo/filestore/"filestore_"`date +"%Y-%m-%d"`".tar.gz" kathiawartech
docker exec --user root odoo rm /var/lib/odoo/filestore/"filestore_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz"
docker cp odoo:/var/lib/odoo/filestore/"filestore_"`date +"%Y-%m-%d"`".tar.gz" .
rm "filestore_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz" 
./dropbox-sync.py "db_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz" "db_"`date +"%Y-%m-%d"`".tar.gz"
./dropbox-sync.py "filestore_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz" "filestore_"`date +"%Y-%m-%d"`".tar.gz"
