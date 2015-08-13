docker-teamcity
=======================

It is recommended to use a data container to persist the application data : 
```docker run --name teamcity-data \
		  -v /opt/teamcity
		  busybox /bin/false```
