FROM java

ADD . /Microservice_Registration_Server
RUN java -jar /Microservice_Registration_Server/target/registration-server-0.0.1-SNAPSHOT.jar
CMD /Microservice_Registration_Server

EXPOSE 8080