#qrsh -l VEGA20,gpu,highp,h_rt=24:00:00,vega=1
#qrsh -l VEGA20,highp,gpu,h_rt=00:01:00,vega=1
if [ "$HOME" != "/Users/filippomonti" ]; then . /u/local/Modules/default/init/modules.sh; fi
export GPU_DEVICE_ORDINAL=$SGE_HGR_vega
export PATH=/u/home/f/fmonti/lib:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/u/home/f/fmonti/lib
echo "Job $JOB_ID.$SGE_TASK_ID started on:   " `hostname -s`
echo "Date: " `date `
echo "Device: $GPU_DEVICE_ORDINAL" # TODO check if this is correct since the output is 0
echo "Script name $0"

cd $HOME/lib
if [ -d "beagle-libOld" ]; then
  echo "Directory 'beagle-libOld' exists. Deleting it..."
  rm -rf "beagle-libOld"
  echo "Directory deleted."
else
  echo "Directory 'beagle-libOld' does not exist."
fi

if [ -d "beagle-lib" ]; then
  echo "Directory 'beagle-lib' exists. Renaming it to 'beagle-libOld'..."
  mv beagle-lib beagle-libOld
  echo "Directory renamed."
else
  echo "Directory 'beagle-lib' does not exist."
fi
git clone -b hmc-clock http://github.com/beagle-dev/beagle-lib

# One-time per session
source /u/local/Modules/default/init/modules.sh
#module purge
module load gcc
module load cmake
module load cuda
module load amd/rocm

# ensure C++ ABI comes from this gcc
export LD_LIBRARY_PATH="$(dirname "$(gcc -print-file-name=libstdc++.so.6)"):${LD_LIBRARY_PATH:-}"

cd "$HOME/lib/beagle-lib"
##git checkout v4_release
mkdir build
cd build
#cd "$HOME/lib/beagle-lib"
#rm -rf build
#mkdir build && cd build
cmake -DBUILD_CUDA=OFF -DCMAKE_INSTALL_PREFIX="$HOME/usr/local" ..
#OPENCL_ROOT="${ROCM_PATH}/opencl"
#cmake \
#  -DBUILD_CUDA=OFF \
#  -DBUILD_OPENCL=ON \
#  -DOpenCL_INCLUDE_DIR="${OPENCL_ROOT}/include" \
#  -DOpenCL_LIBRARY="${OPENCL_ROOT}/lib/libOpenCL.so" \
#  -DCMAKE_INSTALL_PREFIX="$HOME/usr/local" \
#  ..
make
make install

#ls "$HOME/usr/local/lib"/libhmsbeagle-hip*.so
## should list something like libhmsbeagle-hip.so (and/or .40.0.0)
#
#export LD_LIBRARY_PATH="$HOME/usr/local/lib:$(dirname "$(gcc -print-file-name=libstdc++.so.6)"):${LD_LIBRARY_PATH:-}"
#export ROCR_VISIBLE_DEVICES="${SGE_HGR_vega:-0}"   # respect SGE’s assigned GPU
#
#java -Djava.library.path="$HOME/usr/local/lib" -jar "$BEAST_JAR" -beagle_info | sed -n '1,150p'
# You should see an entry for the HIP/ROCm backend and your VEGA20 device.


#cd $HOME/lib
##git clone http://github.com/beagle-dev/beagle-lib
#cd beagle-lib
##git checkout v4_release
##mkdir build
#cd build
#module load gcc
#module load cmake
#module load cuda
#module load amd/rocm

#mkdir -p "$HOME/usr/local"
#cmake -DBUILD_CUDA=OFF -DCMAKE_INSTALL_PREFIX="$HOME/usr/local" ..
#make -j
#make install

#cmake -DBUILD_CUDA=OFF -DCMAKE_INSTALL_PREFIX=/u/home/a/athos00/usr/local ..  # replace with appropriate path
#make
#make install