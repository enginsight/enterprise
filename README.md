# Enginsight Enterprise 
Worried about the security of your infrastructure? Having troubles monitoring your systems round the clock? Well, no more, sit back while Enginsight does this for you. 
The Enterprise solution is here, the magical potion to your plight. You can operate the platform on your very own servers. A fast and easy installation process built upon Docker, 
access all Enginsight functions remotely on your server. 

For more information regarding the Enterprise solution? Visit [enginsight.com](https://enginsight.com/enterprise/).

## Prerequisites
1. Operating system: (either)
    1. Ubuntu 16 / Ubuntu 18 / Debian 9 / Debian 10
    2. CentOS 7 / CentOS 8 / Redhat / OpenSuse
2. Create user at [Docker Hub](https://id.docker.com/login/). 
    
    _We ship our docker containers via the Docker Hub. We therefore require your Docker Hub profile details to ship the containers into your account._ 
3. Enginsight License. Please contact hello@enginsight.com for a license.


## Automatic Installation (Debian 9/10)
1. Set the following credentials in your console. 

    _These are your docker hub user credentials you created in the earlier steps._

    ```bash
    export DOCKER_USERNAME=<docker hub username>

    export DOCKER_PASSWORD=<docker hub password>
    ```
2. Run command  
	```bash
	curl -sSL https://raw.githubusercontent.com/enginsight/enterprise/master/quickstart/debian.sh | sudo -E bash
	```

	**_Please note: This version supports Debian 9/10 only._**

    You should now be able to run Enginsight Enterprise successfully. Follow the steps further below to be able to use the full version.

## Automatic Installation (CentOS 7/8)
1. Set the following credentials in your console. 

    _These are your docker hub user credentials you created in the earlier steps._

    ```bash
    export DOCKER_USERNAME=<docker hub username>

    export DOCKER_PASSWORD=<docker hub password>
    ```
2. Run command  
	```bash
	curl -sSL https://raw.githubusercontent.com/enginsight/enterprise/master/quickstart/centos.sh | sudo -E bash
	```

	**_Please note: This version supports CentOS 7/8 only._**

    You should now be able to run Enginsight Enterprise successfully. Follow the steps further below to be able to use the full version.

## Manual Installation
The few spells to get the magic in your hands and Enginsight in your servers: 

1. Install (if you haven’t already) the latest [Docker version](https://docs.docker.com/install/). Follow the instructions from the [Docker installation guide](https://docs.docker.com/machine/install-machine/).
2. After successful installation login to access your Docker Containers. Execute the following code, with your username and password.
	```bash
	docker login -u <username>
	```
   Please contact hello@enginsight.com for license and docker credentials. You should have received an e-mail with the credentials if you opted for the Enterprise solution of Enginsight.
3. Install [Docker-Compose](https://docs.docker.com/compose/install/)
4. Clone repository: 
	```bash 
	git clone https://github.com/enginsight/enterprise.git && cd enterprise
	```
5. To Start setup:  
	```bash
	chmod +x ./setup.sh && ./setup.sh docker
	```

It might take several minutes for all the containers to be downloaded, and be up and running, 

And Voila!!! You can use Enginsight on your own server exactly like the Enginsight web application. 
If you have any questions regarding the installation feel free to contact us at support@enginsight.com. Our communication channels are always open to your questions and concerns.

## System Requirements
Please make sure your machine has the following configurations:

**Minimum requirement:** Dual core processor with 4GB RAM

**Recommended configurations:** Quad core processor with 8GB RAM

## Update
In order to update the Enginsight Stack:
1. Route back to home directory
    ```bash
    cd enterprise
    ```
2. Refresh the code in the directory
    ```bash
    git pull -r
    ```
3. Stop and remove all your running containers. This command also removes any networks priorly created.
    ```bash
    docker-compose down
    ```
4. Build the refreshed containers again, recreate all containers even if the images haven't changed, Clean unused containers
    ```bash
    docker-compose up --force-recreate --remove-orphans -V
    ```

## Change Config

**_Note: All the ```.production``` files shall be overwritten. Please take a back up of all your files before making any changes_**

1. run the setup.sh file again
2. You shall be prompted once again to provide all the configuration details.
