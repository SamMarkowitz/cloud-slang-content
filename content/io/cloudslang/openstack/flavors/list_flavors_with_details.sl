#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of OpenStack flavors with all details.
#
# Inputs:
#   - host - OpenStack machine host
#   - identity_port - optional - port used for OpenStack authentication - Default: '5000'
#   - compute_port - optional - port used for OpenStack computations - Default: '8774'
#   - tenant_name - name of the OpenStack project that contains the specified image with details to be retrieved
#   - username - optional - username used for URL authentication; for NTLM authentication,
#                           the required format is 'domain\user'
#   - password - optional - password used for URL authentication
#   - proxy_host - optional - the proxy server used to access the OpenStack services
#   - proxy_port - optional - the proxy server port used to access the the OpenStack services - Default: '8080'
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if status_code is not '200'
#   - return_code - '0' if success, '-1' otherwise
#   - status_code - the code returned by the operation
# Results:
#   - SUCCESS - the list with flavors details were successfully retrieved
#   - GET_AUTHENTICATION_FAILURE - the authentication call fails
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained
#                                        from authentication call response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained
#                             from authentication call response
#   - LIST_FLAVORS_WITH_DETAILS_FAILURE - the list with flavors details could not be retrieved
####################################################

namespace: io.cloudslang.openstack.flavors

imports:
  openstack: io.cloudslang.openstack
  rest: io.cloudslang.base.network.rest

flow:
  name: list_flavors_with_details
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

  workflow:
    - authentication:
        do:
          openstack.get_authentication_flow:
            - host
            - identity_port
            - tenant_name
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - token
          - tenant_id
          - return_result
          - error_message
        navigate:
          SUCCESS: list_flavors_with_details
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE

    - list_flavors_with_details:
        do:
          rest.http_client_get:
            - url: ${'http://'+ host + ':' + compute_port + '/v2/' + tenant_id + '/flavors/detail'}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: ${'X-AUTH-TOKEN:' + token}
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: LIST_FLAVORS_WITH_DETAILS_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - GET_AUTHENTICATION_FAILURE
    - LIST_FLAVORS_WITH_DETAILS_FAILURE