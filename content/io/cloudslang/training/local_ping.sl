####################################################
# Flow_description
#
# Inputs:
#   - input_name - input_description
# Outputs:
#   - output_name - output_description
# Results:
#   - result_name - result_description
####################################################

namespace: io.cloudslang.training

imports:
  network: io.cloudslang.base.network

flow:
  name: local_ping

  inputs:
    - input_name: input_value

  workflow:
    - retrieve_ip:
        do:
          get_local_ip:
        publish:
          - local_ip
    - ping_ip:
        do:
          network.ping:
            - address: ${local_ip}
        publish:
          - message
          - is_up
        navigate:
          UP: UP
          DOWN: DOWN
          FAILURE: FAILURE
  outputs:
    - message
    - is_up

  results:
    - UP
    - DOWN
    - FAILURE
