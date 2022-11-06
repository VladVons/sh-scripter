ImgName=vladvons/lampp1

ID=$(docker ps -a | grep $ImgName | awk '{print $1}')
docker stop $ID
docker rm $ID

ID=$(docker ps -a | grep "./main" | awk '{print $1}')
docker stop $ID
docker rm $ID

docker rmi $ImgName

ID=$(docker images -a | grep "<none>" | awk '{print $3}')
docker rmi $ID

docker images -a
