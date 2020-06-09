FROM ubuntu

ARG GIT_REPO_URL=git@github.com:Himanshu-saini/ieeewebsite.git
ARG GIT_REPO_NAME=ieeewebsite
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    python3 \
    python3-pip \
	git \
	nginx

COPY ./id_rsa /home/ubuntu/.ssh/
COPY ./id_rsa.pub /home/ubuntu/.ssh/

RUN pwd
RUN ls -a /home/ubuntu/
RUN ls -a /home/ubuntu/.ssh/

RUN git clone $GIT_REPO_URL
WORKDIR ./GIT_REPO_NAME

RUN pip3 install -r requirements-Production.txt

RUN mv ./nginx\ settings/ieeewebsite /etc/nginx/sites-available/ && service nginx restart
RUN mv ./gunicorn\ settings/gunicorn.service /etc/systemd/system/ && service gunicorn start

EXPOSE 80
EXPOSE 443

CMD ["bash"]