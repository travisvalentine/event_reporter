require './event_data_parser'
require './help'
require './queue'
require './search'

class Command
  attr_accessor :attendees, :queue
  # makes it so attendees and queue are passed throughout the
  # app as attributes of Command


  ALL_COMMANDS = {  "load" => "loads a new file",
                    "help" => "shows a list of available commands",
                    "queue" => "a set of data",
                    "queue count" => "total items in the queue",
                    "queue clear" => "empties the queue",
                    "queue print" => "prints to the queue",
                    "queue print by" => "prints the specified attribute",
                    "queue save to" => "exports queue to a CSV",
                    "find" => "load the queue with matching records"}

  def self.valid?(command)
    ALL_COMMANDS.keys.include?(command)
  end

  def initialize
    @queue = []
    @attendees = []
  end

  def execute(command, parameters)
    if command == "load"
      parameters[0] ||= "event_attendees.csv"
      if EventDataParser.valid_parameters?(parameters)
        @attendees = EventDataParser.load(parameters[0])
        "#{@attendees.count} people"
      end
    elsif command == "queue" && Queue.valid_parameters?(parameters)
      Queue.new.call(parameters, self)
    elsif command == "help" && Help.valid_parameters?(parameters)
      Help.for(parameters)
    elsif command == "find" && Search.valid_parameters?(parameters)
      Search.for(parameters, self)
    else
      error_message_for(command)
    end
  end

  def error_message_for(command)
    "Sorry, you specified invalid arguments for #{command}."
  end
end