#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes a PATCH REST call.
#
# Inputs:
#   - url - URL to which the call is made
#   - auth_type - optional - type of authentication used to execute the request on the target server
#               - Valid: basic, form, springForm, digest, ntlm, kerberos, anonymous (no authentication)
#   - username - optional - username used for URL authentication; for NTLM authentication, the required format is 'domain\user'
#   - password - optional - password used for URL authentication
#   - proxy_host - optional - proxy server used to access the web site
#   - proxy_port - optional - proxy server port - Default: "8080"
#   - proxy_username - optional - user name used when connecting to the proxy
#   - proxy_password - optional - proxy server password associated with the <proxyUsername> input value
#   - connect_timeout - optional - time to wait for a connection to be established, in seconds - Default: "0" (infinite)
#   - socket_timeout - optional - time to wait for data to be retrieved, in seconds - Default: "0" (infinite)
#   - headers - optional - list containing the headers to use for the request separated by new line (CRLF);
#       header name - value pair will be separated by ":" - Format: According to HTTP standard for headers (RFC 2616)
#       Examples: Accept:text/plain
#   - query_params - optional - list containing query parameters to append to the URL
#       Examples: parameterName1=parameterValue1&parameterName2=parameterValue2;
#   - body - optional - string to include in body for HTTP PATCH operation
#   - content_type - optional - content type that should be set in the request header, representing the MIME-type
#       of the data in the message body - Default: text/plain
# Outputs:
#   - return_result - the response of the operation in case of success or the error message otherwise
#   - error_message - returnResult if statusCode different than "200"
#   - return_code - "0" if success, "-1" otherwise
#   - status_code - status code of the HTTP call
################################################

namespace: io.cloudslang.base.network.rest

flow:
  name: http_client_patch
  inputs:
    - url
    - auth_type:
        required: false
    - username:
        required: false
    - password:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - headers:
        required: false
    - query_params:
        required: false
    - body:
        required: false
    - content_type:
        default: "text/plain"
        required: false
    - method:
        default: "PATCH"
        overridable: false
  workflow:
    - http_client_action_patch:
        do:
          http_client_action:
            - url
            - auth_type
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
            - headers
            - query_params
            - body
            - content_type
            - method
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
  outputs:
    - return_result
    - error_message
    - return_code
    - status_code