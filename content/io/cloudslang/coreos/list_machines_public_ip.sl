#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#####################################################
# Retrieves the public IPs of machines in a CoreOS cluster.
#
# Inputs:
#   - coreos_host - CoreOS machine host;
#                   Can be any machine from the cluster
#   - coreos_username - CoreOS machine username
#   - coreos_password - optional - CoreOS machine password;
#                                  Can be empty since CoreOS machines use private key file authentication
#   - private_key_file - optional - path to the private key file
#   - timeout - optional - time in milliseconds to wait for the command to complete
# Outputs:
#   - machines_public_ip_list: list of public IP addresses of the machines in the cluster (delimiter: space)
#####################################################

namespace: io.cloudslang.coreos

flow:
  name: list_machines_public_ip

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        required: false
    - private_key_file:
        required: false
    - timeout:
        required: false
    - machines_public_ip_list:
        default: ''
        overridable: false

  workflow:
    - list_ids_of_the_machines:
        do:
          list_machines_id:
            - host: ${coreos_host}
            - username: ${coreos_username}
            - password: ${coreos_password}
            - private_key_file
            - timeout
        publish:
          - machines_id_list

    - get_machine_public_ip:
        loop:
          for: machine_id in machines_id_list.split()
          do:
            get_machine_public_ip:
              - machine_id
              - host: ${coreos_host}
              - username: ${coreos_username}
              - password: ${coreos_password}
              - private_key_file
              - timeout
          publish:
            - machines_public_ip_list: ${self['machines_public_ip_list'] + public_ip + ' '}

  outputs:
    - machines_public_ip_list: ${machines_public_ip_list.strip()}