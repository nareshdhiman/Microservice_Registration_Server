env.DOCKERHUB_USERNAME = 'nareshdhiman'

node("register-test") {

  checkout scm

  stage("Building") {
    sh "echo -------Running Integration test--------------"
    try {
      sh "docker build -t microservice-registration-server ."
      sh "docker rm -f microservice-registration-server || true"
      sh "docker run --rm -d -p 1111:1111 --name=microservice-registration-server microservice-registration-server"
      // sh "docker run --rm -v ${WORKSPACE}:/Microservice_Registration_Server --link=microservice-registration-server java java -jar target/registration-server-0.0.1-SNAPSHOT.jar"   
    } catch(e) {
      error "Building docker contained failed"
    } finally {
      sh "echo in finally,removing image"
      sh "docker rm -f microservice-registration-server || true"
    }
  }

  stage("Build") {
    sh "echo Building image for local docker respository"
    sh "docker build -t ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER} ."
  }

  stage("Publish") {
    withDockerRegistry([credentialsId: 'DockerHub']) {
      sh "echo Publishing image to docker respository"
      sh "docker push ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER}"
    }
  }
}

  node("register-stage") {
    checkout scm

    stage("Staging") {
      try {
        sh "docker rm -f microservice-registration-server || true"
        sh "docker run -d -p 8080:8080 --name=microservice-registration-server ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER}"
      } catch(e) {
        error "Staging failed"
      } finally {
        sh "docker rm -f microservice-registration-server || true"
        sh "docker ps -aq | xargs docker rm || true"
      }
    }
}

node("register-prod") {
    stage("Production") {
      sh "echo -------Running Production--------------"

      try {
        // Create the service if it doesn't exist otherwise just update the image
        sh '''
          SERVICES=$(docker service ls --filter name=microservice-registration-server --quiet | wc -l)
          if [[ "$SERVICES" -eq 0 ]]; then
            docker network rm microservice-registration-server || true
            docker network create --driver overlay --attachable microservice-registration-server
            docker service create --replicas 1 --network microservice-registration-server --name microservice-registration-server -p 1111:1111 ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER}
          else
            docker service update --image ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER} microservice-registration-server
          fi
          '''
      }catch(e) {
        sh "docker service update --rollback  microservice-registration-server"
        error "Service update failed in production"
      } finally {
        sh "docker ps -aq | xargs docker rm || true"
      }
    }
  }