#include <linux/module.h>
#include <linux/kallsyms.h>
#include <linux/kprobes.h>

static struct module *find_insert_module(const char *name)
{
    struct module *list_mod = NULL;
    /* traverse the module list and find corresponding module*/
    list_for_each_entry(list_mod, THIS_MODULE->list.prev, list) {
        if (strcmp(list_mod->name, name) == 0) {
           return list_mod;
        }
    }
    printk("[%s] module %s not found\n", THIS_MODULE->name, name);
    return NULL;
}


static int __init force_unload_init(void)
{
    struct module *mod;
    
    mod = find_insert_module("amdgpu");
    
    if (!mod) {
        printk(KERN_ERR "Cannot find module structure\n");
        return -ENOENT;
    }
    printk("Module found: %s, refcnt: %d, state: %u\n", mod->name, atomic_read(&mod->refcnt), mod->state);
    
    // module 自身会占 1 个引用计数，所以需要设置为 1
    atomic_set(&mod->refcnt, 1);
    // 重置状态为正常状态
    mod->state = MODULE_STATE_LIVE;
    
    return 0;
}

static void __exit force_unload_exit(void)
{
    printk(KERN_INFO "Force unload helper unloaded\n");
}

module_init(force_unload_init);
module_exit(force_unload_exit);
MODULE_LICENSE("GPL");
