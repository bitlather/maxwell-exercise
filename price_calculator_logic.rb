def get_command_line_argument(key)

  ARGV.each do |arg|
    return arg[key.length, arg.length - key.length] if arg.start_with?(key)
  end

  nil
end

def ask_for_items

  puts
  puts "Please enter all the items purchased separated by a comma"
  input = get_command_line_argument('items=')

  if input.nil?
    # Ask user to input items if they did not pass it through command line.
    input = STDIN.gets.chomp
  else
    # Simply print the items if user passed them through command line argument.
    puts input
  end
  puts

  input
end

def break_into_array(input)
  items = input.split(",")
  items.each do |item|
    item.strip!
    item.downcase!
  end
  items
end

def quantify(items)
  result = {}

  items.each do |item|

    item = item.to_sym

    result[item] = 0 unless result.key? item
    result[item] += 1

  end

  result
end

def checkout(products, cart)
  receipt = {
    total_price: 0,
    total_saved: 0,
    items: [],
    unrecognized: []    
  }

  cart.keys.sort.each do |key|

    quantity = cart[key]

    if !products.key? key
      receipt[:unrecognized].push key
      next
    end

    product = products[key]

    item_total_price = quantity * product[:price]
    item_discounted_price = item_total_price

    if product.key? :sale
      num_sales_applied = (quantity / product[:sale][:quantity]).floor
      num_full_price = (num_sales_applied > 0) \
        ? quantity % (num_sales_applied * product[:sale][:quantity]) \
        : quantity

      item_discounted_price = num_full_price * product[:price] + num_sales_applied * product[:sale][:price]
    end

    receipt[:total_price] += item_discounted_price
    receipt[:total_saved] += (item_total_price - item_discounted_price)
    # Note: For two milks, we get :total_saved=>2.9400000000000004, so maybe we should store
    # the price of everything in cents to avoid floating point issues.

    receipt[:items].push({
      name: product[:name],
      quantity: quantity,
      total_price: item_total_price,
      total_discounted_price: item_discounted_price })

  end

  receipt
end
