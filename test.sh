docker volume rm jenkins_home_test
docker run --rm -w /var/jenkins_home -v jenkins_home_test:/var/jenkins_home -v $(pwd):/backup ubuntu tar xvf /backup/backup.tgz
docker run --rm -w /var/jenkins_home -v jenkins_home_test:/var/jenkins_home -v $(pwd):/backup ubuntu cp /backup/master.key secrets/master.key
docker compose up &