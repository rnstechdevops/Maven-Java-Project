def ansible = [:]
         ansible.name = 'ansible'
         ansible.host = '172.31.88.74'
         ansible.user = 'centos'
         ansible.password = 'Rnstech@123'
         ansible.allowAnyHosts = true
def kops = [:]
         kops.name = 'kops'
         kops.host = '172.31.22.79'
         kops.user = 'centos'
         kops.password = 'Rnstech@123'
         kops.allowAnyHosts = true
pipeline {
    agent { label 'buildserver'}

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven"
    }

    stages {
        stage('Prepare-Workspace') {
            steps {
                // Get some code from a GitHub repository
                git credentialsId: 'GitCredentials', url: 'https://github.com/rnstechdevops/Maven-Java-Project.git'    
		stash 'Source'
            }
            
        }
        stage('Tools-Setup') {
            steps {
		    echo "Tools Setup"
		
                sshCommand remote: ansible, command: 'cd Maven-Java-Project; git pull'
                sshCommand remote: ansible, command: 'cd Maven-Java-Project; ansible-playbook -i hosts tools/sonarqube/sonar-install.yaml'
                sshCommand remote: ansible, command: 'cd Maven-Java-Project; ansible-playbook -i hosts tools/docker/docker-install.yml'   
                     
                //K8s Setup
                sshCommand remote: kops, command: "cd Maven-Java-Project; git pull"
	        sshCommand remote: kops, command: "kubectl apply -f Maven-Java-Project/k8s-code/staging/namespace/staging-ns.yml"
	        sshCommand remote: kops, command: "kubectl apply -f Maven-Java-Project/k8s-code/prod/namespace/prod-ns.yml"
            }            
        }
	 
	 stage('SonarQube analysis') {
         
           steps{
                echo "Sonar Scanner"
                  sh "mvn clean compile"
                withSonarQubeEnv('sonar-7') {
		      sh "mvn sonar:sonar "
		       
	        }                     
            }
          }    
	 stage('Unit Test Cases') {
         
          steps{
	       echo "Clean and Test"
              sh "mvn clean test"  
          }
          post{
              success{
		      echo "Clean and Test"
                  junit 'target/surefire-reports/*.xml'
              }
          }
      }
       stage('Build Code') {
        
          steps{
	      unstash 'Source'
              sh "mvn clean package"  
          }
          post{
              success{
                  archiveArtifacts '**/*.war'
              }
          }
      }
      stage('Build Docker Image') {
         
         steps{
                  sh "docker build -t vamsitiruvuri4/webapp ."  
         }
     }
	
    }
}
