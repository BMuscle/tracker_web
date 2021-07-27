pipeline {
  agent any

  stages {
    stage('build') {
      steps {
        script {
          def testImage = docker.build("test-image", "./.jenkins/rspec")
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
          def testImage = docker.build("test-image", "./.jenkins/reviewdog")
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
          docker.image('mysql:8.0').withRun('-e "MYSQL_ROOT_PASSWORD=password" -e "TZ=Asia/Tokyo"', '--default-authentication-plugin=mysql_native_password') { c ->
            docker.image('mysql:8.0').inside("--link ${c.id}:db") {
              sh 'while ! mysqladmin ping -hdb --silent; do sleep 1; done'
            }
            def testImage = docker.build("test-image", "./.jenkins/rspec")
            testImage.inside("--link ${c.id}:db -e TRACKER_DATABASE_PORT=3306 -e TRACKER_DATABASE_HOST=db -e TRACKER_FRONT_URL=localhost:8080 -e HOME=\"/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}\"") {
              sh 'bundle config set path "./vendor/bundle" && bundle install --without development && bundle exec rails db:create db:migrate RAILS_ENV=test'
              sh 'bundle exec rspec --format p'
            }
          }
        }
      }
    }

    stage('e2e') {
      steps {
        script {
          docker.image('mysql:8.0').withRun('-e "MYSQL_ROOT_PASSWORD=password" -e "TZ=Asia/Tokyo"', '--default-authentication-plugin=mysql_native_password') { c ->
            docker.image('mysql:8.0').inside("--link ${c.id}:db") {
              sh 'while ! mysqladmin ping -hdb --silent; do sleep 1; done'
            }
            def testImage = docker.build("test-image", "./.jenkins/e2e")
            testImage.inside("--link ${c.id}:db -e TRACKER_DATABASE_PORT=3306 -e TRACKER_DATABASE_HOST=db -e TRACKER_FRONT_URL=localhost:8080 -e TRACKER_ALLOW_ORIGINS=localhost:8080 -e VUE_APP_BACK_END_API_URL=http://localhost:3000 -e VUE_APP_FRONT_END_URL=http://localhost:8080 -e HOME=\"/tmp/bundler/${JOB_NAME}/${BUILD_NUMBER}\"") {
                sh 'bundle config set path "./vendor/bundle" && bundle install --without development && bundle exec rails db:create db:migrate RAILS_ENV=test'
                sh 'bundle exec rails s -b localhost -e test -d'
                sh 'cd ./front && yarn install'
                sh 'cd ./front && timeout --kill-after=10 5m yarn test:e2e_cli'
            }
          }
        }
      }
    }
  }
}
