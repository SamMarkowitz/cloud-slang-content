#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.utils

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_uuid_generator
  workflow:
    - execute_uuid_generator:
        do:
          uuid_generator:

        publish:
          - new_uuid
        navigate:
          SUCCESS: verify_output_is_not_empty
          FAILURE: FAILURE
    - verify_output_is_not_empty:
        do:
          strings.string_equals:
            - first_string: ''
            - second_string: ${ new_uuid }
        navigate:
          SUCCESS: OUTPUT_IS_EMPTY
          FAILURE: SUCCESS

  results:
    - SUCCESS
    - FAILURE
    - OUTPUT_IS_EMPTY
