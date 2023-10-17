FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-devel

ENV TZ=Pacific/Auckland \
  DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install wget ffmpeg libglm-dev -y \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
  && echo "634d76df5e489c44ade4085552b97bebc786d49245ed1a830022b0b406de5817 Miniconda3-latest-Linux-x86_64.sh" | sha256sum --check

RUN bash ./Miniconda3-latest-Linux-x86_64.sh -b

RUN conda init

COPY environment.yml .
COPY submodules/ submodules/

ENV TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
RUN conda env create --file environment.yml

RUN echo "conda activate gaussian_splatting" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

COPY . .

CMD ["process.sh"]
