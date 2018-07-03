###############################################################
# NAME: smacktrace/ocp-rhel-netbox-base
# Purpose:  Base image for building netbox on OCP
# Netbox Documentation: http://netbox.readthedocs.io/en/stable/ 
###############################################################

# Using Centos 7 as base
FROM centos:7

# Maintained be
MAINTAINER smacktrace <smacktrace942@gmail.com>

#Dependencies
RUN yum install -y epel-release
RUN yum install -y gcc \
        git \
        python34 \ 
        python34-devel \
        python34-setuptools \
        libxml2-devel \
        libxslt-devel \
        libffi-devel \
        graphviz \
        openssl-devel \
        redhat-rpm-config \
        openldap-devel \
	nginx \
	uwsgi \
	uwsgi-plugin-python3 \
	&& yum clean all -y
	

#Contents of netbox 
ADD /netbox /opt/netbox

#Pip install files
ADD /pip /opt/pip

COPY nginx.conf /etc/nginx/nginx.conf

#Install PIP3 (PYTHON) dependencies
RUN python3 /opt/pip/get-pip.py \
	&& pip3 install -r /opt/netbox/requirements.txt \
	&& pip3 install napalm django-auth-ldap uwsgi 

RUN python3 /opt/netbox/netbox/manage.py collectstatic --no-input
