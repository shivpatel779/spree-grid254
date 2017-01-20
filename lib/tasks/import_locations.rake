namespace :import_locations do
  desc "create addresses"
  task create_addresses: :environment do
    require "simple-spreadsheet"
  
    s = SimpleSpreadsheet::Workbook.read("#{Rails.root}/lib/locations.xlsx")
    s.selected_sheet = s.sheets.last
    s.first_row.upto(s.last_row) do |line|
      if line > 1 
        @country=  Spree::Country.last
        a = Spree::State.find_by_name(s.cell(line,1))
        if !a.present?
          @state = @country.states.new(name: s.cell(line,1))
          @state.save
          
          @constituency = @state.constituencies.create(name: s.cell(line,2))
          if !@constituency.locations.include? s.cell(line,3)
            
            @location = @constituency.locations.create(name: s.cell(line,3))
          end 
        else
          if !a.constituencies.collect(&:name).include? s.cell(line,2)
            @constituency = @state.constituencies.create(name: s.cell(line,2))
            @location = @constituency.locations.create(name: s.cell(line,3))
            if !@constituency.locations.include? s.cell(line,3)
              @location = @constituency.locations.create(name: s.cell(line,3))

            end
          else
            if !@constituency.locations.include? s.cell(line,3)
              @location = @constituency.locations.create(name: s.cell(line,3))
            end
          end


        end
      end
    end

  end
end