require 'rmarshal/disasm'
require 'set'

class Code
	def initialize(
			argcount, nlocals, stacksize, flags, code, consts, names, varnames, freevars, 
			cellvars, filename, name, firstlineno, lnotab
		)
		
		@argcount, @nlocals, @stacksize, @flags = argcount, nlocals, stacksize, flags
		@code, @consts, @names, @varnames = code, consts, names, varnames
		@freevars, @cellvars, @filename, @name = freevars, cellvars, filename, name
		@firstlineno, @lnotab = firstlineno, lnotab
	end
	
	def method_missing(sym)
		instance_variable_get sym
	end
	
	def disassemble
		disasm @code, @consts, @varnames, @names
	end
end

class Unmarshal
	def initialize(fp)
		@fp = fp
		@interned = []
		
		@value = unmarshal
	end
	
	def value() @value end
	def byte() @fp.read 1 end
	def long() @fp.read(4).unpack('i')[0] end
	def double() @fp.read(8).unpack('E')[0] end
	
	def unmarshal
		type = byte
		case type
			when '.' then :Ellipsis
			when '0' then :null # Special!
			when 'N' then nil
			when 'T' then true
			when 'F' then false
			
			when 'c'
				argcount, nlocals, stacksize, flags = long, long, long, long
				
				code_, consts, names, varnames, freevars = unmarshal, unmarshal, unmarshal, unmarshal, unmarshal
				cellvars, filename, name = unmarshal, unmarshal, unmarshal
				firstlineno, lnotab = long, unmarshal
				
				Code.new( 
						argcount, nlocals, stacksize, flags, 
						code_, consts, names, varnames, freevars, 
						cellvars, filename, name, firstlineno, lnotab
					)
			
			when 'g' then double
			when 'i' then long
			when 'I' then @fp.read(8).unpack('q')[0]
			
			when 'R'
				@interned[long]
			
			when 's' then @fp.read long
			
			when 'S' then :StopIteration
			
			when 't'
				str = @fp.read long
				@interned[@interned.size] = str
				str
			
			when 'u' then @fp.read(long).force_encoding 'utf-8'
			
			when 'y'
				Complex double, double
			
			when '(', '['
				(0...long).map { unmarshal }
			
			when '{'
				val = {}
				
				while true
					key = unmarshal
					break if key == :null
					
					val[key] = unmarshal
				end
				
				val
			
			when '<', '>'
				Set.new((0...long).map { unmarshal })
			
			when '?'
				raise 'TYPE_UNKNOWN encountered.  Incomplete marshal.'
			
			else
				raise "Unknown type '#{type}'"
		end
	end
end

def unmarshal(fp)
	Unmarshal.new(fp).value
end
