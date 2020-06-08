FROM ubuntu

ARG GIT_REPO_URL=git@github.com:Himanshu-saini/ieeewebsite.git
ARG GIT_REPO_NAME=ieeewebsite

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    python3 \
    python3-pip \
	git \
	nginx

COPY ~/.ssh/id_rsa ~/.ssh/
COPY ~/.ssh/id_rsa.pub ~/.ssh/

RUN git clone $GIT_REPO_URL
WORKDIR ./GIT_REPO_NAME

RUN pip3 install -r requirements-Production.txt

RUN mv ./nginx\ settings/ieeewebsite /etc/nginx/sites-available/ && service nginx restart
RUN mv ./gunicorn\ settings/gunicorn.service /etc/systemd/system/ && service gunicorn start

EXPOSE 80
EXPOSE 443

CMD ["bash"]