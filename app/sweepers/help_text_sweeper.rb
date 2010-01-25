class HelpTextSweeper < ActionController::Caching::Sweeper
  observe HelpText # This sweeper is going to keep an eye on the HelpText model
  def after_update(text)
    expire_fragment(:id => text.id, :action=>'show')
  end
  
end