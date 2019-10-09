#! /usr/local/bin/bash
# require bash 4.x

# add fqdn in arr1. delimiter is space.
arr1=("hogehoge.fugaga.mogemoge.com")
# add url path in arr2. delimiter is space.
arr2=("")
# attack string in query string
declare -A arr3;
arr3=(["Illegal Resource Access"]="IRA=cmd.exe" ["Remote File Inclusion"]="goto=http://www.evil.com/" ["Cross Site Scripting"]="XSS='><script>alert(document.cookie)</script><!--" ["SQL Injection"]="sqli='SELECT id, name FROM employee WHERE name = \'%'" ["Backdoor"]="wso-4.2.5.php")

#ua="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:63.0) Gecko/20100101 Firefox/63.0"

for var1 in "${arr1[@]}"
do
  echo -e "\n# check for ${var1}\n"
  for var2 in "${arr2[@]}"
  	do
  		for var3 in "${!arr3[@]}" 
       		do
			   echo "## ${var3}"
			   value=${arr3[$var3]}
			   echo '```'
			   echo "Time:`date`"
	      #     curl -H "Host:${var1}" "http://${ip}${var2}/?${var1}=cmd.exe"  --verbose
			   if [ "`echo ${var3} | grep 'Remote'`" ]; then
			   echo "URI:${var1}/sql.php?${value}"
			   #res=$(curl -H "$ua" "http://${var1}/sql.php?${value}" -w "HTTPSTATUS:%{http_code}" -s)
			   res=$(curl "http://${var1}/sql.php?${value}" -w "HTTPSTATUS:%{http_code}" -s)
#			   curl -H "$ua" "http://${var1}/sql.php?${value}" -v
			   elif [ "`echo ${var3} | grep 'SQL'`" ]; then
			   echo "URI:${var1}/  POSTDATA:${value}"
			   #res=$(curl -H "$ua" "http://${var1}/" -d "${value}" -w "HTTPSTATUS:%{http_code}" -s)
			   res=$(curl "http://${var1}/" -d "${value}" -w "HTTPSTATUS:%{http_code}" -s)
			   elif [ "`echo ${var3} | grep 'Backdoor'`" ]; then
			   echo "URI:${var1}/${value}"
			   #res=$(curl -H "$ua" "http://${var1}/" -d "${value}" -w "HTTPSTATUS:%{http_code}" -s)
			   res=$(curl "http://${var1}/${value}" -w "HTTPSTATUS:%{http_code}" -s)
#			   curl -H "$ua" "http://${var1}/" -d "${value}" -v 
			   else
	           echo "URI:${var1}${var2}/?${value}"
	           #res=$(curl -H "$ua" "http://${var1}${var2}/?${value}" -w "HTTPSTATUS:%{http_code}" -s)
	           res=$(curl "http://${var1}${var2}/?${value}" -w "HTTPSTATUS:%{http_code}" -s)
#	           curl -H "$ua" "http://${var1}${var2}/?${value}" -v 
			   fi
			   code=$(echo $res | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
			   body=$(echo $res | sed -e 's/HTTPSTATUS\:.*//g')
			   echo "status_code:$code"
	           echo -e "=============body start==================="
			   echo "$body"
	           echo -e "=============body   end==================="
			   #if ["`echo $body | grep 'Request unsuccessful. Incapsula incident ID'`"]; then
			   if [ "`echo $body | grep 'Request unsuccessful. Incapsula incident ID'`" ] && [ $code -eq 403 ]; then
			   echo '```'
			   	echo -e "result:<font color="LimeGreen">OK</font>\n"
			   else
			   echo '```'
			   	echo -e "result:<font color="Red">NG</font>\n"
			   fi
	           sleep 3 
			done
        done
done
