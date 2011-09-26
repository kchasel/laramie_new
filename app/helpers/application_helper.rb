# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def blind(id)
    update_page do |page|
      page.visual_effect :toggle_blind, id, :duration => 0.5
      page.delay(0.5) do
        page << "stickToBottom()"
      end
    end
  end
  
  def slide(id)
    update_page do |page|
      page.visual_effect :toggle_slide, id, :duration => 0.8
      page.delay(1) do
        page << "stickToBottom();"
      end
    end
  end
  
end
