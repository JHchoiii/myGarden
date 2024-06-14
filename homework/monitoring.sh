#!/bin/bash

#임계치를 설정합니다.
cpuLimit=5 #test를 위한 낮은 cpu임계치 설정
memLimit=80
diskLimit=90

#webhook 함수를 정의
webhook() {
    curl -H "Content-Type: application/json" -d "{\"text\": \"$1 사용량이 임계치를 초과하였습니다.\"}" https://o365kopo.webhook.office.com/webhookb2/1b9b18ca-bb43-4543-8a65-8f096bbe3415@ad21525c-fc0f-4dbc-a403-67ce00add0e4/IncomingWebhook/9df9e7df320b4343a89ecb79d4f4f90c/e121ce81-9987-4377-b475-fc8910920830
}

#무한 루프를 시작
while [ 1 ]
do
    #CPU 사용량을 top 명령어를 사용해 추출
    cpu=$(top -bn1 | sed -n -e '3p' | awk '{print $2}')
    #메모리 사용량을 top 명령어를 사용해 추출하고, 백분률 계산
    mem=$(top -bn1 | sed -n -e '4p' | awk '{printf "%.2f\n", $8 / 915.9 * 100}')
    #디스크 사용량을 df 명령어를 사용해 추출하고, % 기호를 제거
    disk=$(df -h | sed -n -e '3p' | awk '{print $5}' | sed 's/%//')

    #현재 날짜와 시스템 사용량 정보를 출력
    echo ==========================
    date
    echo "CPU: $cpu%"
    echo "Memory: $mem%"
    echo "Disk: $disk%"
    echo ==========================

    #모니터링 정보를 monitor.log 파일에 저장
    {
        echo ==========================
        date
        echo "CPU: $cpu%"
        echo "Memory: $mem%"
        echo "Disk: $disk%"
        echo ==========================
    } >> monitor.log

    #0.8초 동안 대기
    sleep 0.8

    #CPU 사용량을 정수로 변환
    cpu=$(printf "%.0f\n" $cpu)
    #CPU 사용량 임계치 초과 시 경고 메시지를 출력, 로그에 기록, 웹훅 호출
    if [ $cpu -gt $cpuLimit ]
    then
        echo "cpu 사용량이 $cpuLimit%를 초과하였습니다"
        echo "cpu 사용량이 $cpuLimit%를 초과하였습니다" >> monitor.log
        webhook cpu
    fi

    #메모리 사용량을 정수로 변환
    mem=$(printf "%.0f\n" $mem)
    #메모리 사용량 임계치 초과 시 경고 메시지를 출력, 로그에 기록, 웹훅 호출
    if [ $mem -gt $memLimit ]
    then
        echo "memory 사용량이 $memLimit%를 초과하였습니다"
        echo "memory 사용량이 $memLimit%를 초과하였습니다" >> monitor.log
        webhook memory
    fi

    #디스크 사용량 임계치 초과 시 경고 메시지를 출력, 로그에 기록, 웹훅 호출
    if [ $disk -gt $diskLimit ]
    then
        echo "disk 사용량이 $diskLimit%를 초과하였습니다"
        echo "disk 사용량이 $diskLimit%를 초과하였습니다" >> monitor.log
        webhook disk
    fi

done
