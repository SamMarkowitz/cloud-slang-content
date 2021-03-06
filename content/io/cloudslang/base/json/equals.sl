#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Test if two JSONs are equal.
#
# Inputs:
#   - json_input1 - first JSON input - Example: '{"k1":"v1", "k2": "v2"}'
#   - json_input2 - second JSON input - Example: '{"k2":"v2", "k1": "v1"}'
# Outputs:
#   - return_result - parsing was successful or not
#   - return_code - "0" if parsing was successful, "-1" otherwise
#   - error_message - error message if there was an error when executing, empty otherwise
# Results:
#   - EQUALS - two JSONs are equal
#   - NOT_EQUALS - two JSONs are not equal
#   - FAILURE - parsing was unsuccessful (return_code != '0')
####################################################

namespace: io.cloudslang.base.json

operation:
  name: equals
  inputs:
    - json_input1
    - json_input2
  action:
    python_script: |
      try:
        import json
        decoded1 = json.loads(json_input1)
        decoded2 = json.loads(json_input2)
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_result = ex
        return_code = '-1'
  outputs:
    - return_result
    - return_code
    - error_message: ${ return_result if return_code == '-1' else '' }
  results:
    - EQUALS: ${ return_code == '0' and decoded1 == decoded2 }
    - NOT_EQUALS: ${ return_code == '0' }
    - FAILURE
