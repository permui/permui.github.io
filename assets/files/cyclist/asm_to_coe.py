import subprocess
import sys
import struct

def run(command):
	return subprocess.check_output(command, shell=True)

argv = sys.argv
argc = len(argv)

if 1 >= argc:
	print('give the asm filename without extension (extension is .s)')
	exit(0)

name = argv[1]
asmname = f'{name}.s'
elfname = f'{name}.o'
run(f'riscv64-unknown-elf-as -march=rv32i {asmname} -o {elfname}')
run(f'riscv64-unknown-elf-objdump -D {elfname} -M numeric > {name}_dump.s')
s = run(f"readelf -S {elfname} " + """| grep -A 1 " .text" | awk '{ print $6 " " $7 }';""").decode().split()
start, length = map(lambda s: int(s, 16), s[:2])

with open(elfname, 'rb') as f:
	all_content = f.read()
	data = all_content[start:start+length]

a = struct.unpack('I' * (length // 4), data)
b = list(map(lambda x: hex(x)[2:].rjust(8, '0'), a))
	
with open(f'{name}.coe', 'w') as f:
	f.write('memory_initialization_radix = 16;\n')
	f.write('memory_initialization_vector = \n')
	f.write(', '.join(b) + ';\n')