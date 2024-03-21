#!/usr/bin/groovy
def variableMap

def performanceSlackMsg = [:]

def secretValue

pipeline {
    agent any
    tools { 
      maven 'maven' 
      jdk 'Java' 
    }
// parameters {
//     string(
//       name: "access_token",
//       defaultValue: '',
//       description: "It is an auth0 access token used to access the core sizing lambda API, and it is a mandatory parameter. There is documentation (https://anaplansite.atlassian.net/wiki/spaces/IN/pages/2675312130/Auth0+introduction#How-can-I-manually-get-an-authorization-token-for-testing-purposes) to get a bearer auth0 tenant token, its expiration time is 10800 seconds.",
//     )
// }

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
            environment { 
                AN_ACCESS_KEY = credentials('testcredential') 
            }
            steps {
                script {
                    // withCredentials([string(credentialsId: 'testcredential', variable: 'ACCESS_TOKEN')]) {
                    //     sh 'echo $ACCESS_TOKEN' // Just to verify the token is correctly retrieved
                    //     // Now you can use $ACCESS_TOKEN in your HTTP request header as a Bearer token
                    //     def ss = ACCESS_TOKEN.split("[0-9]*")
                    //     println 'joke.collect { it }=' + ss
                       
                    // }
                    withCredentials([usernamePassword(credentialsId: 'test_tfe_token', usernameVariable: 'gitUserName', passwordVariable: 'github_token')]) {
                        println "UserName/Password  from Jenkins Username: ${gitUserName} , Password: ${github_token}"
                       def token = sh(script: """ echo -n $github_token > tfeToken && cat tfeToken """, returnStdout: true)
                       println token
                       String ttkoen =  env.github_token.toCharArray().join(' ');
                       String tttkoen = ttkoen.join("")
                       println tttkoen
                         def response = sh(script: """ 
                                   curl -s --location --request GET ${env.gitUserName} \\
                                   --header 'Content-Type: application/vnd.api+json' \\
                                   --header 'Authorization: Bearer ${token}'
                              """, returnStdout: true)
                              println response
	                }
                    sh 'echo $AN_ACCESS_KEY' 
                    env.lambdas = ["jenkins-pipeline-example","core-sizing-lambda"]
                    repalceContentFile()
                    //generateModulesHashCode()
               def lastSuccessfulBuildVersion = 0
                def build = currentBuild.previousBuild
                while (build != null) {
                    if (build.result == "SUCCESS")
                    {
                        lastSuccessfulBuildVersion = build.displayName as String
                        println build.displayName
                        break
                    }
                build = build.previousBuild
            }
            println lastSuccessfulBuildVersion


            // read -s "${params.access_token}"

            echo "Your password is masked.${params.access_token}"

                //env.performanceSlackMsg = [:]

                variableMap = [publicIp : '1.1.1.10.1', awsRegion:'asdfg']

                env.GIT_REPO_NAME = env.GIT_URL.replaceFirst(/^.*?(?::\/\/.*?\/|:)(.*).git$/, '$1')
                env.GIT_ORG_NAME =env.GIT_REPO_NAME.tokenize('/').first()
                env.GIT_SERVICE_NAME =env.GIT_REPO_NAME.tokenize('/').last()
                env.branchName = env.GIT_BRANCH.tokenize('/').last()
                gitMetaData = gitMetaData(env.GIT_URL)
                env.avdhesh = gitMetaData
                String url = "ap.ni.xyz.io"
                String aws_Service_AccountId = 'svc-'+"${url.replaceAll(".xyz.io", "-deploy")}"
                echo "${aws_Service_AccountId}"
                //def ex = "compile -Dauth0Secret=${variableMap.publicIp} -DawsRegion=${variableMap.awsRegion}"
                def ex = "compile"
                // sh 'printenv'
                echo "${env.WORKSPACE}"

                performanceSlackMsg['title'] = (performanceSlackMsg['title'] ?: '') + 'newDegradations' + '\n'
                println performanceSlackMsg.isEmpty()
                perfSlack = ''
                performanceSlackMsg.each { title, degradation -> perfSlack += (title + degradation + '\n') }
                echo "${perfSlack}"
                
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

def commitHashForBuild(build) {
  def scmAction = build?.actions.find { action -> action instanceof jenkins.scm.api.SCMRevisionAction }
  return scmAction?.revision?.hash
}

def getLastSuccessfulCommit() {
  def lastSuccessfulHash = null
  def lastSuccessfulBuild = currentBuild.rawBuild.getPreviousSuccessfulBuild()
  if ( lastSuccessfulBuild ) {
    lastSuccessfulHash = commitHashForBuild(lastSuccessfulBuild)
  }
  return lastSuccessfulHash
}

String gitMetaData(final String giturl){
    echo env.branchName
    def gitOrgRepoName = env.GIT_URL.replaceFirst(/^.*?(?::\/\/.*?\/|:)(.*).git$/, '$1')
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

def getLastSuccessfulBuildName(){
    def lastSuccessfulBuildName = 'localhost_26.1.2-newBaseline'
    def build = currentBuild.previousBuild
    while (build != null) {
        if (build.result == "SUCCESS")
            {
                lastSuccessfulBuildName = build.displayName as String
                break
            }
        build = build.previousBuild
        }
    return lastSuccessfulBuildName
}

def generateModulesHashCode() {
    //Generate the source code hash before set the version because after Set Version stage pom.xml & git.properties file version updated
    //Due to that every time will get the new hash code even did not change the source of lambda functions
    sh script:'mvn pro.avodonosov:hashver-maven-plugin:1.6:hashver -DhashVerSnapshotDependencyMode=ignore'
    def hashVersionsProps = readProperties file: "target/hashversions.properties"
    println hashVersionsProps
   
    env.lambdas.replaceAll("\\[|\\]","").tokenize(",").each {
        name = it.trim()
        println name
        println hashVersionsProps[name + ".version"]
        def hcode =  (hashVersionsProps[name + ".version"]).replaceAll(/[^\p{L}\p{N}]/, '')
        println hcode
        env."$name" = hcode
    }
    println "---------------------------------"
    println env.(env.lambdas.replaceAll("\\[|\\]","").tokenize(",")[0])
    println "---------------------------------"
}

def repalceContentFile(){
    // HashMap<String,String> props = readProperties(file: "terraform.auto.tfvars")
    // props.CORE_SIZING_VERSION = env.VERSION
    //  //def propsString = props.collect { k, v -> "$k=\"$v\""}.join("\n")
    // writeFile file: "terraform.auto.tfvars", text: props.toString()
    // def data = readJSON file: 'terraform.auto.tfvars'
    // println data
    // data['CORE_SIZING_VERSION'] = "0.0.2-StoryAK-276-1324302380"
    // writeJSON file: 'terraform.auto.tfvars', json: data,  overwrite: true
    String filenew = readFile("terraform.auto.tfvars").replaceAll('<REPLACE_ME>','0.0.2-StoryAK-276-1324302380')
    writeFile file:"terraform.auto.tfvars", text: filenew
}
