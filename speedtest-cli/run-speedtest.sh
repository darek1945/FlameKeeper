#!/bin/sh

speedtest --accept-license
speedtest --accept-gdpr

while true; do
  OUTPUT=$(speedtest -f json)
  DOWNLOAD=$(echo $OUTPUT | jq .download.bandwidth)
  UPLOAD=$(echo $OUTPUT | jq .upload.bandwidth)
  PING=$(echo $OUTPUT | jq .ping.latency)

  #check if all variables are set
  if [ ! -z "$DOWNLOAD" ] && [ ! -z "$UPLOAD" ] && [ ! -z "$PING" ]; then
    # convert to Mbit/s
    DOWNLOAD=$(echo "$DOWNLOAD / 125000" | bc -l)
    UPLOAD=$(echo "$UPLOAD / 125000" | bc -l)
    PING=$(echo "$PING" | bc -l)

    # send metrics to pushgateway
    echo "speedtest_download_speed $DOWNLOAD" | curl --data-binary @- http://pushgateway:9091/metrics/job/speedtest
    echo "speedtest_upload_speed $UPLOAD" | curl --data-binary @- http://pushgateway:9091/metrics/job/speedtest
    echo "speedtest_ping $PING" | curl --data-binary @- http://pushgateway:9091/metrics/job/speedtest
  fi

  sleep ${SPEEDTEST_INTERVAL:-3600}
done
