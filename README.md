# msg-sdk-cpp
An end-to-end encrypted cli messaging sdk based on the Noise Protocol, using sockets and tcp transports.

## Build

#### 1. Clone Source
    git clone https://github.com/codehubbers/msg-sdk-cpp.git
    cd msg-sdk-cpp

#### 2. Build
    mkdir build
    cd build
    ../configure
    make

## Install
    make install

## Requirements

Download a bash command line environment to run configure.

Download git to use the git command for cloning the source.

Download gcc to compile the source and configure it.

Download make to compile the library.

Download noiseprotocol library to use the Noise Protocol offered by efecan0 if can not find download then compile it from source can be found and analysed here

If the bash command line environment supports the pacman command do

    pacman -S git
    pacman -S mingw-w64-x86_64-gcc
    pacman -S mingw-w64-x86_64-g++
    pacman -S make
    pacman -S mingw-w64-x86_64-autotools
    pacman -S bison
    pacman -S flex
    git clone https://github.com/CoderRC/libmingw32_extended.git
    cd libmingw32_extended
    mkdir build
    cd build
    ../configure
    make
    make install
    cd ../..
    git clone https://github.com/CoderRC/noise-c.git
    cd noise-c
    ./autogen.sh
    mkdir build
    cd build
    ../configure LDFLAGS=-lmingw32_extended
    make
    make install
    cd ../..
    git clone https://github.com/codehubbers/msg-sdk-cpp.git
    cd msg-sdk-cpp
    mkdir build
    cd build
    ../configure LDFLAGS=-lmingw32_extended
    make

## Tests

Go to the tests branch to create tests for this repository.

## Contributing to the source

To properly add new sources to the repository, the sources must be added to the source directory in the repository and in the configure file add paths to the SOURCES.

To properly add new include directories to the repository, the include directories must be added to the include directory in the repository and in the configure file add include paths to the INCLUDE_DIRECTORIES.

To properly add new headers to the repository, the headers must be added to the include directory in the repository and in the configure file add paths to the INCLUDE_FILES.

## Functions Completed and Can Be Used In Your Projects:
none for now just connect_to_host made to be an example