#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Removes a set of Chef roles and/or recipes from a node's run list.
#
# Inputs:
#   - run_list_items - a list of roles and/or recipes to be removed
#                      see https://docs.chef.io/knife_node.html#run-list-remove
#   - node_name - name of the node to assign cookbooks to
#   - knife_host - IP of server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_privkey - optional - path to local SSH keyfile for accessing server with knife
#   - knife_password - optional - password to access server with knife
#   - knife_config - optional - location of knife.rb config file
# Outputs:
#   - knife_result - filtered output of knife command
#   - raw_result - full STDOUT
#   - standard_err - any STDERR
# Results:
#   - SUCCESS - cookbooks were added to the run list
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.chef

flow:
  name: run_list_remove
  inputs:
    - run_list_items
    - node_name
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password:
        required: false
    - knife_config:
        required: false

  workflow:
    - remove_from_run_list:
        do:
          knife_command:
            - knife_cmd: ${'node run_list remove ' + node_name + ' \\'' + run_list_items + '\\''}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

  outputs:
    - knife_result: ${knife_result}
    - raw_result
    - standard_err: ${standard_err}
