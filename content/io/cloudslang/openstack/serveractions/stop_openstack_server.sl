#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Stops a running server (instance) and changes its status to SHUTOFF.
#
# Preconditions:
#   - the server status must be ACTIVE or ERROR
#   - if the specified server is locked, you must have administrator privileges to stop the server
# Asynchronous post-conditions:
#   - after you successfully stop a server, its status changes to SHUTOFF. The server instance data appears only
#       on the compute node that Compute service manages
#
# Inputs:
#   - host - OpenStack host
#   - identity_port - optional - port used for OpenStack authentication - Default: '5000'
#   - compute_port - port used for OpenStack computations - Default: '8774'
#   - tenant_name - name of the OpenStack project that contains the server (instance) to be stopped
#   - server_id - the id of the server (instance) to be stopped
#   - username - optional - username used for URL authentication; for NTLM authentication, the required format is
#                           'domain\user'
#   - password - optional - password used for URL authentication
#   - proxy_host - optional - the proxy server used to access the OpenStack services
#   - proxy_port - optional - the proxy server port used to access the the OpenStack services - Default: '8080'
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
# Outputs:
#   - return_result - the response of the operation in case of success, the error message otherwise
#   - error_message - return_result if statusCode is not '202'
#   - return_code - '0' if success, '-1' otherwise
#   - status_code - the code returned by the operation
# Results:
#   - SUCCESS - OpenStack server (instance) was successfully stopped
#   - GET_AUTHENTICATION_FAILURE - the authentication step fail
#   - GET_AUTHENTICATION_TOKEN_FAILURE - the authentication token cannot be obtained from authentication step response
#   - GET_TENANT_ID_FAILURE - the tenant_id corresponding to tenant_name cannot be obtained from authentication
#                             step response
#   - STOP_SERVER_FAILURE - OpenStack server (instance) cannot be stopped
################################################

namespace: io.cloudslang.openstack.serveractions

imports:
  rest: io.cloudslang.base.network.rest
  openstack: io.cloudslang.openstack

flow:
  name: stop_openstack_server
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - tenant_name
    - server_id
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
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - token
          - tenant_id
        navigate:
          SUCCESS: stop_server
          GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE

    - stop_server:
        do:
          rest.http_client_post:
            - url: ${'http://' + host + ':' + compute_port + '/v2/' + tenant_id + '/servers/'+ server_id + '/action'}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers: ${'X-AUTH-TOKEN:' + token}
            - body: '{"os-stop":null}'
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: STOP_SERVER_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - STOP_SERVER_FAILURE