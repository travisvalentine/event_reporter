class Search
  def self.for(parameters, command)

    @attribute = parameters[0]
    @command = command
    @queue = command.queue
    @attendees = command.attendees
    @queue.replace([])

    if parameters.count >= 3
      @criteria = parameters[1..-1].join(" ")
    elsif parameters.count == 2
      @criteria = parameters[1]
    end

    @attendees.each do |attendee|
      unless attendee.send(@attribute.to_sym).nil?
        if attendee.send(@attribute.to_sym).downcase == @criteria.downcase
          @queue << attendee
        end
      end
    end
    "I found #{@queue.count} records with" +
    " #{@attribute.to_s.gsub('_',' ')} '#{@criteria}'."
  end

  def self.valid_parameters?(parameters)
    parameters.count >= 2
  end
end