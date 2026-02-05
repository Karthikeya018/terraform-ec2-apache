pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['PROVISION', 'DEPROVISION'],
            description: 'Choose whether to create or destroy EC2 infrastructure'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION   = 'us-east-2'
    }

    stages {

        stage('Clone GitHub Repo') {
            steps {
                git 'https://github.com/Karthikeya018/terraform-ec2-apache.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            when {
                expression { params.ACTION == 'PROVISION' }
            }
            steps {
                sh 'terraform plan'
            }
        }

        stage('Provision EC2 + Apache') {
            when {
                expression { params.ACTION == 'PROVISION' }
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('De-Provision EC2') {
            when {
                expression { params.ACTION == 'DEPROVISION' }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}
