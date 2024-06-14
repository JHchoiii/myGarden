#!/bin/bash

#질문 출력
echo "Do you like an apple?"
#변수 읽기
read answer

#answer에 들어오는 값들 대문자로 변환
case ${answer^^} in
    #answer가 "YES" 또는 "Y"인 경우
    YES | Y)
	 	#메시지 출력
        echo "I like an apple 2" ;;
    #answer가 "NO" 또는 "N"인 경우
    NO | N)
		#메시지를 출력
        echo "sry" ;; 
    #그 외의 모든 경우
    *)
		#"OK" 메시지를 출력
        echo "OK" 
        exit 1 ;;
esac

exit 0

