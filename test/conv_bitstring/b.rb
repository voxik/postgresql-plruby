#!/usr/bin/ruby
require 'rbconfig'
include RbConfig
pwd = Dir.pwd
pwd.sub!(%r{[^/]+/[^/]+$}, "")

language, extension = 'c', '_new_trigger'
opaque = 'language_handler'

suffix = ARGV[0].to_s

begin
   f = File.new("test_queries.sql", "w")
   IO.foreach("test_queries.sql.in") do |x| 
      x.gsub!(/language\s+'plruby'/i, "language 'plruby#{suffix}'")
      f.print x
   end
   f.close

   f = File.new("test_mklang.sql", "w")
   f.print <<EOF
 
   create function plruby#{suffix}_call_handler() returns #{opaque}
    as '#{pwd}src/plruby#{suffix}.#{CONFIG["DLEXT"]}'
   language '#{language}';
 
   create trusted procedural language 'plruby#{suffix}'
        handler plruby#{suffix}_call_handler;
EOF
   f.close
rescue
   raise "Why I can't write #$!"
end
