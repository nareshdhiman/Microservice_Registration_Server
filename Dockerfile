FROM java:8

# Install maven
RUN apt-get update
RUN apt-get install -y maven

# prepare
ADD pom.xml /code/pom.xml
RUN ["mvn", "dependency:resolve"]
RUN ["mvn", "verify"]

# add source
ADD src /code/src
RUN ["mvn", "package"]

EXPOSE 8080

ADD target /registrationservice/
CMD java -jar target/registration-server-0.0.1-SNAPSHOT.jar