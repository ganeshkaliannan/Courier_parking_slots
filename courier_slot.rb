require_relative "report"
class CourierSlot

  #initialize the courier slot constructor with required attributes
  def initialize(total_slots, options = {})
    @total_slots = total_slots
    @interactive = options[:interactive]
    @total_slots+=1 if @total_slots.odd?
    @output_file_data = []
    @report = Report.new()
    create_rack_slots()
  end

#Checking for free slots across columns
  def check_and_allocate_slots(data)
    free_slots = []
    (1..2).each do |s|
      free_slots << @rack_hash["column_#{s}"].select {|_, v| v.empty? || v == ""}.keys
    end
    @slot_list = free_slots.flatten()
    allocate_parcel_slot(data)
  end


#validating the user input content and trigering respective method
  def allocate_parcel_slot(data)
    case data[0]
      when "park"
        assign_parcel_slot(data)
      when "leave"
        leave_for_delivery(data)
      when "status"
        @report.generate_tabular_report(@rack_hash, @output_file_data, @interactive)
      when "parcel_code_for_parcels_with_weight"
        @report.generate_parcel_weight_report(@rack_hash, data, @output_file_data, @interactive)
      when "slot_numbers_for_parcels_with_weight"
        @report.generate_slot_weight_report(@rack_hash, data, @output_file_data, @interactive)
      when "slot_number_for_registration_number"
        @report.generate_slot_registration_report(@rack_hash, data, @output_file_data, @interactive)
      else
        puts "Invalid input,pls try with valid input."
    end
  end

#Assigning the parcel to the respective slot which are available,allocating nearest location yet to be done from the slot list
  def assign_parcel_slot(data)
    begin
      if @slot_list.first <= @total_slots/2
        @rack_hash["column_#{1}"][@slot_list.first] = [["item_code", data[1]], ["weight", data[2]]].to_h
        if @interactive == true
          puts "Allocated slot number:#{@slot_list.first}"
        else
          @output_file_data << "Allocated slot number:#{@slot_list.first}"
        end
      else
        @rack_hash["column_#{2}"][@slot_list.first] = [["item_code", data[1]], ["weight", data[2]]].to_h
        if @interactive == true
          puts "Allocated slot number:#{@slot_list.first}"
        else
          @output_file_data << "Allocated slot number:#{@slot_list.first}"
        end
      end
    rescue
      puts "Sorry, parcel slot is full"
    end
  end

#Removing the parcel from the slot
  def leave_for_delivery(data)
    slot_id = data.select {|b| b.to_s =~ /\d+$/}.first.to_i
    begin
      if slot_id <= @total_slots/2
        @rack_hash["column_#{1}"][slot_id] = {}
        if @interactive == true
          puts "Slot number #{slot_id} is free"
        else
          @output_file_data << "Slot number #{slot_id} is free"
        end
      else
        @rack_hash["column_#{2}"][slot_id] = {}
        if @interactive == true
          puts "Slot number #{slot_id} is free"
        else
          @output_file_data << "Slot number #{slot_id} is free"
        end
      end
    rescue
      puts "Sorry, invalid parcel id"
    end
  end

 private

#creating rack slots based on user input,total slots will be splitted into two columns and ids assigned accordingly.
  def create_rack_slots()
    slots_per_column = (@total_slots/2)
    j = 1
    @rack_hash = {}
    (0...2).map.with_index(1) do |a, i|
      if i==2
        a = ((slots_per_column*2)/2)+1
        @rack_hash.store("column_#{i}", Hash[(a..slots_per_column*2).to_a.map {|v| [v, {}]}])
      else
        @rack_hash.store("column_#{i}", Hash[(j..slots_per_column).to_a.map {|v| [v, {}]}])
      end
      j+=1
    end
    puts "Created a parcel slot with #{@total_slots} slots"
    read_and_manipulate() if @interactive == true
  end

#reading inputs from users infinite
  def read_and_manipulate
    loop do
      puts "Input:"
      data_input = gets.chomp().split
      check_and_allocate_slots(data_input)
    end
  end

end


