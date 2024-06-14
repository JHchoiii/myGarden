#!/bin/bash



#이어서 실행하기 위한 "temp" 파일이 존재하는지 확인
if [ $(redis-cli get index) != "(nil)" ]
then
    #"temp" 파일이 존재하면 "continue"를 출력
    echo continue
    #"temp" 파일에서 index와 sum 값 가져오기
    #read index sum < temp
    index=`expr $(redis-cli get index) + 1`
    sum=$(redis-cli get sum)
else
    #"temp" 파일이 존재하지 않으면 index와 sum을 초기화

    index=1
    sum=0
fi

#index 1000번 반복
while [ $index -le 1000 ]
do
    #sum에 index 값을 더하기
    sum=`expr $sum + $index`
    #index 1 증가
    index=`expr $index + 1`

    #sum값 출력
    echo $sum
    #0.01초 동안 대기
    sleep 0.01

    #현재 index와 sum 값을 "temp" 파일에 저장
    redis-cli set index $index
    redis-cli set sum $sum
done

#루프가 끝난 후 "temp" 파일을 삭제
redis-cli set index 0
redis-cli set sum 1
exit 0
