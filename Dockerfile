FROM debian:testing

LABEL maintainer Diego Diez <diego10ruiz@gmail.com>

ENV VERSION=3.2.6

RUN apt-get update -y && \
    apt-get install -y \
      gcc \
      make \
      automake \
      curl \
      libopenmpi-dev \
      libhmsbeagle1v5 \
      libhmsbeagle-dev \
      ssh \
      && \
      curl -L https://sourceforge.net/projects/mrbayes/files/mrbayes/$VERSION/mrbayes-$VERSION.tar.gz > /tmp/mrbayes-$VERSION.tar.gz && \
      cd /tmp && \
      tar xfzv mrbayes-$VERSION.tar.gz && \
      cd mrbayes-$VERSION/src && \
      autoconf && \
      ./configure --with-beagle=/usr --enable-mpi=yes --prefix=/opt && \
      make && make install && \

      cd /tmp && \
      rm -rf /tmp/mrbayes-$VERSION && \
      rm mrbayes-$VERSION.tar.gz && \
      apt-get clean -y && \
      apt-get purge -y gcc make automake curl && \
      apt-get autoremove -y


ENV PATH /opt/bin:$PATH

RUN useradd -ms /bin/bash biodev
RUN echo 'biodev:biodev' | chpasswd
USER biodev
WORKDIR /home/biodev

CMD ["/bin/bash"]
