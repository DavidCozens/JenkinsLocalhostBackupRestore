docker run -w /var/jenkins_home --rm --volumes-from jenkinslocalhost-jenkins-1 -v $(pwd):/backup ubuntu tar czf /backup/backup.tgz --exclude={"plugins","workspace",".cache","logs","war","secrets/master.key"} .
docker run -w /var/jenkins_home --rm --volumes-from jenkinslocalhost-jenkins-1 -v $(pwd):/backup ubuntu cp secrets/master.key /backup/master.key
