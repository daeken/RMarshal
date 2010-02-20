require 'rmarshal/opcodes'

class Disasm
	def initialize(code, consts, varnames, names)
		@code = code
		@consts = consts
		@varnames = varnames
		@names = names
		@insts = []
		@off = 0
		
		while @off != @code.size
			@insts[@insts.size] = parse
		end
	end
	
	def insts() @insts end
	def byte()
		val = @code[@off].ord
		@off += 1
		val
	end
	def short()
		val = @code[@off...@off+2].unpack('s')[0]
		@off += 2
		val
	end
	
	def parse
		off = @off
		opcd = byte
		if not $opcodes.has_key? opcd
			raise "Unknown opcode #{opcd}"
		end
		
		name, arg = $opcodes[opcd]
		if arg == nil
			[off, name]
		else
			val = short
			arg = case arg
					when :const then @consts[val]
					when :name then @names[val]
					when :jrel then @off + val
					when :local then @varnames[val]
					else val
				end
			
			[off, name, arg]
		end
	end
end

def disasm(*args)
	Disasm.new(*args).insts
end
