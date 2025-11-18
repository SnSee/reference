obj-m += test_log.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	sudo insmod test_log.ko

uninstall:
	sudo rmmod test_log

.PHONY: all clean install uninstall
