declare -r num=7
for (( i=0; i<=$num ; i++ ))
do
	name="test$i"
	nvidia-docker run -dit --name=$name -e NVIDIA_VISIBLE_DEVICES=0 nvidia/cuda /bin/bash

	docker cp /home/mjson/polybench-gpu-1.0 test$i:/polybench
	docker exec test$i nvcc -o /polybench/CUDA/SYRK/syrk /polybench/CUDA/SYRK/syrk.cu
done

start=$(date +%s.%N)
for (( i=0; i<=$num ; i++ ))
do 
	if [ $i -ne $num ];then 
		docker exec test$i nvprof ./polybench/CUDA/SYRK/syrk & 
	else
		docker exec test$i nvprof ./polybench/CUDA/SYRK/syrk
	fi
done

elapsed=`echo "($(date +%s.%N) - $start)" | bc`
echo TOTAL: $elapsed sec

for (( i=0; i<=$num ; i++ ))
do 
	docker stop test$i
	docker rm test$i
done
