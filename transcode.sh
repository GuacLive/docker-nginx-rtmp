#!/bin/ash

on_die ()
{
    # kill all children
    pkill -KILL -P $$
}

trap 'on_die' TERM
echo $(date +[%FT%TZ]) start transcode \"$1\" >> /opt/nginx/logs/transcode.log
/opt/ffmpeg/bin/ffmpeg -re -i rtmp://localhost:1935/$1/$2 \
	-c:a libfdk_aac -b:a 32k  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 128K -f flv rtmp://localhost:1935/hls-live/$2_low \
	-c:a libfdk_aac -b:a 64k  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 256k -f flv rtmp://localhost:1935/hls-live/$2_medium \
	-c:a libfdk_aac -b:a 128k  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 512K -f flv rtmp://localhost:1935/hls-live/$2_high \
	-c copy -f flv rtmp://localhost:1935/hls-live/$2_src 2>> /opt/nginx/logs/transcode.log &
wait
echo $(date +[%FT%TZ]) stop transcode \"$1\" >> /opt/nginx/logs/transcode.log