FROM python:3.9-slim-bullseye
ENV http_proxy=http://genproxy.ORGG.com:8080 https_proxy=http://genproxy.ORGG.com:8080 no_proxy=localhost,127.0.0.1,.corp.ORGG.com
RUN apt-get update && apt-get -y install curl ssh procps vim htop nano git wget
# PYTHON LIBS
RUN python3 -m pip install --upgrade pip
RUN pip3 install mlflow
RUN pip3 install mlflow[pipelines]
RUN pip3 install mlflow[extras]
WORKDIR /root/
ENTRYPOINT ["tail", "-f", "/dev/null"]
