FROM java:8

# Install maven
RUN apt-get update
RUN apt-get install -y maven

# prepare
ADD pom.xml /code/pom.xml
WORKDIR /code
RUN ["mvn", "dependency:resolve"]
#RUN ["mvn", "verify"]

# add source
ADD src /code/src
RUN ["mvn", "package"]

EXPOSE 8080

# ADD  /code/target/registration-server-0.0.1-SNAPSHOT.jar /code/registration-server-0.0.1-SNAPSHOT.jar
CMD java -jar target/registration-server-0.0.1-SNAPSHOT.jar