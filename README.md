
# Enginsight Enterprise 
Worried about the security of your infrastructure? Having troubles monitoring your systems round the clock? Well, no more, sit back while Enginsight does this for you. 
The Enterprise solution is here, the magical potion to your plight. You can operate the platform on your very own servers. A fast and easy installation process built upon Docker, 
access all Enginsight functions remotely on your server. 

For more information regarding the Enterprise solution? Visit [enginsight.com](https://enginsight.com/enterprise/).

## Prerequisites
1. MongoDB replica set
    1. [MongoDB Cloud Services](https://www.mongodb.com/cloud) free version is enough for testing purposes.
    2. [Self-hosted](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/)
    **_It is strongly recommended to have more than one instance in your Mogo Replica Set_.**
2. Operating system: (either)
    1. Ubuntu/Debian
    2. CentOS/Redhat/OpenSuse
3. Create user at [Docker Hub](https://id.docker.com/login/). 

4. Enginsight License. Please contact hello@enginsight.com for a license.



## Quick Start Guide (for testing purposes only)
Follow the steps below for a short trial view and get the real experience. 
1. Set the following credentials in your console.
    ```bash
    export DOCKER_USERNAME=<docker hub username>
    ```
    ```bash
    export DOCKER_PASSWORD=<docker hub password>
    ```
    ```bash 
    export MONGODB_URI=<Mongo replica set uri>
    ```
2. Run command  
	```bash
	curl -sSL https://raw.githubusercontent.com/enginsight/enterprise/master/quickstart/debian-9.sh | sudo -E 
	```

	**_Please note: This version supports Debian 9 only._**

## Installation
The few spells to get the magic in your hands and Enginsight in your servers - 

1. Install (if you haven’t already) the latest [Docker version](https://docs.docker.com/install/). Follow the instructions from the [Docker installation guide](https://docs.docker.com/machine/install-machine/).
2. After successful installation login to access your Docker Containers. Execute the following code, with your username and password.
	```bash
	docker login -u <username>
	```
   Please contact hello@enginsight.com for license and docker credentials. You should have received an e-mail with the credentials if you opted for the Enterprise solution of Enginsight.
3. Install [Docker-Compose](https://docs.docker.com/compose/install/)
4. Clone repository: 
	```bash 
	git clone https://github.com/enginsight/on-premise.git && cd on-premise
	```

   -------------------------------------------------------------------------------------------------------------------

6. To Start setup:  
	```bash
	chmod +x ./setup.sh && ./setup.sh
	```

7. Update paths from the console and follow setup.sh for directions

8. To run as service: 
	```bash 
	docker-compose up -d
	```
It might take several minutes for all the containers to be downloaded, and be up and running, 

And Voila!!! You can use Enginsight on your own server exactly like the Enginsight web application. 
If you have any questions regarding the installation feel free to contact us at support@enginsight.com. Our communication channels are always open to your questions and concerns.

## Update

## Change Config
