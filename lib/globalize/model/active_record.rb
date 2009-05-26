require 'globalize/translation'
require 'globalize/locale/fallbacks'
require 'globalize/model/active_record/adapter'
require 'globalize/model/active_record/translated'

module Globalize
  module Model
    module ActiveRecord
      class << self
        def create_proxy_class(klass)
          short_name = klass.name.gsub(/.+::/, '')
          klass.parent.const_set "#{short_name}Translation", Class.new(::ActiveRecord::Base){
            set_table_name "#{klass.name}Translation".pluralize.underscore.gsub('/', '_')
            belongs_to "#{short_name.underscore}".intern, :class_name => klass.name, :foreign_key => "#{short_name.underscore}_id"
            
            def locale
              read_attribute(:locale).to_sym
            end
            
            def locale=(locale)
              write_attribute(:locale, locale.to_s)
            end
          }
        end

        def define_accessors(klass, attr_names)
          attr_names.each do |attr_name|
            klass.send :define_method, attr_name, lambda {
              globalize.fetch self.class.locale, attr_name
            }
            klass.send :define_method, "#{attr_name}=", lambda {|val|
              globalize.stash self.class.locale, attr_name, val
              self[attr_name] = val
            }
          end
        end
      end
    end
  end
end