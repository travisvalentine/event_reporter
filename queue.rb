class Queue
  PRINT_BY_COMMANDS = ["last_name", "first_name",
                       "email", "zipcode", "city", "state", "address"]

  RESULTS_FROM_PRINT_BY = ["last_name", "first_name",
                       "email_address", "zipcode", "city", "state", "street"]
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
        parameters[1] == "by" &&
          parameters.count == 3
    elsif parameters[0] == "save"
      parameters[1] == "to" &&
        parameters[2] =~ /\.csv$/ &&
          parameters.count == 3
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
        print_queue_results
      elsif @queue.count == 0
        "There is nothing to print because your queue is empty."
      end
    end
  end

  def print_queue_results
    printf "LAST NAME \t  FIRST NAME \t  " +
           "EMAIL \t\t\t  ZIPCODE \t  CITY \t\t  STATE \t  ADDRESS\n"
    print_tab_delimited
  end

  def print_tab_delimited
    @queue.each do |attendee|
      justify_results = RESULTS_FROM_PRINT_BY.map do |attribute|
        attendee.send(attribute.to_sym).ljust(10)
      end
      puts justify_results.join("\t")
    end
  end

  def print_queue_by_attribute(parameters)
    sort = @queue.sort_by { |attendee| attendee.send(parameters[2])}
    sort.each do |attendee|
      justify_results = RESULTS_FROM_PRINT_BY.map do |attribute|
        attendee.send(attribute.to_sym).ljust(10)
      end
      puts justify_results.join("\t")
    end
  end

  def save_the_queue(parameters, filename)
    if parameters[1] == "to" &&
         parameters[2] =~ /\.csv$/ &&
          parameters.count == 3
      if @queue.count >= 1
        fill_the_queue(parameters, filename)
      elsif @queue.count == 0
        add_placeholder_headers(parameters, filename)
      end
      "Created and saved '#{filename}' to #{Dir.pwd.to_s}."
    else
    end
  end

  def fill_the_queue(parameters, filename)
    output = CSV.open(filename, "w", CSV_OPTIONS)
    output << @queue.first.headers
    @queue.each do |attendee|
      output << attendee.headers.collect { |header| attendee.send(header) }
    end
    output.close
  end

  def add_placeholder_headers(parameters, filename)
    output = CSV.open(filename, "w", CSV_OPTIONS)
    output << ['regdate', 'first_name', 'last_name', 'email_address',
               'homephone', 'street', 'city', 'state', 'zipcode']
    output.close
  end
end