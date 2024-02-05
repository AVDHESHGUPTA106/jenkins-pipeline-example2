pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'GitCredentials', url: 'https://github.com/AVDHESHGUPTA106/tf-tuts'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                script {
                withCredentials([aws(credentialsId: "AWS-Jenkins-Credentials")]) {
                sh 'terraform apply --auto-approve'
                def dd_ip = sh(returnStdout: true, script: "terraform output public_ip").trim()
                def region = sh(returnStdout: true, script: "terraform output aws_region").trim()
                echo dd_ip
                echo region
                }
              }
            }
        }
        stage('Terraform destroy') {
            steps {
                script {
                withCredentials([aws(credentialsId: "AWS-Jenkins-Credentials")]) {
                sh 'terraform destroy --auto-approve'
                }
              }
            }
        }
        
    }
}
