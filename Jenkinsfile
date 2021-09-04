// This shows a simple example of how to archive the build output artifacts.
node {
    //docker.withServer('tcp://192.168.1.6:2375', null) {
        //docker.image('gcc:9.4').inside {
        stage('Checkout') {
            checkout scm
        }

        stage("Docker build") {
            sh "docker build . --rm -t ubuntu-work:21.04"
        }

        stage("Push image to registry") {
            // Archive the build output artifacts.
            //archiveArtifacts artifacts: 'output/*.txt', excludes: 'output/*.md'
        }
}
