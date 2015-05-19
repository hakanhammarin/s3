#!/bin/bash

# cd /tmp
# rm -rf backup
# mkdir backup
# cd backup

# mkdir sql && cd sql
# databases=`echo 'show databases;' | mysql -u backup | tail -n +2 | grep -v _schema | grep -v mysql`
# for database in $databases
# do
#     mysqldump -u backup --databases $database > "${database}.sql"
# done

# cd ..
# mkdir nginx && cd nginx
# cp -R /etc/nginx/sites-enabled .
# cp /etc/nginx/nginx.conf .

# cd ..
# mkdir git && cd git
# repos=`ls -1 /home/git | grep '.git$'`
# for repo in $repos; do
#     cp -R "/home/git/${repo}" .
# done    

cd /Volumes/10MILA1/
# pwd
export LANG=us_US.UTF-8
# date=`date`
# date=`date +%Y%m%d`
bucket=10mila-2015
for dir in /Volumes/10MILA1/mp4/*.mp4 ; do
    # file="${date}-${dir}.tar.gz"
    file="${dir}"
   	echo ${dir}
   	echo $dir
    # cd $dir && tar czf $file *
    # cd $dir 
    resource="/${bucket}/${file}"
    contentType="application/octet-stream"
    dateValue=`date -jnu +%a,\ %d\ %h\ %Y\ %T\ %Z`
    # dateValue="Tue, 19 May 2015 11:36:34 CEST"
    # dateValue="Thu, 17 Nov 2005 18:49:58 GMT"
    echo $dateValue
    echo ${file}
   	stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
    s3Key=xxxxxxx
    s3Secret=x+x+xxxxxxxx
    signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
    curl -X PUT -T "${file}" \
        -H "Host: ${bucket}.s3.amazonaws.com" \
        -H "Date: ${dateValue}" \
        -H "Content-Type: ${contentType}" \
        -H "Authorization: AWS ${s3Key}:${signature}" \
        https://${bucket}.s3.amazonaws.com/${file}
    cd ..
done

cd
rm -rf /tmp/backup