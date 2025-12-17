"""
commands:
i2b         : int to binary
i2h         : int to hex
h2f         : hex to float
pipe        : Simulate pipe in an environment without the pipe command

functions:
py_eval     : Get output of any gdb commands (output is string)
"""
import gdb
import re
import struct
import subprocess


class Int2Binary(gdb.Command):
    def __init__(self):
        super().__init__("i2b", gdb.COMMAND_USER)

    def invoke(self, args: str, from_tty):
        val = bin(gdb.parse_and_eval(args))[2:]
        print(''.join(reversed([f'{c},' if i%8==0 else c for i, c in enumerate(val[::-1])])))


class Int2Hex(gdb.Command):
    def __init__(self):
        super().__init__("i2h", gdb.COMMAND_USER)

    def invoke(self, args: str, from_tty):
        val = hex(gdb.parse_and_eval(args))[2:]
        print(''.join(reversed([f'{c},' if i%4==0 else c for i, c in enumerate(val[::-1])])))


class Hex2Float(gdb.Command):
    def __init__(self):
        super().__init__("h2f", gdb.COMMAND_USER)

    def invoke(self, args: str, from_tty):
        val = hex(gdb.parse_and_eval(args))[2:]
        float_value = struct.unpack('!f', bytes.fromhex(val))[0]
        print(float_value)


class PyPipeCommand(gdb.Command):
    def __init__(self):
        super(PyPipeCommand, self).__init__('pipe', gdb.COMMAND_USER)

    def invoke(self, args: str, from_tty):
        if '|' not in args:
            print('No pipe')
            return

        cmds = args.split('|')
        gdb_cmd = cmds[0].strip()
        sh_cmd = '|'.join(cmds[1:]).strip()
        try:
            gdb_output = gdb.execute(gdb_cmd, to_string=True)
        except gdb.error as e:
            print(str(e))
            return
        # gdb-python may not support subprocess.run, so use Popen
        # sp = subprocess.run(sh_cmd, input=gdb_output, shell=True, text=True, capture_output=True)
        sp = subprocess.Popen(sh_cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        stdout, stderr = sp.communicate(input=gdb_output)
        print(stdout.rstrip())


class PrintVector(gdb.Command):
    def __init__(self):
        super().__init__("pvector", gdb.COMMAND_DATA, gdb.COMPLETE_SYMBOL)

    def usage(self):
        print("usage:\n"
              "pvecotr vec_name [index] [OPTIONS]\n"
              "\n"
              "OPTIONS:\n"
              "    base: 2,10,16 etc. default: 10\n\n"
              "    mem: member names of element\n"
              "DEMO:\n"
              "    pvector students 2 base=16 mem=name\n"
              )

    def invoke(self, args: str, from_tty):
        if not args:
            return self.usage()
        argv = args.split()
        vec_name = argv[0]
        index = int(argv[1]) if len(argv) >= 2 else None
        options = {pair[0]: pair[1] for pair in re.findall(r'(\w+)=(\w+)', args)}
        self.print_vector(vec_name, index=index, base=options.get('base', 10))

    def print_vector(self, vec_name: str, index: int = None, base: int = 10):
        vec = gdb.parse_and_eval(vec_name)
        start = vec['_M_impl']['_M_start']
        finish = vec['_M_impl']['_M_finish']
        size = int(finish - start)
        if index is None:
            _s = 0
            _e = size
        else:
            if index >= size:
                print(f'index({index}) >= size({size})')
                return
            _s = index
            _e = index + 1

        for i in range(_s, _e):
            elem = (start + i).dereference()
            gdb.write(f"  {i:3d}({start + i}): {elem}\n")


class PyEval(gdb.Function):
    def __init__(self):
        super().__init__("py_eval")

    def invoke(self, cmd: gdb.Value):
        c = str(cmd).strip().strip('"').strip("'").strip()
        try:
            return str(gdb.execute(c))
        except gdb.error:
            return str(gdb.parse_and_eval(c))


########## DEMO ##########
# commands
Int2Binary()                # i2b val
Int2Hex()                   # i2h val
Hex2Float()                 # h2f val
try:
    gdb.execute('help pipe', to_string=True)
except gdb.error:
    PyPipeCommand()         # pipe info | grep break | awk '{print $2}'
PrintVector()

# functions
PyEval()                    # p $py_eval("gdb command")
                            # p $py_eval("any expression")
