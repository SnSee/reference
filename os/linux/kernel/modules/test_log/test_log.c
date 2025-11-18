#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include <linux/string.h>
#include <linux/time.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("NS");
MODULE_DESCRIPTION("A simple kernel module to write logs to file");
MODULE_VERSION("1.0");

#define LOG_FILE "/tmp/test_log.log"
#define BUF_SIZE 4096

static void close_log_file(void);

struct {
    struct file* file;
    bool opened;

    char *buf;
    size_t cap;
    size_t size;
} logp;

static int flush_log(void)
{
    int ret;
    loff_t pos = 0;

    if (!logp.opened) {
        return -1;
    }
    printk("flush_log size: %lu\n", logp.size);
    ret = kernel_write(logp.file, logp.buf, logp.size, &pos);
    if (ret < 0) {
        printk(KERN_ERR "Failed to write to file: %d\n", ret);
        close_log_file();
    }
    logp.size = 0;
    return ret;
}

static int create_log_file(const char *filename)
{
    logp.opened = false;
	logp.file = filp_open(filename, O_CREAT | O_WRONLY | O_APPEND, 0644);
	if (IS_ERR(logp.file)) {
		printk(KERN_ERR "Failed to create file: %s\n", filename);
		return PTR_ERR(logp.file);
	}
    logp.cap = BUF_SIZE;
    logp.size = 0;
    logp.buf = kmalloc(logp.cap, GFP_KERNEL);
    if (!logp.buf) {
        close_log_file();
        return -ENOMEM;
    }
	logp.opened = true;
	return 0;
}

static void close_log_file(void)
{
    flush_log();
	if (logp.opened) {
		filp_close(logp.file, NULL);
	}
    if (logp.buf) {
        kfree(logp.buf);
    }
    logp.opened = false;
    logp.file = NULL;
}

static void add_log(const void* msg, size_t size)
{
    size_t write_size;
    size_t remain_size = size;
    size_t offset = 0;

    while (remain_size) {
        if (remain_size < logp.cap - logp.size) {
            write_size = remain_size;
        } else {    // buffer full
            write_size = logp.cap - logp.size;
        }
        memcpy(logp.buf + logp.size, msg + offset, write_size);
        logp.size += write_size;
        remain_size -= write_size;
        offset += write_size;
        if (logp.size == logp.cap) {
            flush_log();
        }
    }
}

static int write_to_log(const char *fmt, ...) {
    char buf[256];
    struct timespec64 ts;
    int ret, len;
    va_list args1, args2;

    if (!logp.opened) {
        return -1;
    }

    // print time
    ktime_get_real_ts64(&ts);
    len = snprintf(buf, sizeof(buf), "[%lld.%09ld] ", (long long)ts.tv_sec,
                   ts.tv_nsec);
    add_log(buf, len);

    // get string size
    va_start(args1, fmt);
    len = vsnprintf(buf, sizeof(buf), fmt, args1);
    va_end(args1);

    if (len >= sizeof(buf) - 1) {
        char* large_buf = kmalloc(len + 1, GFP_KERNEL);
        if (!large_buf) {
            return -ENOMEM;
        }
        va_start(args2, fmt);
        len = vsnprintf(large_buf, len + 1, fmt, args2);
        add_log(large_buf, len);
        va_end(args2);
        kfree(large_buf);
    } else {
        add_log(buf, len);
    }
    
    return ret;
}

static void write_test(void) {
    const size_t test_size = BUF_SIZE * 3 + 100;
    size_t i;
    char c = 'a';
    char *large_buf = kmalloc(test_size, GFP_KERNEL);

    for (i = 0; i < test_size; ++i) {
        if (c == 'z' + 1) {
            large_buf[i] = '\n';
            c = 'a';
            continue;
        }
        large_buf[i] = c++;
    }
    large_buf[test_size - 2] = '\n';
    large_buf[test_size - 1] = '\0';

    write_to_log("%s", large_buf);
    kfree(large_buf);
}

static int __init test_log_init(void) {
    printk(KERN_INFO "Test Log Module: Init\n");
    write_to_log("ERROR: Init log that should NOT be here");
    create_log_file(LOG_FILE);
    write_to_log("Kernel module initialized successfully\n");
    write_test();
    return 0;
}

static void __exit test_log_exit(void) {
    write_to_log("Kernel module unloaded\n");
    close_log_file();
    write_to_log("ERROR: Exit log that should NOT be here");
    printk(KERN_INFO "Test Log Module: EXIT\n");
}

module_init(test_log_init);
module_exit(test_log_exit);
