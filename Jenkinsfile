pipeline {
  agent any

  stages {
    stage('build') {
      steps {
        script {
          def testImage = docker.build("test-image", "./.jenkins/rails")
          testImage.inside('-e HOME="/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}"') {
            sh 'mkdir -p "/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}"'
            sh 'cp config/database.yml.sample config/database.yml'
          }
        }
      }
    }

    stage('reviewdog') {
      environment {
        REVIEWDOG_GITHUB_API_TOKEN = credentials('BMuscleBot')
      }

      steps {
        script {
          def testImage = docker.build("test-image", "./.jenkins/rails")
          testImage.inside('-e REVIEWDOG_INSECURE_SKIP_VERIFY=true -e REVIEWDOG_GITHUB_API_TOKEN=${REVIEWDOG_GITHUB_API_TOKEN} -e CI_COMMIT=${GIT_COMMIT} -e CI_PULL_REQUEST=${CHANGE_ID} -e CI_REPO_NAME=tracker_web -e CI_REPO_OWNER=BMuscle -e HOME="/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}"') {
              sh 'bundle config set path "./vendor/bundle" && bundle install --without development'
              sh 'cd ./front && yarn install'
              sh 'bundle exec rubocop | reviewdog -f=rubocop -reporter=github-pr-review -filter-mode=file'
              sh 'cd ./front && yarn -s lint --no-fix --format stylish | reviewdog -f=eslint -reporter=github-pr-review -filter-mode=file'
              sh 'cd ./front && yarn -s lint-css | reviewdog -f=stylelint -reporter=github-pr-review -filter-mode=file'
          }
        }
      }
    }

    stage('rspec') {
      steps {
        script {
          docker.image('influxdb:2.0').withRun('-e DOCKER_INFLUXDB_INIT_MODE=\"setup\" -e DOCKER_INFLUXDB_INIT_USERNAME=\"tracker\" -e DOCKER_INFLUXDB_INIT_PASSWORD=\"password\" -e DOCKER_INFLUXDB_INIT_ORG=\"tracker\" -e DOCKER_INFLUXDB_INIT_BUCKET=\"tracker_db\" -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=\"token\"') { influx_db ->
            docker.image('mysql:8.0').withRun('-e "MYSQL_ROOT_PASSWORD=password" -e "TZ=Asia/Tokyo"', '--default-authentication-plugin=mysql_native_password') { c ->
              docker.image('mysql:8.0').inside("--link ${c.id}:db") {
                sh 'while ! mysqladmin ping -hdb --silent; do sleep 15; done'
              }
              def testImage = docker.build("test-image", "./.jenkins/rails")
              testImage.inside("--link ${c.id}:db --link ${influx_db.id}:influx_db -e HOME=\"/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}\"") {
                sh 'while ! curl -XGET "influx_db:8086/health"; do sleep 15; done'
                sh 'bundle config set path "./vendor/bundle" && bundle install --without development && bundle exec rails db:create db:migrate RAILS_ENV=test'
                sh 'bundle exec rspec --format p'
              }
            }
          }
        }
      }
    }

    stage('e2e') {
      steps {
        script {
          docker.image('influxdb:2.0').withRun('-e DOCKER_INFLUXDB_INIT_MODE=\"setup\" -e DOCKER_INFLUXDB_INIT_USERNAME=\"tracker\" -e DOCKER_INFLUXDB_INIT_PASSWORD=\"password\" -e DOCKER_INFLUXDB_INIT_ORG=\"tracker\" -e DOCKER_INFLUXDB_INIT_BUCKET=\"tracker_db\" -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=\"token\"') { influx_db ->
            docker.image('mysql:8.0').withRun('-e "MYSQL_ROOT_PASSWORD=password" -e "TZ=Asia/Tokyo"', '--default-authentication-plugin=mysql_native_password') { c ->
              docker.image('mysql:8.0').inside("--link ${c.id}:db") {
                sh 'while ! mysqladmin ping -hdb --silent; do sleep 15; done'
              }
              def testImage = docker.build("test-image", "./.jenkins/rails")
              testImage.inside("--link ${c.id}:db --link ${influx_db.id}:influx_db -e HOME=\"/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}\"") {
                sh 'while ! curl -XGET "influx_db:8086/health"; do sleep 15; done'
                sh 'bundle config set path "./vendor/bundle" && bundle install --without development && bundle exec rails db:create db:migrate RAILS_ENV=test'
                sh 'bundle exec rails s -b localhost -e test -d'
                sh 'cd ./front && yarn install'
                sh 'cd ./front && timeout --kill-after=10 30m yarn test:e2e_cli'
              }
            }
          }
          sh 'docker image prune -f'
        }
      }
    }
  }
}
