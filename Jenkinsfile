env.DOCKERHUB_USERNAME = 'nareshdhiman'

node("docker-test") {

  checkout scm
  
  stage("Integration test") {
    try {
      sh "docker build -t microservice-registration-server ."
      sh "docker rm -f microservice-registration-server || true"
      sh "docker run -d -p 8080:8080 --name=microservice-registration-server microservice-registration-server"
    } catch(e) {
      error "Integration Test failed"
    } finally {
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