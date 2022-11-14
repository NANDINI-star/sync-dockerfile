FROM mcr.microsoft.com/openjdk/jdk:11-ubuntu

# copy required files and fix permissions
COPY setup.jar setup.jar
COPY setup.xml setup.xml

RUN java -jar setup.jar setup.xml

COPY sync.xml /opt/cdata/sync/webapp/sync.xml

RUN keytool -keystore keystore -alias cdatasync -genkey -keyalg RSA -storepass cdatasync -keypass cdatasync -dname "CN=CData, OU=CData O=CData, L=Chapel Hill, ST=NC, C=US"
RUN mv keystore /opt/cdata/sync/keystore

RUN addgroup --system --gid 20000 cdatasync \
    && adduser --system --uid 20000 --gid 20000 cdatasync \
    && mkdir -p /var/opt/sync \
    && chown -R cdatasync:cdatasync /var/opt/sync \
    && chown -R cdatasync:cdatasync /opt/cdata/sync

# change user and set environment
USER cdatasync
ENV APP_DIRECTORY=/var/opt/sync

EXPOSE 8443

# run the app
WORKDIR /opt/cdata/sync
CMD ["java","-jar","sync.jar"]