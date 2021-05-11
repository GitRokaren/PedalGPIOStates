/* 
Authors: Jonatan Ryd & Jeffrey Persson
Date: 2021-05-04
Test: Running a Robotframework test on target RaspberryPi 
*/
pipeline {
    agent any 
    stages {
        // Connecting GitHub to user email
        stage('Connect GitHub') {
            steps {
                echo 'Run the security check against the application' 
                sh "git config --global user.email jeffes159@gmail.com"
            }
        }
        // Run the test
        stage('Run Unit Tests') {
            steps {
                dir("${WORKSPACE}/GPIOPedalJenkins/GPIOPedal/"){
                    sh "python -m robot GPIOPedal.robot"
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: false, reportDir: '/var/lib/jenkins/workspace/GPIOPedalPipeline/GPIOPedalJenkins/GPIOPedal', reportFiles: 'log.html', reportName: 'HTML Pedal Robot Log', reportTitles: 'Robot Log'])
                }

            }
        }
        //End of test, publish report
        stage('End of Program') {
            steps {
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: false, reportDir: '/var/lib/jenkins/workspace/GPIOPedalPipeline/GPIOPedalJenkins/GPIOPedal', reportFiles: 'log.html', reportName: 'HTML Pedal Robot Log', reportTitles: 'Robot Log'])
            }
        }            
    }
}
