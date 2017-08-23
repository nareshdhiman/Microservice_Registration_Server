FROM java

ADD . /Microservice_Registration_Server
CMD java -jar target/registration-server-0.0.1-SNAPSHOT.jar

EXPOSE 8080