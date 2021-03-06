###################################################################################################
# This flow performs an REST API call in order to update the Heroku account
# 
# Inputs: 
#   - username - the HEROKU username - Example: 'someone@mailprovider.com' 
#   - password - optional - the Heroku <username> account password - Default: None
#   - allow_tracking - optional - whether to allow third party web activity tracking - Default: True
#   - beta - optional - whether allowed to utilize beta Heroku features - Default: False
#   - account_owner_name - optional - full name of the account owner - Default: None
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if status_code is not '200'
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation
#
# Results:
#   - SUCCESS - the update Heroku account was successfully executed
#   - ADD_ALLOW_TRACKING_FAILURE - insert 'allow_tracking' key:value pair in JSON body failed
#   - ADD_BETA_FAILURE - insert 'beta' key:value pair in JSON body failed
#   - ADD_ACCOUNT_OWNER_NAME_FAILURE - insert 'name' key:value pair in JSON body failed
#   - UPDATE_ACCOUNT_FAILURE - the update Heroku account REST API call failed
###################################################################################################

namespace: io.cloudslang.paas.heroku.account

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: update_account
  inputs:
    - username
    - password:
        default: None
        required: false
    - allow_tracking:
        default: True
        required: false
    - beta:
        default: False
        required: false
    - account_owner_name:
        default: None
        required: false

  workflow:
    - add_allow_tracking_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['allow_tracking']
            - value: ${bool(allow_tracking)}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: add_beta_value
          FAILURE: ADD_ALLOW_TRACKING_FAILURE

    - add_beta_value:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['beta']
            - value: ${bool(beta)}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: validate_account_owner_name_input
          FAILURE: ADD_BETA_FAILURE

    - validate_account_owner_name_input:
        do:
          strings.string_equals:
            - first_string: ${account_owner_name}
            - second_string: None
        navigate:
          SUCCESS: update_account
          FAILURE: insert_account_owner_name

    - insert_account_owner_name:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['name']
            - value: ${account_owner_name}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: update_account
          FAILURE: ADD_ACCOUNT_OWNER_NAME_FAILURE

    - update_account:
        do:
          rest.http_client_patch:
            - url: "https://api.heroku.com/account"
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - body: ${body_json}
            - content_type: "application/json"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: SUCCESS
          FAILURE: UPDATE_ACCOUNT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - ADD_ALLOW_TRACKING_FAILURE
    - ADD_BETA_FAILURE
    - ADD_ACCOUNT_OWNER_NAME_FAILURE
    - UPDATE_ACCOUNT_FAILURE