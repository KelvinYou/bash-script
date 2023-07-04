
MQPOSPAYMENT_PID=$(ps -ef | pgrep -f /disk1/tomcat-instances/fnx-fintech-mqpos)
MERC_SYNC_PID=$(ps -ef | pgrep -f /disk1/fnx-fintech-mqpos/fnx-merchant-sync/lib/)
HLH_PID=$(ps -ef | pgrep -f /disk1/fnx-fintech-mqpos-hlh/bin/hsm.properties)
HLH2_PID=$(ps -ef | pgrep -f /disk1/fnx-fintech-mqpos-hlh2/bin/hsm.properties)

echo "MQPOSPAYMENT_PID: $MQPOSPAYMENT_PID"
echo "MERC_SYNC_PID: $MERC_SYNC_PID"
echo "HLH_PID: $HLH_PID"
echo "HLH2_PID: $HLH2_PID"