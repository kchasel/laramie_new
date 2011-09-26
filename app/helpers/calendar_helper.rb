module CalendarHelper
  def month_link(month_date)
    link_to(month_date.strftime("%B"), {:month => month_date.month, :year => month_date.year}, :class => 'month_link')
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => @shown_month.strftime("%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"
    }
  end

  def event_calendar
    calendar event_calendar_opts do |args|
      event = args[:event]
      link_to(event.name, :action => 'show', :controller => 'events', :month => params[:month], :year => params[:year], :id => event.id)
    end
  end
end