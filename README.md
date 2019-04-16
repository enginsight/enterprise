# Enginsight OnPremise 

Do you want more information regarding the OnPremise solution? Just visit [enginsight.com](https://enginsight.com/enterprise/).

## Prerequisits

1. Latest [Docker version](https://docs.docker.com/install/)
2. MongoDB replica set
    1. [cloud](https://www.mongodb.com/cloud)
    2. [self hosted](https://docs.mongodb.com/manual/tutorial/deploy-replica-set/)
3. Operating system: (either)
    1. Ubuntu/Debian
    2. CentOS/Redhat/OpenSuse
4. Create user at [Docker Hub](https://docs.docker.com/machine/install-machine/). 
5. Enginsight Licence. Please contact hello@enginsight.com


## Installation
We are glad that security and availability of your IT are important to you as well. With Enginsight you can monitor all components of your IT environment with ease. With Enginsight OnPremise it is also possible to operate the platform on your own servers. 
With the fast and easy installation, using Docker, you can get access to any functions of Enginsight right on a server in your IT environment. Just follow the three steps to install Enginsight on your server.

1. The first step (if you haven’t already) is to install Docker. For this just follow the instructions of the [Docker installation guide](https://docs.docker.com/machine/install-machine/).
2. After you have successfully installed Docker you are able to login, so that you can access our Docker containers. To login just execute the following line of code, entering your username and password.\
```docker login ```\
Please contact hello@enginsight.com for licence and docker credentials. If everything went right, you should have gotten a mail with the credentials if you decided for an OnPremise use of Enginsight.

3. Clone repository: ```git clone https://github.com/enginsight/on-premise.git && cd on-premise```

4. Start setup:  ```chmod +x ./setup.sh && ./setup.sh```

5. Update paths using the console and following the directions of setup.sh

6. To run as service: ```docker-compose up -d```

And that's it. After all containers are downloaded and up running, which can take several minutes, you can use Enginsight on your own server just as you are used to, using the Enginsight web application. 

If you have any questions regarding the installation feel free to contact us at support@enginsight.com. We are always happy to help, if you got any problems.

