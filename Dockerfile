# Usa Ubuntu 20.04 come immagine di base
FROM ghcr.io/edgetx/edgetx-dev:latest

# Setta l'autore (opzionale)
LABEL maintainer="disantoroberto@gmail.com"

# Evita di avere interazioni durante l'installazione di pacchetti
ENV DEBIAN_FRONTEND=noninteractive

RUN git clone https://github.com/EdgeTX/edgetx.git
WORKDIR /edgetx/
RUN git submodule init
RUN git submodule update --recursive
#git checkout v2.9.1
# meglio usare gitkraken per trovare il commit esatto
#git checkout HASH_QUI # e84a36510e495450e5ef8b2db379f13586918dcf
RUN git checkout e84a36510e495450e5ef8b2db379f13586918dcf

# versione ITA
WORKDIR /edgetx/
RUN mkdir mybuild_ita
WORKDIR mybuild_ita/

RUN cmake -Wno-dev -DPCB=X10 -DPCBREV=T16 \
-DINTERNAL_MODULE_MULTI=YES \
-DDEFAULT_MODE=1 \
-DTRANSLATIONS=IT \
-DLUA_MIXER=Y \
-DCMAKE_BUILD_TYPE=Release \
-DHELI=YES \
-DPPM_UNIT=US \
-DLUA=YES \
-DOVERRIDE_CHANNEL_FUNCTION=YES \
-DMODULE_PROTOCOL_FLEX=YES \
-DBLUETOOTH=YES \
-DINTERNAL_GPS=YES \
-DHARDWARE_EXTERNAL_ACCESS_MOD=YES \
-DGVARS=YES \
../

RUN make configure
RUN make -C arm-none-eabi -j`nproc` firmware
RUN cp arm-none-eabi/firmware.bin edgetx_jumper_t16_ita.bin

# versione ENG
WORKDIR /edgetx/
RUN mkdir mybuild_eng
WORKDIR mybuild_eng/

RUN cmake -Wno-dev -DPCB=X10 -DPCBREV=T16 \
-DINTERNAL_MODULE_MULTI=YES \
-DDEFAULT_MODE=1 \
-DLUA_MIXER=Y \
-DCMAKE_BUILD_TYPE=Release \
-DHELI=YES \
-DPPM_UNIT=US \
-DLUA=YES \
-DOVERRIDE_CHANNEL_FUNCTION=YES \
-DMODULE_PROTOCOL_FLEX=YES \
-DBLUETOOTH=YES \
-DINTERNAL_GPS=YES \
-DHARDWARE_EXTERNAL_ACCESS_MOD=YES \
-DGVARS=YES \
../

RUN make configure
RUN make -C arm-none-eabi -j`nproc` firmware
RUN cp arm-none-eabi/firmware.bin edgetx_jumper_t16_eng.bin
