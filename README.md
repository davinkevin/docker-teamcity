docker-teamcity
=======================

It is recommended to use a data container to persist the application data : 

```docker run --name teamcity-data -v /opt/teamcity busybox chmod 777 /opt/teamcity```

And run the application container : 

```docker run -dt --volumes-from teamcity-data --name teamcity -p 8080:8080 davinkevin/teamcity```
