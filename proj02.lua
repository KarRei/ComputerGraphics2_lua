
require "point"
require "vector"
require "plane"
require "lsd"

-- (arg[1] will read the test-file from the terminal)
lsd.read(arg[1]) -- read the lsd specification; reading arg[1]
		 --   is mandatory

require "query"  -- also mandatory: all 5 queries should go in this module
		 --   so that they can be called with, for example,
		 --   query.whatObjects()
