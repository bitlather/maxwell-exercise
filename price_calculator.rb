def ask_for_items
  puts
  puts "Please enter all the items purchased separated by a comma"
  if ARGV.length == 0
    input = STDIN.gets.chomp
  else
    input = ARGV[0]
    puts input
  end
  puts
  input
end

items = ask_for_items
