class PriceCalculatorService
  def self.get_command_line_argument(key)

    ARGV.each do |arg|
      return arg[key.length, arg.length - key.length] if arg.start_with?(key)
    end

    nil
  end

  def self.ask_for_items

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

  def self.break_into_array(input)
    items = input.split(",")
    items.each do |item|
      item.strip!
      item.downcase!
    end
    items
  end

  def self.quantify(items)
    result = {}

    items.each do |item|

      item = item.to_sym

      result[item] = 0 unless result.key? item
      result[item] += 1

    end

    result
  end

  def self.checkout(products, cart)
    # Two milks at $3.97 each yielded :total_saved=>2.9400000000000004, so I stored
    # the price of everything in cents to reduce floating point issues.

    receipt = {
      total_price_cents: 0,
      total_saved_cents: 0,
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

      item_total_price_cents = quantity * product[:price_cents]
      item_discounted_price_cents = item_total_price_cents

      if product.key? :sale
        num_sales_applied = (quantity / product[:sale][:quantity]).floor
        num_full_price = (num_sales_applied > 0) \
          ? quantity % (num_sales_applied * product[:sale][:quantity]) \
          : quantity

        item_discounted_price_cents = num_full_price * product[:price_cents] + num_sales_applied * product[:sale][:price_cents]
      end

      receipt[:total_price_cents] += item_discounted_price_cents
      receipt[:total_saved_cents] += (item_total_price_cents - item_discounted_price_cents)

      receipt[:items].push({
        name: product[:name],
        quantity: quantity,
        total_price_cents: item_total_price_cents,
        total_discounted_price_cents: item_discounted_price_cents })

    end

    receipt
  end

end
