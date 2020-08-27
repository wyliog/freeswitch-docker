FROM centos:7
COPY ./modules.conf /modules.conf
RUN yum install -y https://files.freeswitch.org/repo/yum/centos-release/freeswitch-release-repo-0-1.noarch.rpm epel-release  https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && \
yum clean all && yum install yum-utils && yum-complete-transaction && yum -y update && \
yum install -y git alsa-lib-devel autoconf automake bison broadvoice-devel bzip2 curl-devel libdb4-devel e2fsprogs-devel erlang flite-devel g722_1-devel gcc-c++ gdbm-devel gnutls-devel ilbc2-devel ldns-devel libcodec2-devel libcurl-devel libedit-devel libidn-devel libjpeg-devel libmemcached-devel libogg-devel libsilk-devel libsndfile-devel libtheora-devel libtiff-devel libtool libuuid-devel libvorbis-devel libxml2-devel lua-devel lzo-devel mongo-c-driver-devel ncurses-devel net-snmp-devel openssl-devel opus-devel pcre-devel perl perl-ExtUtils-Embed pkgconfig portaudio-devel postgresql-devel python-devel python-devel soundtouch-devel speex-devel sqlite-devel unbound-devel unixODBC-devel wget which yasm zlib-devel libshout-devel libmpg123-devel lame-devel rpm-build libX11-devel libyuv-devel ffmpeg ffmpeg-devel && \
yum-builddep -y freeswitch 
RUN yum install python-pip && pip install requests
RUN yum install -y yum-plugin-ovl centos-release-scl rpmdevtools yum-utils && \
yum install -y devtoolset-8 && \
scl enable devtoolset-8 'bash' && \
cd /usr/local/src && \
git clone -b v1.10 https://github.com/signalwire/freeswitch.git freeswitch && \
cd /usr/local/src/freeswitch && cp -f  /modules.conf modules.conf &&  \
./bootstrap.sh -j && \
./configure --enable-portable-binary \
            --prefix=/usr --localstatedir=/var --sysconfdir=/etc \
            --with-gnu-ld --with-python --with-erlang --with-openssl \
            --enable-core-odbc-support --enable-zrtp && \
make && \
make -j install && \
make -j cd-sounds-install && \
make -j cd-moh-install

CMD ["/usr/bin/freeswitch","-nonat"]
