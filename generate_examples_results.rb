#!/usr/bin/env ruby
require 'pathname'

root    =  Pathname(__FILE__).dirname.expand_path

file    = root.join('examples.rb')
output  = `ruby #{file}`

content  = file.read.split('__END__').first
content << "__END__\n"
content << "OUTPUT:\n"
content << output

file.open('w') {|f| f << content }
