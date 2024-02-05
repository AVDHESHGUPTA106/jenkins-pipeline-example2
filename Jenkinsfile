#!/usr/bin/groovy

def variableMap
pipeline {
    agent any

    tools { 
      maven 'maven' 
      jdk 'Java' 
    }
    stages {
        stage('Terraform init') {
            when {
                branch 'PR-*'
            }
            steps {
                dir(path: 'tf-tuts') {
                sh 'terraform init'
                }
            }
        }
    //    stage('Terraform apply') {
    //        steps {
    //            dir(path: 'tf-tuts') {
    //            script {
    //            withCredentials([aws(credentialsId: "AWS-Jenkins-Credentials")]) {
    //             importTFState("avdhesh15-glo-s3-object-terraform")
    //                sh(
    //                        script: """
    //                                    terraform apply --auto-approve
    //                                """,
    //                        label: "Deploying service layer in AWS"
    //                )
               
    //         //    def dd_ip = sh(returnStdout: true, script: "terraform output public_ip").trim()
    //         //    def region = sh(returnStdout: true, script: "terraform output aws_region").trim()
    //         //    echo dd_ip
    //         //    echo region
    //         //    variableMap = [publicIp : dd_ip, awsRegion:region]
    //            }
    //          }
    //            }
    //        }
    //    }
        
//        stage('Terraform destroy') {
//            steps {
//                script {
//                withCredentials([aws(credentialsId: "AWS-Jenkins-Credentials")]) {
//                sh 'terraform destroy --auto-approve'
//                }
//              }
//            }
//        }

        stage('Build') {
            steps {
                script {
                variableMap = [publicIp : '1.1.1.10.1', awsRegion:'asdfg']
                env.GIT_REPO_NAME = env.GIT_URL.replaceFirst(/^.*?(?::\/\/.*?\/|:)(.*).git$/, '$1')
                env.GIT_ORG_NAME =env.GIT_REPO_NAME.tokenize('/').first()
                env.GIT_SERVICE_NAME =env.GIT_REPO_NAME.tokenize('/').last()
                gitMetaData = gitMetaData(env.GIT_URL)
                env.avdhesh = gitMetaData
                String url = "ap.ni.xyz.io"
                String aws_Service_AccountId = 'svc-'+"${url.replaceAll(".xyz.io", "-deploy")}"
                echo "${aws_Service_AccountId}"
                //def ex = "compile -Dauth0Secret=${variableMap.publicIp} -DawsRegion=${variableMap.awsRegion}"
                def ex = "compile"
                sh 'printenv'
                echo "${env.WORKSPACE}"
                def  FILES_LIST = sh (script: "ls   '${env.WORKSPACE}'", returnStdout: true).trim()
                //DEBUG
                echo "FILES_LIST : ${FILES_LIST}"
                //PARSING
                for(String ele : FILES_LIST.split("\\r?\\n")){ 
                   println ">>>${ele}<<<" 
                   sh "du -sh ${ele}"
                }
                sh 'mkdir -p infrastructure/core-sizing-aws-service/resources'
                //sh script: "find src/main -type f -exec cat {} + | sha256sum > hash.txt"
                def packageOutput = sh(
                        script: "find src/main -type f -exec cat {} + | openssl dgst -binary -sha256 | openssl base64",
                        label: 'Generate hash',
                        returnStdout: true
                        )
                echo packageOutput
              
                runMaven(ex, 'Compile code')
                //sh script: "mvn --no-transfer-progress -B -e compile, label: 'Compiling code'
            }
        }
        }
     }
    post {
       always {
          junit(
        allowEmptyResults: true,
        testResults: '*/test-reports/.xml'
      )
      }
   }
}

String runMaven(final String steps, final String label) {
        echo label
        sh script: "mvn --no-transfer-progress -B -e ${steps}", label: label
}

String gitMetaData(final String giturl){

    def gitOrgRepoName = giturl.replaceFirst(/^.*?(?::\/\/.*?\/|:)(.*).git$/, '$1')
    def gitOrgName = gitOrgRepoName.tokenize('/').first()
    def gitRepoName = gitOrgRepoName.tokenize('/').last()
    map = [gitOrg:gitOrgName, gitRepo:gitRepoName]

    return map
}

def importTFState(s3bucket){
    def bucket_resource = "aws_s3_bucket.b1"
    def statelist = sh(script: "terraform state list || echo >&2 'Ignoring Terraform State List'", returnStdout: true )
    boolean stExist = statelist.trim().split("\n")
                    .findAll { it.contains("${bucket_resource}") }
    if(stExist){ sh script: "terraform state rm ${bucket_resource}" }
    sh script: "terraform import aws_s3_bucket.b1 ${s3bucket} || echo >&2 'Ignoring Terraform State Import'"

    // def statelist = sh(script: "terraform state list", returnStdout: true )
    // boolean stExist = statelist.trim().split("\n")
    //                 .findAll { it.contains("aws_s3_bucket.b1") }

    // def planOutput = sh(script: "terraform plan", returnStdout: true )
    // boolean replacement = planOutput.trim().split("\n")
    //                 .findAll { it.contains("forces replacement") }
    //                 //aws_s3_bucket.b1 will be created


    // if(!stExist || replacement)
    // sh script: "terraform state rm aws_s3_bucket.b1"
    // sh script: "terraform import aws_s3_bucket.b1 avdhesh8-glo-s3-object-terraform"
}
