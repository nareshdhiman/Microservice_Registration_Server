FROM java

ADD ./target/registration-server-0.0.1-SNAPSHOT.jar /registrationservice/
CMD java -jar /registrationservice/registration-server-0.0.1-SNAPSHOT.jar

EXPOSE 8080