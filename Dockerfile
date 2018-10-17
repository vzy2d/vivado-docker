FROM ubuntu:16.04

MAINTAINER z4yx <z4yx@users.noreply.github.com>

# build with docker build --build-arg VIVADO_VERSION=2018.1 --build-arg VIVADO_TAR_FILE=Xilinx_Vivado_SDK_2018.1_0405_1.tar.gz -t vivado:2018.1 .

#install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
# * CI (git)
RUN sed -i.bak s/archive.ubuntu.com/mirror.tuna.tsinghua.edu.cn/g /etc/apt/sources.list && \
  apt-get update && apt-get install -y \
  build-essential \
  sudo \
  libxtst6 \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  lsb-release \
  git

ARG VIVADO_VERSION
ARG VIVADO_TAR_FILE

COPY install_config.txt /
COPY ${VIVADO_TAR_FILE} /

# run the install
RUN mkdir /install_vivado && \
  tar -xf ${VIVADO_TAR_FILE} -C /install_vivado && \
  /install_vivado/*/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config /install_config.txt && \
  rm -rf /${VIVADO_TAR_FILE} /install_config.txt /install_vivado

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado
RUN usermod -aG sudo vivado
RUN echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER vivado
WORKDIR /home/vivado
ENV HOME /home/vivado
ENV VIVADO_VERSION ${VIVADO_VERSION}

#add vivado tools to path
RUN echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /home/vivado/.bashrc

#copy in the license file
#RUN mkdir /home/vivado/.Xilinx
#COPY Xilinx.lic /home/vivado/.Xilinx/

CMD ["sh","-c","exec /opt/Xilinx/Vivado/${VIVADO_VERSION}/bin/vivado"]
