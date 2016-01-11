import subprocess
import sys
import sh
import time
import requests
import os
import logging
import shutil

logging.basicConfig(level=logging.INFO)

def log_sh(text):
    logging.info(text.strip())

image = "654874881458.dkr.ecr.us-east-1.amazonaws.com/hoopla/pgbouncer"


# Copy configuration from the default to the project folder.
# hoopla-deployment/pgbouncer/ENVIRONMENT/BUILD/*
# ex: hoopla-deployment/pgbouncer/staging/default/*
pgbouncer = 'hoopla-deployment/pgbouncer'
for environment in os.listdir(pgbouncer):
    environment_folder = "{}/{}".format(pgbouncer, environment)

    for build in os.listdir(environment_folder):
        build_folder = '{}/{}'.format(environment_folder, build)

        files_copied = []
        for configuration_file in os.listdir(build_folder):
            configuration_file_path = '{}/{}'.format(build_folder, configuration_file)
            shutil.copyfile(configuration_file_path, configuration_file)
            files_copied.append(configuration_file)

        # Configuration had been copied, build and publish docker image
        full_image_name = "{}:{}.{}".format(image, environment, build)
        logging.info("Creating and publishing image {}".format(full_image_name))
        sh.sh("-c", "sudo docker build -t {} .".format(full_image_name), _out=log_sh)
        sh.sh("-c", "sudo docker push {}".format(full_image_name))

        logging.info("Deleting temporary configuration files")
        for file_copied in files_copied:
            os.remove(file_copied)

logging.info("Done!")
