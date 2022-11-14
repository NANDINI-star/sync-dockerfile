# How to build this image
Simply drop in a setup.jar for CData Sync 2021 next to the Dockerfile and run:
```
docker build . -t sync
```
By default, this will generate an image that will use a self-signed certificate for https, but if a plaintext deployment is desired (for instances where a load balancer is what provides https), simply rename the ```sync-plaintext.xml``` file to ```sync.xml``` prior to building the image. This will produce an image that is listening on port 8080 in plaintext.

# How to use this image
The simplest way to run CData Sync on Docker is:
```
$ docker run -d sync
```
You can test it by visiting ```https://container-ip:8443``` in a browser. To expose CData Sync to outside requests, publish port 8443 to the host using a port mapping as follows:
```
$ docker run -p 443:8443 -d sync
```
This will map port 8443 inside the container as port 443 on the host. You can then go to ```https://host-ip:443``` in a browser. 

# Configuration

## Volume
You must mount a volume to store application data that must persist after the container is exited. To do this, you can run the container as follows:
```
$ docker run -v /sync:/var/opt/sync \
    -d sync
```
This will mount the /sync folder on the host to the /var/opt/sync folder in the container. 

### Notes:
- This step may not be necessary if an external drive will be mounted inside the container (like an EFS drive for example). In this case, the drive may be mounted directly to /var/opt/sync as long as the permissions remain intact, or the ```APP_DIRECTORY``` environment variable my be adjusted to the desired mount path.

## External Application Databases
The application will use a Derby database for logging transaction data, but can be configured to use an external database like PostgreSQL, SQLServer, or MySQL instead. This can be adjusted within the dockerfile by setting the ```APP_DB``` environment variable, or by providing it when running the container, like so:
```
$ docker run -e APP_DB="jdbc:cdata:postgresql:Server=arc_db;Port=5432;Database=postgres;User=postgres;Password=mysecretpassword;" \
    -d sync
```

## JVM
JVM options can be set by passing the JAVA_OPTIONS environment variable to the container. For example, to set the maximum heap size to 2 gigabytes, you can run the container as follows:
```
$ docker run -e JAVA_OPTIONS="-Xmx2g" \
    -d sync
```

## Time zone
You can set the time zone by passing the TZ enviroment variable to the container. For example, to set the timezone to Shanghai, you can run the container as follows:
```
$ docker run -e TZ=Asia/Shanghai -d sync
```

# What now?
The [Getting Started](https://cdn.cdata.com/help/ASG/sync/index.html) section of the documentation contains the application basics for new users.  
