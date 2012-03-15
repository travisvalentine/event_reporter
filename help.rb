class Help

  ALL_COMMANDS = {  "load" => "loads a new file",
                    "help" => "shows a list of available commands",
                    "queue" => "a set of data",
                    "queue count" => "total items in the queue",
                    "queue clear" => "empties the queue",
                    "queue print" => "prints to the queue",
                    "queue print by" => "prints the specified attribute",
                    "queue save to" => "exports queue to a CSV",
                    "find" => "load the queue with matching records"}

  def self.for(parameters)
    if parameters.count == 0
      "These are the commands at your disposal:\n" +
      "#{ALL_COMMANDS.keys.join("\n")}"
    elsif parameters.count > 0
      case parameters[0..-1].join(" ")
      when 'load' then "Loads a new file."
      when 'find' then "Loads the queue with all records matching" +
                       " the criteria for the given attribute."
      when 'queue count' then "Outputs how many records are in" +
                              " the current queue."
      when 'queue clear' then "Empties the queue."
      when 'queue print' then "Prints out a tab-delimited data" +
                              " table with a header row."
      when 'queue print by' then "Prints the specified attribute."
      when 'queue save to' then "Exports queue to a CSV file."
      when 'queue' then "A set of data."
      when 'help' then "Outputs a listing of the available" +
                       " individual commands."
      end
    else
    end
  end

  def self.valid_parameters?(parameters)
    parameters.empty? || Command.valid?(parameters.join(" "))
  end
end