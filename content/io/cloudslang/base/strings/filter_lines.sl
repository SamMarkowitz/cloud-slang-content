#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Filters input text by string/regex, removing all lines that do not contain a match to the filter.
#
# Inputs:
#   - text - multiline text to be filtered
#   - filter - string or Python regex expression - Example: "f\\w*r"
# Outputs:
#   - filter_result - filtered text
# Results:
#   - SUCCESS - always
####################################################

namespace: io.cloudslang.base.strings

operation:
  name: filter_lines
  inputs:
    - text
    - filter

  action:
    python_script: |
      import re
      res = re.findall('.*' + filter + '.*', text)
      filter_result = '\n'.join(res)

  outputs:
    - filter_result

  results:
    - SUCCESS
