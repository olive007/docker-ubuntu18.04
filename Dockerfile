FROM ubuntu:18.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

# Update the package list and
# Update packages to last version and
# Install several usefull packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    				       	   	   locales \
						   bash-completion \
    				   		   iproute2 \
				   		   openssh-server \
				   		   sudo \
				   		   emacs-nox \
				   		   openssl \
				   		   wget \
				   		   htop \
				   		   curl \
				   		   ca-certificates \
				   		   unzip

# Create the script directory
RUN mkdir -p /usr/local/script

# Copy the entry-point script
COPY usr/local/script/entry-point.sh /usr/local/script/entry-point.sh
RUN chmod +x /usr/local/script/entry-point.sh && \
    ln -s /usr/local/script/entry-point.sh /usr/local/bin/entry-point

# Copy the startup script
COPY usr/local/script/startup.sh /usr/local/script/startup.sh
RUN chmod +x /usr/local/script/startup.sh

# Copy the infinite-loop script
COPY usr/local/script/infinite-loop.sh /usr/local/script/infinite-loop.sh
RUN chmod +x /usr/local/script/infinite-loop.sh && \
    ln -s /usr/local/script/infinite-loop.sh /usr/local/bin/infinite-loop
    
# Start SSH service with the startup script
RUN echo "service ssh start" >> /usr/local/script/startup.sh

# Define environment variables
ENV CONTAINER_LOCALE=en_US.UTF-8
ENV CONTAINER_USER_NAME=olive
ENV CONTAINER_USER_PASSWORD=test
ENV CONTAINER_USER_UID=1000
ENV CONTAINER_USER_GID=1000
ENV SSH_KEY_URL=https://gist.githubusercontent.com/olive007/0eea691d672d827823877c180c4cc354/raw/docker_rsa.pub
ENV CONTAINER_BASH_ALIASES=https://gist.githubusercontent.com/olive007/87f72fa69a071dc7d64430317b31d1f2/raw/bash.aliases
ENV CONTAINER_BASH_PROMPT=https://gist.githubusercontent.com/olive007/87f72fa69a071dc7d64430317b31d1f2/raw/bash.prompt

ENTRYPOINT ["entry-point"]

# By default launch the startup script and login as the user
#CMD ["/usr/local/script/startup.sh && cd /home/$CONTAINER_USER_NAME && su $CONTAINER_USER_NAME"]
CMD ["default-command"]
