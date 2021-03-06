#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Inspects specified image and gets parent.
#
# Inputs:
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - docker_host - Docker machine host
#   - docker_username - Docker machine username
#   - docker_password - optional - Docker machine password
#   - image_name - image for which to check parents - ex: <repository>:<tag>
#   - private_key_file - optional - path to the private key file
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - port - optional - port number for running the command
# Outputs:
#   - parents - parents of the specified containers
####################################################
namespace: io.cloudslang.docker.images

imports:
 docker_utils: io.cloudslang.docker.utils
 base_os_linux: io.cloudslang.base.os.linux

flow:
  name: get_image_parent
  inputs:
    - docker_options:
        required: false
    - docker_host
    - docker_username
    - docker_password:
        required: false
    - image_name
    - private_key_file:
        required: false
    - timeout:
        required: false
    - port:
        required: false

  workflow:
    - inspect_image:
        do:
          inspect_image:
            - docker_options
            - host: ${ docker_host }
            - username: ${ docker_username }
            - password: ${ docker_password }
            - image_name
            - port
            - private_key_file
            - timeout
        publish:
          - image_inspect_json: ${ standard_out }

    - get_parent:
        do:
           docker_utils.parse_inspect_for_parent:
             - json_response: ${ image_inspect_json }
        publish:
          - parent_image

    - get_parent_name:
        do:
           get_image_name_from_id:
             - docker_options
             - host: ${ docker_host }
             - username: ${ docker_username }
             - password: ${ docker_password }
             - private_key_file
             - port
             - timeout
             - image_id: ${ parent_image[:10] }
        publish:
          - image_name
  outputs:
    - parent_image_name: ${ image_name }