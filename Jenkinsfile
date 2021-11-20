def ansible = [:]
         ansible.name = 'ansible'
         ansible.host = '172.31.22.197'
         ansible.user = 'centos'
         ansible.password = 'Rnstech@123'
         ansible.allowAnyHosts = true
def kops = [:]
         kops.name = 'kops'
         kops.host = '172.31.19.125'
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
		//sshCommand remote: ansible, command: 'git config --global user.email "vamsitiruvuri4@gmail.com"'
               // sshCommand remote: ansible, command: 'git config --global user.name "vamsitiruvuri"'
                sshCommand remote: ansible, command: 'cd Maven-Java-Project; git pull'
                sshCommand remote: ansible, command: 'cd Maven-Java-Project; ansible-playbook -i hosts tools/sonarqube/sonar-install.yaml'
                sshCommand remote: ansible, command: 'cd Maven-Java-Project; ansible-playbook -i hosts tools/docker/docker-install.yml'   
                     
                //K8s Setup
                sshCommand remote: kops, command: "cd Maven-Java-Project; git pull"
	       sshCommand remote: kops, command: "kubectl apply -f Maven-Java-Project/k8s-code/staging/namespace/staging-ns.yml"
	       sshCommand remote: kops, command: "kubectl apply -f Maven-Java-Project/k8s-code/prod/namespace/prod-ns.yml"
            }            
        }
	    
	

    }
}
