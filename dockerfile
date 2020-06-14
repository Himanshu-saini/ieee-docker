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

WORKDIR /home/
RUN git clone $GIT_REPO_URL
WORKDIR ./$GIT_REPO_NAME

RUN pip3 install -r requirements-Production.txt

COPY ["./gunicorn settings/gunicorn.service", "/etc/systemd/system/"]
RUN chmod 755 /lib/systemd/system/gunicorn.service
RUN service gunicorn start

COPY ["./nginx settings/ieeewebsite", "/etc/nginx/sites-available/"]
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
	&& unlink /etc/nginx/sites-enabled/default \
	&& ln -s /etc/nginx/sites-available/ieeewebsite /etc/nginx/sites-enabled

EXPOSE 80
EXPOSE 443

CMD ["service","nginx","restart"]