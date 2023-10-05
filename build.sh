mkdir -p $PWD/src/output

echo "Spinning staging build container" 

#remove existing or running container
docker container rm -f please_delete_me >/dev/null 2>&1

# The --rm option will remove the container but in case something stuck and you close terminal window it will not
# so naming the container please_delete_me
docker run -v $PWD/src/output:/output -u 0 -i --rm --name please_delete_me ubuntu:20.04 /bin/sh < src/build-zcashd.sh

ZEC_TAG=`cat $PWD/src/output/zec-version.txt 2>/dev/null`
echo $ZEC_TAG
if [ -z "$ZEC_TAG" ]
then
   echo "It appears staging container didn't output needed information. Build interrupted, sorry."
   exit
fi
echo Sucessfully built zcashd version: $ZEC_TAG

container_image_name=zcashd:$ZEC_TAG 

echo "Building minimal container with zcashd"
docker build -t $container_image_name $PWD/src

echo "Build complete, please run 'docker image ls' to see the container it should show: zcashd with TAG: $ZEC_TAG" 

#cleanup
#rm -rf src/output #commented out to keep zcash-cli for manual copy to elsewhere as this is not part of zcashd container
