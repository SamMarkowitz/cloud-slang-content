#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Parses a json input and retrieves the specific details of the resource identified by <key_name>
#
# Inputs:
#   - json_input - the response of get resources operation (e.g.: get_applications, get_services, get_spaces, get_users)
#   - key_name - name of the resource to get details on
# Outputs:
#   - return_result - was parsing was successful or not
#   - error_message - returnResult if there was an error
#   - return_code - '0' if parsing was successful, '-1' otherwise
#   - resource_guid - the GUID of the resource identified by <key_name>
#   - resource_url - URL of the resource identified by <key_name>
#   - resource_created_at - the creation date of the resource identified by <key_name>
#   - resource_updated_at - the last updated date of the resource identified by <key_name>
# Results:
#   - SUCCESS - parsing was successful (returnCode == '0')
#   - FAILURE - otherwise
####################################################
namespace: io.cloudslang.paas.stackato.utils

operation:
  name: get_resource_details
  inputs:
    - json_input
    - key_name
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(json_input)
        for i in decoded['resources']:
          if i['entity']['name'] == key_name:
            resource_guid = "key_name + '_guid'"
            resource_url = "key_name + '_url"
            resource_created_at = "key_name + '_created_at"
            resource_updated_at = "key_name + '_updated_at"
            resource_guid = i['metadata']['guid']
            resource_url = i['metadata']['url']
            resource_created_at = i['metadata']['created_at']
            resource_updated_at = i['metadata']['updated_at']
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = ex
  outputs:
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}
    - return_code
    - resource_guid
    - resource_url
    - resource_created_at
    - resource_updated_at
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE