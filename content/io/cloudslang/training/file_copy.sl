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
  files: io.cloudslang.base.files

flow:
  name: file_copy

  inputs:
    - from_path
    - to_path

  workflow:
    - copier:
        do:
          files.copy:
            - source: ${from_path}
            - destination : ${to_path}
        publish:
          - published: ${message}

  outputs:
    - output: ${published}
