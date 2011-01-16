puts "This is a string #{with.embedded + code} inside" 

puts "This is a string #{with.internal("code that #{nests}", before) + popping} back out"
