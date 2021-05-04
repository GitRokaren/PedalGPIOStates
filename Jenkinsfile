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
                sh "ls"
                dir("${WORKSPACE}/GPIOPedalJenkins/GPIOPedal/"){
                    sh "ls"
                    sh "python -m robot GPIOPedal.robot"
                }

            }
        }
    }
}
