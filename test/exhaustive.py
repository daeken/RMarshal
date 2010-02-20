# -*- coding: utf-8 -*-

# Creates a file containing all possible marshal types

import marshal

def testfunc():
	print 'Test'

def exhaustive():
	return (
			None, # TYPE_NONE 'N'
			False, # TYPE_FALSE 'F'
			True, # TYPE_TRUE 'T'
			0, # TYPE_INT 'i'
			#1L, # TYPE_LONG 'l'
			0.0, # TYPE_BINARY_FLOAT 'g'
			1j, # TYPE_BINARY_COMPLEX 'y'
			'foo', # TYPE_STRING 's'
			'bar', # TYPE_INTERNED 't'
			'bar', # TYPE_STRINGREF 'R'
			u'unicode €', # TYPE_UNICODE 'u'
			[0, 'test', True], # TYPE_LIST '['
			{0 : 1, 'bar' : 'baz'}, # TYPE_DICT '{'
			testfunc.func_code, # TYPE_CODE 'c'
			
			set([0, 1, 2]), # TYPE_SET
			frozenset([3, 4, 5]), # TYPE_FROZENSET
			StopIteration, # TYPE_STOPITER
			Ellipsis, # TYPE_ELLIPSIS
		)

marshal.dump(exhaustive(), file('tests\exhaustive.mrsh', 'wb'))
