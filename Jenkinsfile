// This shows a simple example of how to archive the build output artifacts.
node {
    //docker.withServer('tcp://192.168.1.6:2375', null) {

    sh 'printenv'
    if (env.BRANCH_NAME == 'master') {
	checkout scm
        docker.withRegistry('https://registry.ringortc.com:8443', 'docker-registry-credential') {
            def image = docker.build("ubuntu-work:21.04") // ${env.BUILD_ID}
          image.push()
        }
    }
}

