module SubscribersHelper
  
  def replace_html(id, *options_for_render)
    "$(#{id}).set({html: '#{escape_javascript(render *options_for_render)}'})"
  end
  
end
