# Jenkins Localhost Backup Restore

Utilities to backup and restore Jenkins. These utilities are for my own use, but if they help you please feel free to copy and adapt.

The utilities provide a backup solution for Jenkins when running in a container on localhost as defined in <https://github.com/DavidCozens/JenkinsLocalhost>.

To use these utilities after cloning the repo, open in an ubuntu shell to use the bash scripts

## backup.sh

This script presumes that Jenkins has been started using the JenkinsLocalhost configuration mentioned above. *backup.sh* creates two backup files, backup.tgz, and also master.key allowing these files to be seperatly archived. 

## test.sh

This script uses a docker volume called *jenkins_home_test*, executing the script erases the volume, then recreates it and populates it with the content of *backup.tgz* and *master.key*. It then brings up a jenkins server using that volume. Access to this jenkins server is on port <http://localhost:9999>, if external agents need to connect via tcp then they connect via port 50001. These settings allow the backup to be tested without disturbing the main JenkinsLocalhost server.

## Updating jenkins and plugins

My working practice is to automate backups by automatically executing the backup script. Jenkins and associated plugins are always updating and it is good practice from a security point of view to stay up to date. When I decide that I wish to update the version of jenkins I use, the versions of plugins, or I want to add (or remove) a plugin, I follow the process below.

```bash
./backup.sh
./test.sh
```

I then exercise jenkins on <http://localhost:9999> to confirm thatthe backup is working with my current jenkins configuration.

```bash
docker compose down
```

The next step is to rebuild the jenkins image that I use for the server. I use a jenkins job to do this, the job executes the jenkinsfile pipeline from <https://github.com/DavidCozens/Jenkins>, I do this on my main jenkins server, rebuilding the job will create and push a new docker image using the latest lts version of jenklins and the latest versions of my chosen plugins. To test this configuration I use the test.sh script again.

```bash
./test.sh
```

Once the container is up and running I access jenkins on <http://localhost:9999>, I login and jeck the Manage Plugins configuration to confirm that the latest versions of all plugins are loaded. I also execute a couple of jobs to confirm basic operation. I then stop the test jenkins image

```bash
docker compose down
```

If I have a need to add or remove plugins at this stage then I edit plugins.txt in <https://github.com/DavidCozens/Jenkins> and push the file. With my configuration this will cause the jenkins image to be built and pushed again. I test this again by using the *test.sh* script again. Assuming everything is ok I then stop the test jenkins instance and move to updating the main instance.

Updating the main jenkins instance now is as simple as following the instructions in <https://github.com/DavidCozens/JenkinsLocalhost> to stop and restart the server.

### Problems

I have yet to have a problem with this process. My plan to recover if I do is to use the *JENKINS_TAG* value in *.env*, this can be used to control the version of the jenkins image to use for the container, so it can be taken back to the last known working version and held there while the problem is investigated.

As long as the process above is followed the jenkins container in use is always version controlled, all relevent parts of JENKINS_HOME are proven to be backed up successfully to a backup that can be restored. A small change to the *test.sh* script could be used to recreate the main server if required.