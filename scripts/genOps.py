# Creates opcodes file for rmarshal

import opcode

ops = []
for name, op in opcode.opmap.items():
	arg = 'nil'
	if op in opcode.hasconst:
		arg = 'const'
	elif op in opcode.hasname:
		arg = 'name'
	elif op in opcode.hasjrel:
		arg = 'jrel'
	elif op in opcode.hasjabs:
		arg = 'jabs'
	elif op in opcode.haslocal:
		arg = 'local'
	elif op in opcode.hascompare:
		arg = 'compare'
	elif op in opcode.hasfree:
		arg = 'free'
	if arg != 'nil':
		arg = ':' + arg
	ops.append((op, name.replace('+', '_'), arg))

ops.sort(lambda a, b: a[0].__cmp__(b[0]))

fp = file('opcodes.rb', 'w')

fp.write('$opcodes = {\n')
for op, name, arg in ops:
	fp.write('\t\t0x%02X => [:%s, %s], \n' % (op, name, arg))
fp.write('\t}\n')

fp.close()
