#!/bin/bash

regenerate=true

while true;
do
    if [ $regenerate = true ]; then
        #&timestamp=$(date +%s)
        qr_key=`curl -sL "${NETEASE_MUSIC_API}/login/qr/key" | jq -r '.data.unikey'`

        curl -sL "${NETEASE_MUSIC_API}/login/qr/create?key=${qr_key}&qrimg=true&timestamp=$(date +%s)" | jq -r '.data.qrimg' | sed -e 's/data:image\/png;base64,//g' | base64 -d > qr.png

        open qr.png

        regenerate=false
    fi

    sleep 5

    curl -sL -c cookie.txt "${NETEASE_MUSIC_API}/login/qr/check?key=${qr_key}&timestamp=$(date +%s)" > qr_status.json

    qr_status=`jq -r '.code' qr_status.json`

    if [ $qr_status -eq 800 ]; then
        regenerate=true
        echo "二维码过期"
    elif [ $qr_status -eq 801 ]; then
        echo "等待扫码"
    elif [ $qr_status -eq 802 ]; then
        echo "等待确认"
    elif [ $qr_status -eq 803 ]; then
        echo "扫码成功"
        break
    fi
done