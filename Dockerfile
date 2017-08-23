FROM java

ADD target /registrationservice/
CMD java -jar /registrationservice/registration-server-0.0.1-SNAPSHOT.jar

EXPOSE 8080