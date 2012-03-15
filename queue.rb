class Queue
  PRINT_BY_COMMANDS = ["last_name", "first_name",
                       "email", "zipcode", "city", "state", "address"]
  CSV_OPTIONS = { :headers => true, :header_converters => :symbol }

  def call(parameters, command)

    @attribute = parameters[0]
    @criteria = parameters[-1]

    filename = parameters[2]

    @queue = command.queue
    # no need to initialize and call new array
    # since we take the array from Command

    case parameters[0]
    when 'count' then count_the_queue
    when 'clear' then clear_the_queue
    when 'save' then save_the_queue(parameters, filename)
    when 'print' then print_the_queue(parameters)
    else

    end
  end

  def self.valid_parameters?(parameters)
    if !%w(count clear print save).include?(parameters[0])
      false
    elsif parameters[0] == "print"
      parameters.count == 1 ||
        (parameters[1] == "by" &&
          parameters.count == 3)
    elsif parameters[0] == "save"
      parameters[1] == "to" &&
        parameters[2] =~ /\.csv$/ && parameters.count == 3
    else
      true
    end
  end

  def count_the_queue
    "There are #{@queue.count} items in your queue."
  end

  def clear_the_queue
    @queue.replace([])
    "Your queue is now clear."
  end

  def print_the_queue(parameters)
    if parameters[1] == "by" && parameters.count == 3
      print_queue_by_attribute(parameters)
    else
      if @queue.count > 0
        printf "LAST NAME \t  FIRST NAME \t  " +
               "EMAIL \t\t\t  ZIPCODE \t  CITY \t\t  STATE \t  ADDRESS\n"
        @queue.each do |attendee|
          puts "#{attendee.last_name}".ljust(10) + "\t" +
               "#{attendee.first_name}".ljust(10) + "\t" +
               "#{attendee.email_address}".ljust(10) + "\t" +
               "#{attendee.zipcode}".ljust(10) + "\t" +
               "#{attendee.city}".ljust(10) + "\t" +
               "#{attendee.state}".ljust(10) + "\t" +
               "#{attendee.street}".ljust(10)

          #attendee.headers.each
          #{|header| printf attendee.send(header).ljust(10) + "\t" }
        end

        #@queue.each {|attendee| attendee }
        #@queue.select { |attendee| attendee.to_s }

      elsif @queue.count == 0
        "There is nothing to print because your queue is empty."
      end
    end
  end

  def print_queue_by_attribute(parameters)
    case parameters[2]
    when 'last_name' then
      sort = @queue.sort_by{|attendee| attendee.last_name}
    when 'first_name' then
      sort = @queue.sort_by{|attendee| attendee.first_name}
    when 'email' then
      sort = @queue.sort_by{|attendee| attendee.email}
    when 'zipcode' then
      sort = @queue.sort_by{|attendee| attendee.zipcode}
    when 'city' then
      sort = @queue.sort_by{|attendee| attendee.city}
    when 'state' then
      sort = @queue.sort_by{|attendee| attendee.state}
    when 'address' then
      sort = @queue.sort_by{|attendee| attendee.address}
    else
      "Try one of these instead: #{PRINT_BY_COMMANDS}"
    end

    sort.each do |attendee|
      printf "#{attendee.last_name}".ljust(10) + "\t" +
               "#{attendee.first_name}".ljust(10) + "\t" +
               "#{attendee.email_address}".ljust(10) + "\t" +
               "#{attendee.zipcode}".ljust(10) + "\t" +
               "#{attendee.city}".ljust(10) + "\t" +
               "#{attendee.state}".ljust(10) + "\t" +
               "#{attendee.street}".ljust(10) + "\n"
    end

  end

  def save_the_queue(parameters, filename)
    if parameters[1] == "to" &&
         parameters[2] =~ /\.csv$/ &&
          parameters.count == 3
      output = CSV.open(filename, "w", CSV_OPTIONS)
      if @queue.count >= 1
        output << @queue.first.headers
        @queue.each do |attendee|
          output << attendee.headers.collect { |header| attendee.send(header) }
        end
      elsif @queue.count == 0
        output << ['regdate', 'first_name', 'last_name', 'email_address',
                   'homephone', 'street', 'city', 'state', 'zipcode']
      end
      output.close
      "Created and saved '#{filename}' to #{Dir.pwd.to_s}."
    else
    end
  end

end