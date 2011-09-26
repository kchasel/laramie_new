class Calendar
  
  def self.get_events(year, month, *day)
    if day.empty?
      day = [1]
      all_month = true
    end
    day = day.first
    date = Date.civil(year, month, day)
    return Event.where(:start_at => date..date.tomorrow) if not all_month
    return Event.where(:start_at => date..date.next_month) if all_month
  end
  
  def self.has_events_on?(year, month, day)
    date = Date.civil(year, month, day)
    events = Event.where(:start_at => date..date.tomorrow)
    nom = events.length
    if nom == 0
      return false
    else
      return true
    end
  end
end