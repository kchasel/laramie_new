class Event < ActiveRecord::Base
  # TODO Fixup calendar from EventCalendar
  has_event_calendar
  
  validates_presence_of :name, :address, :description, :message => "can't be blank"
  
  validate :check_start_end_at
  
  # before_destroy :delete_ics
    
  def color
    "#C38E33"
  end
  
  def check_start_end_at
    if start_at > end_at
      errors.add(:start_at, "is after end at.")
    end
  end
  
  def deliver_to_listhost
    addresses = User.listhost_emails
    addresses.each do |e|
      ListhostMailer.event(self, e).deliver
    end
  end
  
=begin  
  def create_ics
    @cal = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.start = start_at.strftime("%Y%m%dT%H%M%S")
    event.end = end_at.strftime("%Y%m%dT%H%M%S")
    event.summary = name
    event.description = description
    event.location = address
    @cal.add event
    @cal.publish
    string = @cal.to_ical
    File.open("public/downloads/events/#{name.underscore}.ics", 'w') { |f| f.write(string) }
  end
 
  
  def delete_ics
    if File.exists?("public/downloads/events/#{name.underscore}.ics")
      File.delete("public/downloads/events/#{name.underscore}.ics")
    end
  end
  
=end  
  
end