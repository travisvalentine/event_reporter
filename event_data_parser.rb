require 'csv'

class EventDataParser
  def self.load(filename)
    puts "Loading the data from #{filename}!"
    @file = CSV.open(filename, :headers => true, :header_converters => :symbol)
    @file.collect { |line| Attendee.new(line) }
  end

  def self.valid_parameters?(parameters)
    parameters.count == 1 && parameters[0] =~ /\.csv$/
  end
end
