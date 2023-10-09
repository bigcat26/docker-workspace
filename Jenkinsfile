node('docker') {

    stage('checkout') {
        checkout scm
    }

    stage('build') {
        docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_REGISTRY_CREDENTIAL}") {
            def image = docker.build("docker/ubuntu-workspace:latest")
            image.push()
        }
    }
}

