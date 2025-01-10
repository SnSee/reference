# i2b: int 转 binary
import gdb

class Int2Binary(gdb.Command):
    def __init__(self):
        super().__init__("i2b", gdb.COMMAND_USER)

    def invoke(self, args: str, from_tty):
        val = bin(gdb.parse_and_eval(args))[2:]
        print(''.join(reversed([f'{c} ' if i%8==0 else c for i, c in enumerate(val[::-1])])))

Int2Binary()
