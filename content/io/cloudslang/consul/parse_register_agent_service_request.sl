#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Creates JSON for request to register new agent service.
#
# Inputs:
#   - address - optional - will default to that of the agent
#   - service_name - name of the service to be registered
#   - service_id - optional - service_name will be used if not specified
#   - check - optional - if the Check key is provided, then a health check will also be registered
# Outputs:
#   - return_result - response of the operation
#   - json_request - JSON request for registering endpoint
#   - return_code - '0' if parsing was successful, '-1' otherwise
#   - error_message - return_result if there was an error
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

operation:
  name: parse_register_agent_service_request
  inputs:
    - address:
        default: ''
        required: false
    - service_name
    - service_id:
        required: false
    - check:
        required: false
  action:
    python_script: |
      try:
        import json
        data = {}
        if address:
          data['Address'] = address
        if service_id != '':
          data['ID'] = service_id
        data['Name'] = service_name
        if check:
          data['Check'] = json.loads(check)
        json_request = json.dumps(data)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = 'Parsing error: ' + str(ex)
  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - json_request
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE