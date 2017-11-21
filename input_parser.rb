require_relative "courier_slot"
class InputParser

  def initialize
    input_file = ARGV[0]
    if input_file.nil?
      data = get_user_input
      @courier_slot = CourierSlot.new(data, interactive: true)
    else
      data = read_in_txt_data(input_file)
    end
  end

  def read_in_txt_data(input_file)
    data = []
    File.open(File.join(File.dirname(__FILE__), "#{input_file}")) do |f|
      f.each_line do |line|
        data << line.split
      end
    end
    @courier_slot = CourierSlot.new(data.first[1].to_i, interactive: false)
    filtered_data = data.shift
    data.each do |d|
      @courier_slot.check_and_allocate_slots(d)
    end
  end

  def get_user_input
    puts 'Please enter the required slots(Ex: create_parcel_slot_lot 6)'
    @new_slots = gets.chomp.scan(/\d+/).first.to_i
  end

end

user_input = InputParser.new


