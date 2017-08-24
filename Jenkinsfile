env.DOCKERHUB_USERNAME = 'nareshdhiman'

node("docker-test") {

  checkout scm
  
  stage("Integration test") {
    sh "echo -------Running Integration test--------------"
    try {
      sh "docker build -t microservice-registration-server ."
      sh "docker rm -f microservice-registration-server || true"
      sh "docker run -d -p 1111:1111 --name=microservice-registration-server microservice-registration-server"
      // sh "docker run --rm -v ${WORKSPACE}:/Microservice_Registration_Server --link=microservice-registration-server java java -jar target/registration-server-0.0.1-SNAPSHOT.jar"   
    } catch(e) {
      error "Integration Test failed"
    } finally {
      sh "echo in finally,removing image"
      sh "docker rm -f microservice-registration-server || true"
    }
  }

  stage("Build") {
    sh "docker build -t ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER} ."
  }
  
  stage("Publish") {
    withDockerRegistry([credentialsId: 'DockerHub']) {
      sh "docker push ${DOCKERHUB_USERNAME}/microservice-registration-server:${BUILD_NUMBER}"
    }
  }
}

node("docker-test") {
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
        // run some final tests in production
        checkout scm
        sh '''
          sleep 60s 
          for i in `seq 1 20`;
          do
            STATUS=$(docker service inspect --format '{{ .UpdateStatus.State }}' microservice-registration-server)
            if [[ "$STATUS" != "updating" ]]; then
              docker run --rm -v ${WORKSPACE}:/microservice-registration-server --network microservice-registration-server java java -jar target/registration-server-0.0.1-SNAPSHOT.jar 
              break
            fi
            sleep 10s
          done
          
        '''
      }catch(e) {
        sh "docker service update --rollback  microservice-registration-server"
        error "Service update failed in production"
      }finally {
        sh "echo in finally,removing image"
        sh "docker ps -aq | xargs docker rm || true"
      }
    }
  }