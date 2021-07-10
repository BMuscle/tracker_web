pipeline {
  agent none
  stages {
    stage('test') {
      agent any
      steps {
        script {
          docker.image('mysql:8.0').withRun('-e "MYSQL_ROOT_PASSWORD=password" -e "TZ=Asia/Tokyo"', '--default-authentication-plugin=mysql_native_password') { c ->
          docker.image('mysql:8.0').inside("--link ${c.id}:db") {
            sh 'while ! mysqladmin ping -hdb --silent; do sleep 1; done'
          }
          def testImage = docker.build("test-image", "./.jenkins/rspec")
          testImage.inside("--link ${c.id}:db -e TRACKER_DATABASE_PORT=3306 -e TRACKER_DATABASE_HOST=db") {
            sh 'bundle install --path vendor/bundle'
            sh 'cp config/database.yml.sample config/database.yml'
            sh 'bundle exec rails db:create db:migrate'
            sh 'bundle exec rspec'
          }
        }
      }

    }
  }

}
}
