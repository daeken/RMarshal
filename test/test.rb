require 'rmarshal'
require 'pp'

fp = File.open 'exhaustive.mrsh'
pp unmarshal fp
