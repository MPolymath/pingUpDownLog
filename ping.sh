#!/bin/bash

host=$1
down=0

if [ -z $host ]; then
  echo "Usage: `basename $0` [HOST]"
  exit 1
fi

result=`ping -W 1 -c 1 $host | grep 'bytes from '`
if [ $? -gt 0 ]; then
  echo -e "`date +'%Y/%m/%d %H:%M:%S'` - host $host is \033[0;31mdown\033[0m"
  down=1
else
  echo -e "`date +'%Y/%m/%d %H:%M:%S'` - host $host is \033[0;32mok\033[0m -`echo $result | cut -d ':' -f 2`"
fi

if [ "$result" = "ping: sendmsg: Network is unreachable" ]; then
  echo -e "`date +'%Y/%m/%d %H:%M:%S'` - host $host is \033[0;32mok\033[0m -`echo $result`"
  down=1
fi

while :; do
  result=`ping -W 1 -c 1 $host | grep 'bytes from '`
  if [ $? -gt 0 ]; then
    if [ $down -eq 0 ]; then
      echo -e "`date +'%Y/%m/%d %H:%M:%S'` - host $host is \033[0;31mdown\033[0m"
      down=1
    fi
  else
    if [ $down -eq 1 ]; then
      echo -e "`date +'%Y/%m/%d %H:%M:%S'` - host $host is \033[0;32mok\033[0m -`echo $result | cut -d ':' -f 2`"
      down=0
    fi
    sleep 1 # avoid ping rain
  fi
done
