yes N | aliBuild init O2@dev
yes N | aliBuild --defaults o2 build O2 --debug --jobs 8
alienv load O2/latest
source /root/alice/O2/GPU/GPUTracking/Standalone/cmake/prepare.sh
cmake -DCMAKE_INSTALL_PREFIX=../ ~/alice/O2/GPU/GPUTracking/Standalone/
make install -j8
./ca -e o2-pbpb-100 -g --gpuType CUDA --gpuDevice 0 --debug 1

