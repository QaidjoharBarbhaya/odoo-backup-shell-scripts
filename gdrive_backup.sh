cd /home/odoo-backup/
pg_dump dbname -U odoo > dbname.sql
tar czvf "db_"`date +"%Y-%m-%d"`".tar.gz" dbname.sql
rm dbname.sql
rm "db_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz"
tar -C /odoo/.local/share/Odoo/filestore -czpvf "filestore_"`date +"%Y-%m-%d"`".tar.gz" dbname
rm "filestore_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz"

/usr/local/bin/gdrive upload "db_"`date +"%Y-%m-%d"`".tar.gz"
createdFile=$(/usr/local/bin/gdrive list --query "name = '"db_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz"'")
createdFileId=$(echo $createdFile | cut -d' ' -f 6)
/usr/local/bin/gdrive delete $createdFileId
/usr/local/bin/gdrive upload "filestore_"`date +"%Y-%m-%d"`".tar.gz"
createdFile=$(/usr/local/bin/gdrive list --query "name = '"filestore_"`date --date="1 day ago" +"%Y-%m-%d"`".tar.gz"'")
createdFileId=$(echo $createdFile | cut -d' ' -f 6)
/usr/local/bin/gdrive delete $createdFileId
