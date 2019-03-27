# Pull base image.
#FROM ubuntu:14.04
#FROM rastasheep/ubuntu-sshd:14.04
FROM mysql:5.6

# Create futuregateway user
RUN adduser --disabled-password --gecos "" futuregateway
RUN mkdir -p /home/futuregateway/.ssh
RUN chown futuregateway:futuregateway /home/futuregateway/.ssh
RUN wget https://github.com/indigo-dc/PortalSetup/raw/master/Ubuntu_14.04/fgSetup.sh
RUN chmod +x fgSetup.sh
RUN cat /dev/zero | ssh-keygen -q -N ""
RUN cat /root/.ssh/id_rsa.pub >> /home/futuregateway/.ssh/authorized_keys
RUN echo "#FGSetup remove the following after installation" >> /etc/sudoers
RUN echo "ALL  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install mandatory packages
RUN apt-get update && \
    apt-get install -y wget openssh-client openssh-server ant maven build-essential mlocate unzip curl ruby-dev apache2 libapache2-mod-wsgi python-dev python-pip python-Flask python-flask-login python-crypto python-MySQLdb git ldap-utils openvpn screen jq

RUN pip install --upgrade flask-login

# Install java 8
RUN apt-get -y purge openjdk*
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -y update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections 
RUN apt-get -y install oracle-java8-installer

#EXPOSE 22

#CMD ["/usr/sbin/sshd", "-D"]
