"""
i2b       : int to binary
i2h       : int to hex
pipe      : Simulate pipe in an environment without the pipe command
"""
import gdb
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


Int2Binary()                # i2b val
Int2Hex()                   # i2h val
try:
    gdb.execute('help pipe', to_string=True)
except gdb.error:
    PyPipeCommand()         # pipe info | grep break | awk '{print $2}'
