nvidia-docker run -dit --name="test1" -e NVIDIA_VISIBLE_DEVICES=0 nvidia/cuda /bin/bash
nvidia-docker run -dit --name="test2" -e NVIDIA_VISIBLE_DEVICES=0 nvidia/cuda /bin/bash

docker cp /home/mjson/polybench-gpu-1.0 test1:/polybench
docker cp /home/mjson/polybench-gpu-1.0 test2:/polybench

docker exec test1 nvcc -o /polybench/CUDA/ATAX/atax /polybench/CUDA/ATAX/atax.cu
docker exec test2 nvcc -o /polybench/CUDA/MVT/mvt /polybench/CUDA/MVT/mvt.cu
#docker exec test2 nvcc -o /polybench/CUDA/2MM/2mm /polybench/CUDA/2MM/2mm.cu

start=$(date +%s.%N)
#docker exec test1 nvprof ./polybench/CUDA/ATAX/atax &
#docker exec test2 nvprof ./polybench/CUDA/MVT/mvt
#docker exec test2 nvprof ./polybench/CUDA/2MM/2mm

t1=$(date +%s.%N)
docker exec test1 nvprof -m tex_cache_hit_rate ./polybench/CUDA/ATAX/atax &
#docker exec test1 ./polybench/CUDA/ATAX/atax 
t2=$(date +%s.%N)
docker exec test2 nvprof -m tex_cache_hit_rate ./polybench/CUDA/MVT/mvt
#docker exec test2 ./polybench/CUDA/MVT/mvt
t3=$(date +%s.%N)
#docker exec test2 nvprof -m tex_cache_hit_rate ./polybench/CUDA/2MM/2mm

elapsed3=`echo "($t3 - $t2)" | bc`
elapsed2=`echo "($t2 - $t1)" | bc`
elapsed=`echo "($(date +%s.%N) - $start)" | bc`
echo TOTAL: $elapsed sec
echo TOTAL1: $elapsed2 sec
echo TOTAL2: $elapsed3 sec

docker stop test1
docker stop test2
docker rm test1
docker rm test2
