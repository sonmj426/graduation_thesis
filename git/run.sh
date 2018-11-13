nvidia-docker run -dit --name="test1" -e NVIDIA_VISIBLE_DEVICES=2 nvidia/cuda /bin/bash
nvidia-docker run -dit --name="test2" -e NVIDIA_VISIBLE_DEVICES=2 nvidia/cuda /bin/bash

docker cp /home/mjson/polybench-gpu-1.0 test1:/polybench
docker cp /home/mjson/polybench-gpu-1.0 test2:/polybench

docker exec test1 nvcc -o /polybench/CUDA/ATAX/atax /polybench/CUDA/ATAX/atax.cu
docker exec test2 nvcc -o /polybench/CUDA/ATAX/atax /polybench/CUDA/ATAX/atax.cu

start=$(date +%s.%N)
docker exec test1 ./polybench/CUDA/ATAX/atax &
docker exec test2 ./polybench/CUDA/ATAX/atax #&
#nvprof polybench-gpu-1.0/CUDA/ATAX/atax
#docker exec test1 ./polybench/CUDA/ATAX/atax 
#docker exec test1 nvprof -m tex_cache_hit_rate ./polybench/CUDA/ATAX/atax
#docker exec test2 nvprof -m tex_cache_hit_rate ./polybench/CUDA/SYR2K/syr2k

elapsed=`echo "($(date +%s.%N) - $start)" | bc`
echo TOTAL: $elapsed sec

docker stop test1
docker stop test2
docker rm test1
docker rm test2
