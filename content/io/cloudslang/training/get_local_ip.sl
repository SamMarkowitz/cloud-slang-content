####################################################
# Operation_description
#
# Inputs:
#   - input_name - input_description
# Outputs:
#   - output_name - output_description
# Results:
#   - result_name - result_description
####################################################

namespace: io.cloudslang.training

operation:
  name: get_local_ip

  action:
    python_script: |
      import socket
      local_ip = socket.gethostbyname(socket.gethostname())

  outputs:
    - local_ip
