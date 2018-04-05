FROM ubuntu:16.04


RUN mkdir genequery
RUN mkdir genequery/front-end
RUN mkdir genequery/back-end
RUN mkdir downloads

RUN apt update && apt install -y git


#Install everything for the front-end


RUN apt-get update && apt-get install -y \
        python \
        build-essential \
        gfortran \
        libatlas-base-dev \
        libpq-dev \
        python-pip \
        python-dev \
	wget \
	zip \
	unzip

RUN cd /genequery/front-end && git clone https://github.com/ctlab/genequery-web.git
RUN cd /genequery && git clone https://github.com/LittleBelka/genequery-docker.git

RUN mkdir genequery/front-end/genequery-web/media
RUN mkdir genequery/front-end/genequery-web/data
RUN mkdir genequery/front-end/genequery-web/node_modules
RUN mkdir genequery/front-end/genequery-web/static/js/dist

RUN cp /genequery/genequery-docker/local_settings.py /genequery/front-end/genequery-web/genequery/settings/

RUN pip install numpy==1.10.1

RUN pip install -r /genequery/front-end/genequery-web/requirements.txt


#Install everything for the back-end


RUN apt-get update && \
        apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update && \
        echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

RUN cd /downloads && wget https://services.gradle.org/distributions/gradle-2.3-bin.zip
RUN mkdir /opt/gradle
RUN unzip -d /opt/gradle /downloads/gradle-2.3-bin.zip

ENV PATH=$PATH:/opt/gradle/gradle-2.3/bin


RUN cd /genequery/back-end && git clone https://github.com/ctlab/genequery-kotlin.git

RUN cd /genequery/back-end/genequery-kotlin/genequery-rest && gradle build

RUN cp /genequery/back-end/genequery-kotlin/genequery-rest/build/libs/gq-rest-1.0-SNAPSHOT.jar \
	/genequery/back-end

RUN mv /genequery/back-end/gq-rest-1.0-SNAPSHOT.jar /genequery/back-end/gq-rest.jar

RUN cp /genequery/genequery-docker/application.properties /genequery/back-end/

RUN mkdir genequery/back-end/data-files


EXPOSE 8000

ENTRYPOINT cd /genequery/back-end && java \
           -Xmx4096M \
           -Dspring.config.location=./application.properties \
           -jar ./gq-rest.jar \
	   & \
	   cd /genequery/front-end/genequery-web && python ./manage.py runserver 0.0.0.0:8000

