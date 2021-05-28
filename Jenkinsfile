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
        // Publish robot HTML log
        stage('Publish Log') {
            steps {
                echo 'Publish the robot log, making it accessible for everyone on the jenkins server'
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: false, reportDir: '/var/lib/jenkins/workspace/GPIOPedalPipeline/GPIOPedalJenkins/GPIOPedal', reportFiles: 'log.html', reportName: 'HTML Pedal Robot Log', reportTitles: 'Robot Log'])
            }
        }
        // Run the test
        stage('Run Unit Tests') {
            steps {
                dir("${WORKSPACE}/GPIOPedalJenkins/GPIOPedal/"){
                    echo 'Start the pedal simulation'
                    sh "python -m robot GPIOPedal.robot"
                }

            }
        }
        //End of test, publish report
        stage('End of Program') {
            steps {
                echo 'The simulation is finished, view robot log for detailed info on test'
            }
        }            
    }
}

