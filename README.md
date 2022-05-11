# vivado-docker

Vivado installed into a docker image for CI purposes.

## Build instructions

1. Copy the Vivado installation package `Xilinx_Vivado_2019.2_1106_2127.tar.gz` to this folder.  
   Download from https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html
2. Potentialy modify the `install_config.txt` to change the install options.
3. Build the image (will take about 30 minutes) passing in a build arg
    ```shell
    docker build --build-arg VIVADO_VERSION=2019.1 --build-arg VIVADO_TAR_FILE=Xilinx_Vivado_SDK_2019.1_0524_1430.tar.gz -t vivado:2019.1 .
    ```
    ```shell
    docker build --build-arg VIVADO_VERSION=2019.2 --build-arg VIVADO_TAR_FILE=Xilinx_Vivado_2019.2_1106_2127.tar.gz -t vivado:2019.2 .
    ```


## Running

```shell
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $PWD:/home/vivado/project vivado:2019.1
```
```shell
docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix vivado:2019.2
```
