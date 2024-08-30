package require TclOO

# 定义基类
oo::class create Animal {
    constructor {type name} {
        # 定义成员变量
        variable _type
        variable _name
        set _type $type
        set _name $name
    }
    method get_type {} {
        # 引用成员变量
        variable _type
        return $_type
    }
    method get_name {} {
        variable _name
        return $_name
    }
    method sound {} {
        return "Unknown"
    }
    method show {} {
        # 调用成员方法
        puts "type: [my get_type], name: [my get_name], sound: [my sound]"
    }
}

# 定义派生类
oo::class create Cat {
    # 继承基类
    superclass Animal
    constructor {name} {
        # 调用基类同名方法
        next "CAT" $name
    }
    # 重写基类方法
    method sound {} {
        return "meow meow ~"
    }
}
oo::class create Mouse {
    superclass Animal
    constructor {name} {
        next "MOUSE" $name
    }
    method sound {} {
        return "zhi zhi ..."
    }
}

# 创建对象
# 方式一，返回一个 proc 名称(::oo::Obj<N>) 作为唯一标识
set stray [Animal new Unknown Unknown]
# 方式二，创建名为 topsy 的 proc
Cat create topsy Topsy

# 无法再次创建，因为 proc 名已被占用
# Cat create topsy T2                   

# 可以覆盖变量，标识符为新的 proc 名称
set tom [Cat new Tom]
puts "OLD: $tom"
set tom [Cat new Tom2]
puts "NEW: $tom"

set jerry [Mouse new Jerry]

# 调用方法
$stray  show
$tom    show
$jerry  show
topsy   show
