if RUBY_VERSION < '1.9'
  module Date::Format::EuropeanDates
    def self.included(base)
      base.class_eval do
        class << self
          if RUBY_VERSION == '1.8.6'
            # From here: http://fatvegan.com/2008/05/27/european-dates-in-ruby-on-rails/
            alias_method :_parse_sla_us, :_parse_sla_eu
          else
            # Rewrite Ruby's _parse_sla method.
            def _parse_sla(str, e) # :nodoc:
              if str.sub!(%r|('?-?\d+)/\s*('?\d+)(?:\D\s*('?-?\d+))?|n, ' ') # '
                s3e(e, $3, $2, $1)
                true
              end
            end
          end
        end
      end
    end
  end

  Date.send(:include, Date::Format::EuropeanDates)
end


Date::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("#{time.day.ordinalize} %b %Y") }
Date::DATE_FORMATS[:long_ordinal] = lambda { |time| time.strftime("#{time.day.ordinalize} %B, %Y") }