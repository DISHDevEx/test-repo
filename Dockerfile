#FROM public.ecr.aws/amazonlinux/amazonlinux:2.0.20221210.1-amd64 AS base
FROM --platform=linux/amd64 amazonlinux:2 AS base
RUN yum install -y python3

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /app
COPY . .
RUN pip3 install venv-pack==0.2.0
RUN pip install git+https://github.com/DISHDevEx/msspackages.git
RUN pip install git+https://github.com/DISHDevEx/eks-ml-pipeline.git
RUN  pip install boto3
RUN  pip install pyarrow
RUN  pip install awswrangler
RUN  pip install fast-arrow
RUN  pip install tf2onnx
RUN pwd

RUN mkdir /output && venv-pack -o /output/pyspark_deps_latest.tar.gz

FROM scratch AS export
COPY --from=base /output/pyspark_deps_latest.tar.gz /