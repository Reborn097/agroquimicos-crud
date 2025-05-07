pipeline {
    agent any

    stages {
        stage('Clonar repositorio') {
            steps {
                git 'https://github.com/Reborn097/agroquimicos-crud.git'
            }
        }

        stage('Compilar') {
            steps {
                sh './gradlew clean build -x test'
            }
        }

        stage('Construir imagen Docker') {
            steps {
                sh 'docker build -t agroquimicos-crud .'
            }
        }

        stage('Levantar contenedores') {
            steps {
                sh 'docker-compose down && docker-compose up -d'
            }
        }
    }
}
