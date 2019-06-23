# https://adhoctuts.com/run-mulitple-databases-in-single-machine-using-docker-vagrant/

#####################################################################
## docker-compose commands, works with service names ################
## docker-compose will look for docker-compose.yml file by default ##
#####################################################################

docker-compose up -d # build and start all the containers
docker-compose up -d service_name # build and start specific container

# stop and remove all the containers, 
# removes all the data unless the data persistence is specified
docker-compose down 
docker-compose rm -f -s service_name # remove the specific container

docker-compose down && docker-compose up -d # recreate all the containers

docker-compose start # start all the containers
docker-compose start service_name # start specific container
docker-compose stop # stop all the containers
docker-compose stop service_name # stop specific container

docker-compose up --no-start # create but do not start all the containers

docker-compose logs service_name # view container logs

#################################################
## docker commands, works with container names ##
#################################################

docker ps -a # view the container list
docker exec -it container_name bash # access command line of the container
docker start $(docker ps -aq) # start all the containers
docker start container_name # stop the specific container
docker stop container_name # stop the specific container
docker rm -f container_name # stop and remove containers

# execute specific script from within container
docker exec -it container_name sh -c 'exec /scripts/my.sh'