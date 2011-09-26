class Admin::EventsController < ApplicationController
  
  before_filter :authenticate_admin
  
  layout 'admin/layouts/main'
  
  def index
    @events = Event.order("start_at DESC")
  end
  
  def new
    @event = Event.new
  end
  
  def show
    @event = Event.find(params[:id])
    # @ics_exists = File.exists?("public/downloads/events/#{@event.name.underscore}.ics")
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.save
      @event.deliver_to_listhost
      flash[:notice] = "The event was saved and e-mailed to the listhost."
      # @event.create_ics
      #flash[:notice] = "The event was saved."
      redirect_to admin_events_path
    else
      flash[:notice] = "The event could not be saved."
      render :action => 'new'
    end
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
=begin  
  def create_ics
    @event = Event.find(params[:id])
    redirect_to :action => 'show', :id => @event.id
  end
=end
  
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      @event.create_ics
      flash[:notice] = "Event updated successfully."
      redirect_to admin_events_path
    else
      flash[:notice] = "Event could not be updated"
      render :action => 'edit'
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:notice] = "The event was deleted."
      redirect_to admin_events_path
    else
      flash[:notice] = "The event could not be deleted."
      redirect_to :action => 'show'
    end
  end
  
end