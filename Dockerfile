# podman run --init -dit -v alice:/root/alice -v standalone:/root/standalone -v events:/root/standalone/events -v /home/orietman/.ssh:/root/.ssh:ro,z --device nvidia.com/gpu=0 --security-opt=label=disable --name=o2-standalone 4aed16ce86e8 sh -c "git config --global user.signingkey /root/.ssh/id_ecdsa.pub; tail -f /dev/null"

# cern/alma9-base:latest
# registry.cern.ch/docker.io/almalinux/9-base:9.5-20250411
FROM cern/alma9-base:20250501-1.x86_64

VOLUME /root/alice
VOLUME /root/standalone
VOLUME /root/standalone/events

COPY alice-system-deps.repo /etc/yum.repos.d/alice-system-deps.repo
COPY bash_history /root/.bash_history

ENV PATH="$PATH:/usr/local/cuda/bin"
ENV ALIBUILD_WORK_DIR="/root/alice/sw"

WORKDIR /root

RUN rm -f /root/anaconda-ks.cfg /root/original-ks.cfg \
    && dnf install -y 'dnf-command(config-manager)' \
    && dnf config-manager --add-repo https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo \
    && dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo \
    && dnf install -y nvidia-container-toolkit cuda-cudart-devel-12-8 cuda-nvcc-12-8 cuda-profiler-api-12-8 cuda-nvrtc-devel-12-8 \
    && dnf config-manager --set-enabled crb \
    && dnf install -y epel-release \
    && dnf group install -y 'Development Tools' \
    && dnf install -y alice-o2-full-deps alibuild \
    && dnf install -y glfw-devel freeglut-devel \
    && dnf clean all

CMD ["tail", "-f", "/dev/null"]

