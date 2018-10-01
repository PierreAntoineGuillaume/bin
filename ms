#!/bin/bash

set -euo pipefail

if ! requireArgs 1;then
    echo "Error, Usage : $0 new_file_name" >> /dev/stderr
fi

echo '#!/bin/bash' >> $1;
chmod +x $1;
