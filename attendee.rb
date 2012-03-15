  class Attendee
  attr_accessor :regdate, :first_name, :last_name, :email_address,
                :homephone, :street, :city, :state, :zipcode, :headers

  HEADERS         = ['regdate', 'first_name', 'last_name', 'email_address',
                     'homephone', 'street', 'city', 'state', 'zipcode']
  INVALID_ZIPCODE = "00000"

  def initialize(attribute_data)
    self.headers          = HEADERS
    self.first_name       = attribute_data[:first_name]
    self.last_name        = attribute_data[:last_name]
    self.email_address    = attribute_data[:email_address]
    self.homephone        = clean_number(attribute_data[:homephone])
    self.street           = attribute_data[:street]
    self.city             = attribute_data[:city]
    self.zipcode          = clean_zipcode(attribute_data[:zipcode])
    self.regdate          = attribute_data[:regdate]
    self.state            = attribute_data[:state]
  end


  private
    def clean_number(home_phone)
      home_phone = home_phone.scan(/\d/).join("")

      if home_phone.length == 10
        home_phone
      elsif home_phone.length == 11 && home_phone.start_with?("1")
        home_phone[1..-1]
      else
        "0"*10
      end
    end

    def clean_zipcode(zipcode)
      if zipcode.nil?
        result = INVALID_ZIPCODE
        return result
      elsif zipcode.length < 5
        while zipcode.length <= 4
          zipcode.insert(0,"0")
        end
        return zipcode
      else
        return zipcode
      end
    end

end