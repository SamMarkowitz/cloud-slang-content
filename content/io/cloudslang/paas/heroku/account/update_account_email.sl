#################################################### 
# This flow performs an REST API call in order to update the Heroku account email
# 
# Inputs: 
#   - username - the Heroku username - Example: 'someone@mailprovider.com'
#   - password - optional - the Heroku <username> account password - Default: None
#   - email - the new unique email address of the account which will replace the old email address
#
# Outputs: 
#   - return_result - the response of the operation in case of success, the error message otherwise 
#   - error_message - return_result if status_code is not '200'
#   - return_code - '0' if success, '-1' otherwise 
#   - status_code - the code returned by the operation 
#
# Results:
#   - SUCCESS - the update Heroku account email was successfully executed
#   - ADD_EMAIL_FAILURE - insert 'email' key:value pair in JSON body failed
#   - ADD_PASSWORD_FAILURE - insert 'password' key:value pair in JSON body failed
#   - UPDATE_ACCOUNT_EMAIL_FAILURE - the update Heroku account email REST API call failed
####################################################

namespace: io.cloudslang.paas.heroku.account

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: update_account_email
  inputs:
    - username
    - password:
        default: None
        required: false
    - email

  workflow:
    - add_email_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['email']
            - value: ${email}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: add_password_value
          FAILURE: ADD_EMAIL_FAILURE

    - validate_password_input:
        do:
          strings.string_equals:
            - first_string: ${password}
            - second_string: None
        navigate:
          SUCCESS: update_account_email
          FAILURE: add_password_value

    - add_password_value:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['password']
            - value: ${password}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          SUCCESS: update_account_email
          FAILURE: ADD_PASSWORD_FAILURE

    - update_account_email:
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
          FAILURE: UPDATE_ACCOUNT_EMAIL_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - ADD_EMAIL_FAILURE
    - ADD_PASSWORD_FAILURE
    - UPDATE_ACCOUNT_EMAIL_FAILURE