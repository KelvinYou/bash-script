ps -eaf | grep fnx-mqpos 
kill -9 {pid} 
./startup.sh 
tail -1000f logs/catalina.out
tail -1000f logs/localhost.2023-xx-xx.log




