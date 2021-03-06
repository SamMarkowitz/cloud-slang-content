#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#  Retrieves parsed key data.
#
#  Inputs:
#    - host - Consul agent host
#    - consul_port - optional - Consul agent port - Default: 8500
#    - key_name - name of key to retrieve
#  Outputs:
#    - decoded - parsed response
#    - key - key name
#    - flags - key flags
#    - create_index - key create index
#    - value - key value
#    - modify_index - key modify index
#    - lock_index - key lock index
#    - error_message - returnResult if there was an error
#  Results:
#    - SUCCESS - parsing was successful (return_code == '0')
#    - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

flow:
  name: report_kv
  inputs:
    - host
    - consul_port:
        default: "8500"
        required: false
    - key_name
  workflow:
    - retrieve_key:
        do:
          get_kv:
            - key_name
            - host
            - consul_port
        publish:
          - return_result
    - parse_key:
        do:
          parse_key:
            - json_response: ${return_result}
        publish:
          - decoded
          - key
          - flags
          - create_index
          - value
          - modify_index
          - lock_index
          - error_message
  outputs:
    - decoded
    - key
    - flags
    - create_index
    - value
    - modify_index
    - lock_index
    - error_message
  results:
    - SUCCESS
    - FAILURE