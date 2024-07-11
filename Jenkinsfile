#!/usr/bin/groovy

pipeline{
    agent any

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(daysToKeepStr: '14'))
        timeout(time: 10, unit: 'MINUTES')
    }
    // Define parameter that can be used to get the Production and Release Version.
    parameters {
        string(name: 'DEPLOYED_PROD_VERSION', defaultValue: '', description: 'Deployed production version to cut release ticket')
        string(name: 'RELEASE_VERSION', defaultValue: '', description: 'Release Version to cut Release ticket')
        booleanParam(name: 'CUT_RELEASE_TICKET', defaultValue: false, description: 'Cut release ticket')
        string(name: 'TICKET_ID', defaultValue: '', description: 'Ticket Id for post release actions')
   }
    stages {
        stage('Initialize'){
            steps{
                script{
                    if (params.CUT_RELEASE_TICKET.toBoolean()) {
                        stage("Action - ${params.DEPLOYED_PROD_VERSION}") {
                            println("Ticket Release test successful")
                        }
                    }
                    if (params.TICKET_ID?.trim()) {
                        stage("Action - ${params.RELEASE_VERSION}") {
                            println("Post release action test successful")
                        }
                    }
                }
            }
        }
    }
}
