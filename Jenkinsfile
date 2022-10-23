node('docker') {

    stage('checkout') {
        sh 'printenv'
	    checkout scm
    }

    stage('build') {
        docker.withRegistry("${DOCKER_REGISTRY}", "${DOCKER_REGISTRY_CREDENTIAL}") {
            def image = docker.build("docker/ubuntu-work:latest")
            image.push()
        }
    }
}

