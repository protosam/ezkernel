FROM fedora:latest
RUN dnf install -y gcc flex make bison openssl-devel elfutils-libelf-devel ncurses-devel xz diffutils bc findutils perl vim less kmod \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum