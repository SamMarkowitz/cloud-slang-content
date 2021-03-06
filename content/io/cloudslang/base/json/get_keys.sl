#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves keys from a JSON object at a given JSON path.
#
# Inputs:
#   - json_input - JSON from which to retrieve keys - Example: '{"k1": {"k2": {"k3":"v3"}}}'
#   - json_path - path from which to retrieve key represented as a list of keys and/or indices.
#                 Passing an empty list ([]) will retrieve top level keys. - Example: ["k1", "k2"]
# Outputs:
#   - keys - if any keys were found, list of keys found
#   - return_result - parsing was successful or not
#   - return_code - "0" if parsing was successful, "-1" otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - SUCCESS - parsing was successful (return_code == '0')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.base.json

operation:
  name: get_keys
  inputs:
    - json_input
    - json_path
  action:
    python_script: |
      try:
        import json
        decoded = json.loads(json_input)
        for key in json_path:
          decoded = decoded[key]
        decoded = decoded.keys()
        return_result = 'Parsing successful.'
        return_code = '0'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - keys: ${ decoded if return_code == '0' else '' }
    - return_result
    - return_code
    - error_message: ${ return_result if return_code == '-1' else '' }
  results:
    - SUCCESS: ${ return_code == '0' }
    - FAILURE
