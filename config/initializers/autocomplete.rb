module Rails3JQueryAutocomplete
  module Helpers
    def get_autocomplete_items(parameters)
      model = parameters[:model]
      method = parameters[:method]
      options = parameters[:options]
      scope_level = options[:scope];
      if model == User && method == :cop_email
        method = :email
        scope_level = :live
      end
      model = model.send(scope_level) if scope_level
      term = parameters[:term]
      is_full_search = options[:full]
      
      limit = get_autocomplete_limit(options)
      implementation = get_implementation(model)
      order = get_autocomplete_order(implementation, method, options)

      case implementation
        when :mongoid
          search = (is_full_search ? '.*' : '^') + term + '.*'
          items = model.where(method.to_sym => /#{search}/i).limit(limit).order_by(order)
        when :activerecord
          items = model.where(["LOWER(#{method}) LIKE ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]) \
            .limit(limit).order(order)
      end
    end

  end

end