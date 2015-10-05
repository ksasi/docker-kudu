#Set the base image :
FROM ubuntu:trusty

#File Author/Maintainer :
MAINTAINER Sasikanth Kotti <kotti.sasikanth@gmail.com>

#Set user as root and locale as UTF-8
USER root
ENV LANG en_US.UTF-8

#"Packages for Cloudera's Distribution for kudu, Version 1, on Ubuntu 14.04 amd64" and wget
RUN sudo apt-get install -y wget
RUN sudo wget http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/pool/contrib/k/kudu/kudu-dbg_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb
RUN sudo wget http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/pool/contrib/k/kudu/kudu-master_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb
RUN sudo wget http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/pool/contrib/k/kudu/kudu-tserver_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb
RUN sudo wget http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/pool/contrib/k/kudu/kudu_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb
RUN sudo wget http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/pool/contrib/k/kudu/libkuduclient-dev_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb
RUN sudo wget http://archive.cloudera.com/beta/kudu/ubuntu/trusty/amd64/kudu/pool/contrib/k/kudu/libkuduclient0_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb

#Install Cloudera kudu packages using dpkg and dependencies with apt-get
RUN sudo apt-get clean
RUN sudo apt-get update
RUN sudo apt-get -f install -y libsasl2.2 ntp lsb psutils
RUN sudo dpkg -i kudu-dbg_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb kudu-master_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb kudu-tserver_0.5.0+
cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb kudu_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb libkuduclient-dev_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trust
y-kudu0.5.0_amd64.deb libkuduclient0_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb

#Remove downloaded packages
RUN sudo rm -f kudu-dbg_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb kudu-master_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb kudu-tserver_0.5.0+cd
h5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb kudu_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb libkuduclient-dev_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-
kudu0.5.0_amd64.deb libkuduclient0_0.5.0+cdh5.4.0+0-1.kudu0.5.0.p0.15~trusty-kudu0.5.0_amd64.deb


#Dynamic script generation to enable service start when container boots
RUN echo "sudo service kudu-master start" >> kudu_start.sh
RUN echo "sudo service kudu-tserver start" >> kudu_start.sh

#Expose ports to enable access of Master or Tablet Server web UI by opening http://<_host_name_>:8051/ for masters or http://<_host_name_>:8050/ for tablet servers
EXPOSE 8050 8051

#Start Kudu services when container boots
CMD sh kudu_start.sh >> nohup.out && tail -f nohup.out
