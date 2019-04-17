# Enginsight Enterprise 

Do you want more information regarding the Enterprise solution? Just visit [enginsight.com](https://enginsight.com/enterprise/).

## Prerequisits

1. Latest [Docker version](https://docs.docker.com/install/)
2. MongoDB replica set
    1. [cloud](https://www.mongodb.com/cloud)
    2. [self hosted](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/)
3. Operating system: (either)
    1. Ubuntu/Debian
    2. CentOS/Redhat/OpenSuse
4. Create user at [Docker Hub](https://id.docker.com/login/). 
5. [Docker-Compose](https://docs.docker.com/compose/install/)
6. Enginsight Licence. Please contact hello@enginsight.com


## Installation
Worried about the security of your infrastructure? Having troubles monitoring your systems round the clock? Well, no more, sit back while Enginsight does this for you. 
The Enterprise solution is here, the magical potion to your plight. You can operate the platform on your very own servers. A fast and easy installation process built upon Docker, 
access all Enginsight functions remotely on your server. 

The three spells to get the magic in your hands and Enginsight in your servers - 

1. The first (if you haven’t already) install Docker. Follow the instructions from the [Docker installation guide](https://docs.docker.com/machine/install-machine/).
2. After successful installation login to access your Docker Containers. Execute the following code, with your username and password.\
```docker login <username> <password>```\
   Please contact hello@enginsight.com for license and docker credentials. You should have received an e-mail with the credentials if you opted for the Enterprise solution of Enginsight.

3. Clone repository: ```git clone https://github.com/enginsight/on-premise.git && cd on-premise```

   -------------------------------------------------------------------------------------------------------------------

1. To Start setup:  ```chmod +x ./setup.sh && ./setup.sh```

2. Update paths from the console and follow setup.sh for directions

3. To run as service: ```docker-compose up -d```
It might take several minutes for all the containers to be downloaded, and be up and running, 

And Voila!!! You can use Enginsight on your own server exactly like the Enginsight web application. 
If you have any questions regarding the installation feel free to contact us at support@enginsight.com. Our communication channels are always open to your questions and concerns.