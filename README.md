# hm-buildroot
This repository hosts setup tools and scripts for automatic download and to generate complete buildroot environments targetted for 'HomeMatic CCU' environments. At the moment these buildroot environments are mainly targetted for creating cross compiler toolchains to build native applications that can be run on a e.g. CCU2 or within RaspberryMatic. In future, however, this repository could host complete build environment to even build new firmware images for HomeMatic/CCU-based control hardware units.

## Installation
Before being able to create a specific CCU toolchain you need to clone the git repository via
```
git clone https://github.com/jens-maus/hm-buildroot.git
```

#### Building:
For building the toolchain a simple 'make' call after having changed to the corresponding CCU type directory should be enough:
```
cd <CCUTYPE>
make
```
Please note, that downloading and building the toolchain might require additional tools and packages (wget, texinfo, etc.) that you first might have to manually install in your Linux environment.

#### Cross-Compilation
After the buildroot toolchain has been build the path to it can be added to your PATH variable so that you can compile binaries using the included cross compilers.
```
export PATH=${PATH}:<CCUTYPE>/build/host/usr/bin
```
Now the cross compiling environment should be available so that you can compile applications using the following compiler versions:

RaspberryMatic: ```arm-buildroot-linux-gnueabihf-gcc```

CCU2: ```arm-none-linux-gnueabi-gcc```

In addition to calling these compilers directly one can also specify the target platform in calls to 'configure'.

### NOTE

Please note that this repository is Work in Progress. If you have any suggestions or want to contribute feel free to do so.
