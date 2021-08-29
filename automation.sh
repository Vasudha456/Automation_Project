chmod  +x  /root/Automation_Project/automation.sh
echo "Updating the package details"                                  
apt update -y                                                        
dpkg --get-selections | grep apache                                  
if [ $? -eq 0 ]; then                                                
        echo "Apache is running."                                    
else                                                                 
        echo "Apache is not running, Downloading Apache server"      
        apt-get install apache2                                      
fi                                                                   
ps -ef |  grep apache2.service                                       
if [ $? -eq 0 ];                                                     
then                                                                 
        echo "Process is running."                                   
else                                                                 
        echo "Process is not running, Starting Apache server"        
        /etc/init.d/apache2 start                                    
fi                                                                   
cd  /var/log/apache2/                                                
timestamp=$(date '+%Y-%m-%d')                                        
myname="Vasudha"                                                     
tar -zcvf "$myname-httpd-logs-$timestamp.tar" access.log error.log   
cp *.tar /tmp/                                                       
sudo apt update                                                      
sudo apt install awscli                                              
s3_bucket='upgrad-vasudha'                                           
aws s3 cp $myname-httpd-logs-$timestamp.tar s3://upgrad-vasudha                                                                                                                
#cat /var/www/html/inventory.html
cd /var/www/html/
FILE=inventory.html
if [ -f "$FILE" ];
then
        echo "$FILE exists."
else
        echo "$FILE does not exist. Creating ineventory.html"
        touch /var/www/html/inventory.html
        ls
        echo "$FILE exists."
fi
cd  /var/log/apache2/
logtype="httpd-logs"
type="tar"
size=$(du -h "$myname-httpd-logs-$timestamp.tar" | awk '{print $1}')
echo "Log Type\t Date Created\t Type\t Size\t" >> output.txt
echo "$logtype\t $timestamp\t $type\t $size\t" >> output.txt
* * * * * root /root/Automation_Project/automation.sh &>> /etc/cron.d/automation
