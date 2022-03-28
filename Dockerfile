FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt install curl -y
RUN curl 'https://raw.githubusercontent.com/dev-extended/https-github.com-developeranaz-Ubuntu-Desktop-noVNC-Heroku-VPS-tree-ex/main/install.sh' |bash
COPY novnc.zip /novnc.zip
COPY . /system

RUN unzip -o /novnc.zip -d /usr/share
RUN rm /novnc.zip
FROM mcr.microsoft.com/dotnet/aspnet:6.0
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -yq && apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade -yq && apt-get install -yq apt-utils curl git nano wget unzip python3 python3-pip
RUN curl -sL https://deb.nodesource.com/setup_current.x | bash - && apt-get install -yq nodejs build-essential
RUN echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list.d/debian.list
RUN apt-get update -yq && apt-get install -y --no-install-recommends firefox chromium
RUN pip3 install webdrivermanager || true
RUN webdrivermanager firefox chrome --linkpath /usr/local/bin || true
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
RUN wget $(curl -s https://api.github.com/repos/openbullet/OpenBullet2/releases/latest | grep 'browser_' | cut -d\" -f4)
RUN unzip OpenBullet2.zip
RUN rm OpenBullet2.zip
EXPOSE 5000
CMD ["dotnet", "./OpenBullet2.dll", "--urls=http://*:5000"]

RUN chmod +x /system/conf.d/websockify.sh
RUN chmod +x /system/supervisor.sh

CMD ["/system/supervisor.sh"]
