module AccountsHelper
  
  def form_piece(name, local)
    render :partial => "form_#{name}", :locals => { :f => local }
  end
  

  
end
