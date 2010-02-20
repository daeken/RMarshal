require 'unmarshal'

def pyc(fn)
	fp = File.open fn
	
	magic, timestamp = fp.read(8).unpack('ii')
	
	unmarshal fp
end
