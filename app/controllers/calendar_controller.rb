class CalendarController < ApplicationController
  
  layout 'main'
  before_filter :rightbar_support
  
  def index
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)
  end

  def day
    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i
    @day = (params[:day] || Time.zone.now.day).to_i
    @events = Calendar.get_events(@year, @month, @day)
    if @events.empty?
      redirect_to(calendar_path(@year, @month)) and return
    end
    
    if Date.valid_civil?(@year, @month, @day) == nil
      redirect_to :action => 'index', :year => @year, :month => @month and return
    end
    
    @date = Date.civil(@year, @month, @day)
    
  end
  
end