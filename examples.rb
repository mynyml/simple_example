require 'lib/simple_example'
include SimpleExample


SEP = '-'*10
SimpleExample::Format.separator = SEP

puts SEP

# simple
example do
  1 + 1
end

# less simple
example do
  [1.4, 2.4, 3.4].map(&:floor)
end

# returns last statement
result = example { 1 + 1 }
puts "previous result: #{result}"

puts SEP

# multiple statements
example do
  arr = %w( a b c )
  arr.each {|x| x.upcase! }
  arr.map  {|x| x << 'y'  }
end

# irb style:
SimpleExample::Format.source_prefix = '>> '
SimpleExample::Format.result_prefix = '=> '

example { 1 + 1; 2 + 2 }

# python shell style:
SimpleExample::Format.source_prefix = '>>> '
SimpleExample::Format.result_prefix = ''

example { 1 + 1; 2 + 2 }

# io style
SimpleExample::Format.source_prefix = 'rb> '
SimpleExample::Format.result_prefix = '==> '

example { 1 + 1; 2 + 2 }

# compact:
SimpleExample::Format.source_prefix = ''
SimpleExample::Format.result_prefix = '#=> '
SimpleExample::Format.compact = true

example { 1 + 1; 2 + 2 }


__END__
OUTPUT:
----------
(1 + 1)
#=> 2
----------
[1.4, 2.4, 3.4].map(&:floor)
#=> [1, 2, 3]
----------
(1 + 1)
#=> 2
----------
previous result: 2
----------
arr = ["a", "b", "c"]
#=> ["a", "b", "c"]
arr.each { |x| x.upcase! }
#=> ["A", "B", "C"]
arr.map { |x| (x << "y") }
#=> ["Ay", "By", "Cy"]
----------
>> (1 + 1)
=> 2
>> (2 + 2)
=> 4
----------
>>> (1 + 1)
2
>>> (2 + 2)
4
----------
rb> (1 + 1)
==> 2
rb> (2 + 2)
==> 4
----------
(1 + 1) #=> 2
(2 + 2) #=> 4
----------
