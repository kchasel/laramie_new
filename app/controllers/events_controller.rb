class EventsController < ApplicationController
  
  layout 'main'
  
  before_filter :rightbar_support, :except => [:download]
  
  def show  
    @event = Event.find(params[:id])
=begin
    if @event.start_at.year.to_i != params[:year].to_i or @event.start_at.month.to_i != params[:month].to_i
      raise "Event not found"
    end
=end
  rescue
    redirect_to :action => 'index', :controller => 'calendar', :year => params[:year], :month => params[:month]
  end
  
  def index
    redirect_to :action => 'index', :controller => 'calendar', :year => params[:year], :month => params[:month]
  end
  
  def download
    @event = Event.find(params[:id])
    @cal = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.start = @event.start_at.strftime("%Y%m%dT%H%M%S")
    event.end = @event.end_at.strftime("%Y%m%dT%H%M%S")
    event.summary = @event.name
    event.description = @event.description
    event.location = @event.address
    @cal.add event
    @cal.publish
    string = @cal.to_ical
    render :text => string, :header => "text/calendar"
  end
  
end