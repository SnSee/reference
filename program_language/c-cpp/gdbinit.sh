set print pretty on
set print object on
set print static-members on
# set vtbl on
set print demangle on
# set demangle on
set print sevenbit-strings off

python
import sys
sys.path.insert(0, '/xxx/xxx/stl_pretty_printer/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
