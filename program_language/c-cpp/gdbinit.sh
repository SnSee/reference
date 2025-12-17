# is_type_p         : check variable type
# pv_at             : print vector element at index

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


# is_type_p var_name compared_type
define is_type
    set $is_type_ret = ((void*)dynamic_cast<$arg1*>($arg0) != 0)
end
define is_type_p
    is_type $arg0 $arg1
    p $is_type_ret
end

# pv_at vec_name index
define pv_at
    p *($arg0._M_impl._M_start + $arg1)
end
