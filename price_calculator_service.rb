##
# This class handles user input and price calculations.
class PriceCalculatorService

  ##
  # Get an argument from the command line that starts with the specified key.
  #
  # ==== Examples
  #
  #   get_command_line_argument('items=')
  def self.get_command_line_argument(key)

    ARGV.each do |arg|
      return arg[key.length, arg.length - key.length] if arg.start_with?(key)
    end

    nil
  end

  ##
  # Asks the user for a list of comma-separated items, unless the 'items='
  # command line argument is set.
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

  ##
  # Explodes a comma-separated list of items into an array of strings, trimming
  # whitespace from each item and forcing them all to lower case.
  #
  # ==== Examples
  #
  #   break_items_into_array('milk,MILK,bread,   milk    , mIlK,bAnAna')
  #   # => ["milk", "milk", "bread", "milk", "milk", "banana"]
  def self.break_items_into_array(input)
    items = input.split(",")
    items.each do |item|
      item.strip!
      item.downcase!
    end
    items
  end

  ##
  # Quantifies an array of items into a hash with counts.
  #
  # ==== Examples
  #
  #    quantify(["milk", "milk", "milk", "milk"])
  #    # => {:milk=>4}
  #
  #    quantify(["milk", "milk", "bread", "banana", "bread", "bread", "egg sandwich", "milk", "apple"])
  #    # => {:milk=>3, :bread=>3, :banana=>1, :"egg sandwich"=>1, :apple=>1}))
  def self.quantify(items)
    result = {}

    items.each do |item|

      item = item.to_sym

      result[item] = 0 unless result.key? item
      result[item] += 1

    end

    result
  end

  ##
  # Calculates the price of each type of item, taking sales into consideration,
  # and also calculates the total price and discount. Money is represented as
  # cents to avoid fuzzy floating-point arithmetic.
  #
  # ==== Examples
  #
  #    products = {
  #      banana: {
  #        name: 'Banana',
  #        price_cents: 99
  #      },
  #      milk: {
  #        name: 'Milk',
  #        price_cents: 397,
  #        sale: {
  #          quantity: 2,
  #          price_cents: 500
  #        }
  #      }
  #    }
  #
  #    checkout(products, {:milk=>3, :banana=>1, :eggplant=>1})
  #    # => {:total_price_cents=>996,
  #          :total_saved_cents=>294,
  #          :items=>
  #           [{:name=>"Banana",
  #             :quantity=>1,
  #             :total_price_cents=>99,
  #             :total_discounted_price_cents=>99},
  #            {:name=>"Milk",
  #             :quantity=>3,
  #             :total_price_cents=>1191,
  #             :total_discounted_price_cents=>897}],
  #          :unrecognized=>[:eggplant]}
  def self.checkout(products, cart)

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
        num_full_price = (num_sales_applied > 0)                         \
          ? quantity % (num_sales_applied * product[:sale][:quantity])   \
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
