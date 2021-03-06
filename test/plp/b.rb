#!/usr/bin/ruby
require 'rbconfig'

dir = File.expand_path('../..', Dir.pwd)

suffix = ARGV[0].to_s

begin
   f = File.new("test_setup.sql", "w")
   IO.foreach("test_setup.sql.in") do |x| 
      x.gsub!(/language\s+'plruby'/i, "language 'plruby#{suffix}'")
      f.print x
   end
   f.close

   f = File.new("test_mklang.sql", "w")
   f.print <<EOF
 
   create function plruby#{suffix}_call_handler() returns language_handler
    as '#{dir}/src/plruby#{suffix}.#{RbConfig::CONFIG["DLEXT"]}'
   language c;
 
   create trusted procedural language 'plruby#{suffix}'
        handler plruby#{suffix}_call_handler;
EOF
   f.close
rescue
   raise "Why I can't write #$!"
end
