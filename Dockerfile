#############################################################
## DO NOT CHANGE! MUST INHERIT FROM PEARSON'S PARENT IMAGE ##
#############################################################
FROM pearsontechnology/image-base:latest
#############################################################

#############################################################################
## USE THIS LOGIC TO TRACK INFO FROM THE IMAGE USED TO BUILD THE CONTAINER ##
#############################################################################
ARG GIT_TAG_REF='master'
COPY Dockerfile /etc/docker-app-image-info.txt
RUN  printf "\nGIT_TAG_REF=${GIT_TAG_REF}\n" >> /etc/docker-app-image-info.txt


###############################################
## ADD YOUR CUSTOM DOCKER INSTRUCTIONS BELOW ##
###############################################

LABEL maintainer "you@pearson.com"

COPY docker-entrypoint.sh ~/docker-entrypoint.sh

ENTRYPOINT ["~/docker-entrypoint.sh"]
CMD []
