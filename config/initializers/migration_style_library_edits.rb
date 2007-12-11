module Kernel
  alias_method :standard_method_missing, :method_missing
  def method_missing(meth, *args)
    begin
      File.open("#{RAILS_ROOT}/lib/#{meth.to_s}_up.rb", 'r'){}
      File.open("#{RAILS_ROOT}/lib/#{meth.to_s}_down.rb", 'r'){}
      load "#{RAILS_ROOT}/lib/#{meth.to_s}_up.rb"
      yield
      load "#{RAILS_ROOT}/lib/#{meth.to_s}_down.rb"
    rescue
      standard_method_missing(meth, *args)
    end
  end
end