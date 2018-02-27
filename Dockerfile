FROM openkbs/docker-hpc-base


MAINTAINER DrSnowbird "openkbs.org@gmail.com"

#### -----------------------
#### ---- Build GAMESS -----
#### -----------------------
ARG GAMESS_INSTALL_DIR=${GAMESS_INSTALL_DIR:-/home/root/benchmarks}
ARG GAMESS_HOME=${GAMESS_HOME:-/home/root/benchmarks/GAMESS/ABTP/app/gamess}
ENV GAMESS_HOME=${GAMESS_HOME:-/home/root/benchmarks/GAMESS/ABTP/app/gamess}
ARG GAMESS_RUN_DIR=${GAMESS_RUN_DIR:-/home/root/benchmarks/GAMESS/ABTP/ded/gamess/dft-grad-b}
ENV GAMESS_RUN_DIR=${GAMESS_RUN_DIR:-/home/root/benchmarks/GAMESS/ABTP/ded/gamess/dft-grad-b}
ENV GAMESSBIN=${GAMESS_HOME}/bin

WORKDIR /home/root

ARG GAMESS_TAR=GAMESS.tar.gz

COPY ${GAMESS_TAR} ./
RUN mkdir -p ${GAMESS_INSTALL_DIR} && \
    mv ${GAMESS_TAR} ${GAMESS_INSTALL_DIR}/ && \
    cd ${GAMESS_INSTALL_DIR} && \
    tar xvfz ${GAMESS_TAR} 

#COPY override/install.info ${GAMESS_HOME}/
#COPY override/gamess_build.txt ${GAMESS_HOME}/
#COPY override/rungms.mpi ${GAMESS_HOME}/bin/
#COPY override/gamess_dft-grad-b_1024.bat ${GAMESS_RUN_DIR}/

RUN cd ${GAMESS_HOME} && ls -al ${GAMESS_HOME} && echo "current dir: `pwd`" && \
    chmod +x ${GAMESS_HOME}/gamess_build.txt && \
    /bin/bash ${GAMESS_HOME}/gamess_build.txt && \
    mv gamess.00.x ${GAMESS_HOME}/bin/

RUN rm -f ${GAMESS_INSTALL_DIR}/${GAMESS_TAR} && \
    ln -s /bin/csh /usr/bin/csh && \
    ln -s /bin/bash /usr/bin/bash

#COPY override/install.info ${GAMESS_HOME}/
#COPY override/gamess_build.txt ${GAMESS_HOME}/
#COPY override/rungms.mpi ${GAMESS_HOME}/bin/
#COPY override/gamess_dft-grad-b_1024.bat ${GAMESS_RUN_DIR}/

COPY entrypoint.sh /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]

#### ---- When ready, uncomment this line below ----
#CMD "${GAMESS_RUN_DIR}/gamess_dft-grad-b.bat" "392" "28"
CMD ["/bin/bash"]
