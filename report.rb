class Report

  def initialize
  end

  #Creating the tabular report for the all the occupied slots(Slot No, Registration Number,Weight)
  def generate_tabular_report(rack_hash, output_file_data, interactive)
    tab_report = rack_hash.keys.map {|k| rack_hash[k].collect {|c| puts "\t#{c[0]} \t\t#{c[1]["item_code"]} \t\t\t#{c[1]["weight"]}" unless c[1]["item_code"].nil?}}.flatten.compact
    if interactive == true
      p "Slot No  Registration No  Weight"
      puts tab_report
    else
      output_file_data << "Slot No  Registration No  Weight"
      output_file_data << tab_report
    end

  end

  #Report to get the parcel codes based on matching weight
  def generate_parcel_weight_report(rack_hash, data, output_file_data, interactive)
    parcel_weight_report = rack_hash.keys.map {|k| rack_hash[k].collect {|c| puts "#{c[1]["item_code"]}" if "#{c[1]["weight"]}" == data[1]}}.flatten.compact
    if interactive == true
      if parcel_weight_report.flatten.compact.blank?
        puts "Not Found"
      else
        puts parcel_weight_report
      end
    else
      output_file_data << parcel_weight_report
    end
  end

  #Report to get the slot codes based on matching weight
  def generate_slot_weight_report(rack_hash, data, output_file_data, interactive)
    slot_weight_report= rack_hash.keys.map {|k| rack_hash[k].collect {|c| puts "#{c[0]}" if "#{c[1]["weight"]}" == data[1]}}.flatten.compact
    if interactive == true
      if slot_weight_report.flatten.compact.nil?
        puts "Not Found"
      else
        puts slot_weight_report
      end
    else
      output_file_data << slot_weight_report
    end
  end

  #Report to get the slot numbers based on matching registration number
  def generate_slot_registration_report(rack_hash, data, output_file_data, interactive)
    slot_reg_report = rack_hash.keys.map {|k| rack_hash[k].collect {|c| puts "#{c[0]}" if "#{c[1]["item_code"]}" == data[1]}}.flatten.compact.uniq
    if interactive == true
      if slot_reg_report.flatten.compact.nil?
        puts "Not Found"
      else
        puts slot_reg_report
      end
    else
      output_file_data << slot_reg_report
    end
  end


end