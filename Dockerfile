# syntax=docker/dockerfile:1
FROM python:3.10 AS base
WORKDIR /usr/src/cifar-training
RUN python -m pip install pip-tools
RUN --mount=type=bind,source=.,target=/usr/src/cifar-training  pip-compile --all-build-deps \
    --output-file=/opt/build-constraints.txt --strip-extras pyproject.toml

FROM nvcr.io/nvidia/jax:24.04-py3
COPY --from=base /opt/build-constraints.txt /opt/build-constraints.txt
WORKDIR /opt 
RUN pip install --upgrade-strategy only-if-needed  -r  build-constraints.txt

# RUN --mount=type=bind,source=pyproject.toml,target=/usr/src/cifar-training/pyproject.toml pip install -r pyproject.toml
# RUN pip install clu tensorflow==2.12.1 tensorflow-datasets flax==0.8.4
# RUN pip install jax[tpu] -f https://storage.googleapis.com/jax-releases/libtpu_releases.html
# RUN pip install sagemaker-training
# COPY train.py /opt/ml/code/marvik_demo.py
# ENV SAGEMAKER_PROGRAM=marvik_demo.py
# WORKDIR /opt/ml/code
# ENTRYPOINT []
# CMD [ "python", "marvik_demo.py" ]