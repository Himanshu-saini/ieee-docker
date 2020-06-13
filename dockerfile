FROM ubuntu

ARG GIT_REPO_URL=git@github.com:Himanshu-saini/ieeewebsite.git
ARG GIT_REPO_NAME=ieeewebsite
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    python3 \
    python3-pip \
	git \
	nginx

COPY ./id_rsa /root/.ssh/
COPY ./id_rsa.pub /root/.ssh/

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone $GIT_REPO_URL
WORKDIR ./$GIT_REPO_NAME

RUN pip3 install -r requirements-Production.txt
RUN python3 -m site
RUN which python3
RUN mv ./nginx\ settings/ieeewebsite /etc/nginx/sites-available/ && service nginx restart
RUN mv ./gunicorn\ settings/gunicorn_docker.service /etc/systemd/system/gunicorn.service && service gunicorn start

EXPOSE 80
EXPOSE 443

CMD ["bash"]