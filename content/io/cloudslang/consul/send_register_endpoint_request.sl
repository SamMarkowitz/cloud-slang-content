#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Sends a request to register a new end point.
#
# Inputs:
#   - host - Consul agent host
#   - consul_port - optional - Consul agent host port - Default: '8500'
#   - json_request - the request JSON
# Outputs:
#   - return_result - response of the operation
#   - error_message - returnResult if returnCode is equal to '-1' or statusCode different than '200'
#   - status_code - normal status code is '200'
#   - return_code - if returnCode is equal to '-1' then there was an error
# Results:
#   - SUCCESS - operation succeeded (returnCode != '-1' and statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.consul

operation:
  name: send_register_endpoint_request
  inputs:
    - host
    - consul_port:
        default: '8500'
        required: false
    - json_request
    - body:
        default: ${json_request}
        overridable: false
    - url:
        default: ${'http://' + host + ':' + consul_port + '/v1/catalog/register'}
        overridable: false
    - method:
        default: 'put'
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: ${returnResult}
    - error_message: ${returnResult if returnCode == '-1' or statusCode != '200' else ''}
    - return_code: ${returnCode}
    - status_code: ${statusCode}
  results:
    - SUCCESS: ${returnCode != '-1' and statusCode == '200'}
    - FAILURE