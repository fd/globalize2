module Globalize
  module Model
  
    class MigrationError < StandardError; end
    class UntranslatedMigrationField < MigrationError; end
    class MigrationMissingTranslatedField < MigrationError; end
    class BadMigrationFieldType < MigrationError; end
  
    module ActiveRecord
      module Translated
        def self.included(base)
          base.extend ActMethods
        end

        module ActMethods
          def translates(*attr_names)
            options = attr_names.extract_options!
            options[:translated_attributes] = attr_names

            # Only set up once per class
            unless included_modules.include? InstanceMethods
              class_inheritable_accessor :globalize_options, :globalize_proxy
              
              include InstanceMethods
              extend  ClassMethods
              
              singleton_class.alias_method_chain :find_every, :globalize2
              singleton_class.alias_method_chain :construct_finder_sql, :globalize2
              
              self.globalize_proxy = Globalize::Model::ActiveRecord.create_proxy_class(self)
              has_many(
                :globalize_translations,
                :class_name   => globalize_proxy.name,
                :extend       => Extensions,
                :dependent    => :delete_all,
                :foreign_key  => self.name.gsub(/.+::/, '').foreign_key
              )

              after_save :update_globalize_record              
            end

            self.globalize_options = options
            Globalize::Model::ActiveRecord.define_accessors(self, attr_names)
            
            # Import any callbacks that have been defined by extensions to Globalize2
            # and run them.
            extend Callbacks
            Callbacks.instance_methods.each {|cb| send cb }
          end

          def locale=(locale)
            @@locale = locale
          end
          
          def locale
            (defined?(@@locale) && @@locale) || I18n.locale
          end          
        end

        # Dummy Callbacks module. Extensions to Globalize2 can insert methods into here
        # and they'll be called at the end of the translates class method.
        module Callbacks
        end
        
        # Extension to the has_many :globalize_translations association
        module Extensions
          def by_locales(locales)
            find :all, :conditions => { :locale => locales.map(&:to_s) }
          end
        end
        
        module ClassMethods          
          def method_missing(method, *args)
            if method.to_s =~ /^find_by_(\w+)$/ && globalize_options[:translated_attributes].include?($1.to_sym)
              find(:first, :joins => :globalize_translations,
                   :conditions => [ "#{i18n_attr($1)} = ? AND #{i18n_attr('locale')} IN (?)",
                                   args.first,I18n.fallbacks[I18n.locale].map{|tag| tag.to_s}])
            else
              super
            end
          end
                    
          def create_translation_table!(fields)
            translated_fields = self.globalize_options[:translated_attributes]
            translated_fields.each do |f|
              raise MigrationMissingTranslatedField, "Missing translated field #{f}" unless fields[f]
            end
            fields.each do |name, type|
              unless translated_fields.member? name 
                raise UntranslatedMigrationField, "Can't migrate untranslated field: #{name}"
              end              
              unless [ :string, :text ].member? type
                raise BadMigrationFieldType, "Bad field type for #{name}, should be :string or :text"
              end 
            end
            translation_table_name = self.name.underscore.gsub('/', '_') + '_translations'
            self.connection.create_table(translation_table_name) do |t|
              t.integer self.name.gsub(/.+::/, '').foreign_key
              t.string :locale
              fields.each do |name, type|
                t.column name, type
              end
              t.timestamps              
            end
          end

          def drop_translation_table!
            translation_table_name = self.name.underscore.gsub('/', '_') + '_translations'
            self.connection.drop_table translation_table_name
          end
          
          def find_every_with_globalize2(options)
            locale  = I18n.locale
            locales = I18n.fallbacks[locale].map{ |tag| tag.to_s }
            scope_options = { :joins => :globalize_translations,
              :conditions => [ "#{i18n_attr('locale')} IN (?)", locales ] }
            with_scope(:find => scope_options) do
              find_every_without_globalize2(options)
            end
          end
          
          def construct_finder_sql_with_globalize2(options)
            sql = construct_finder_sql_without_globalize2(options)
            sql.sub! /SELECT(\s+DISTINCT)?/, 'SELECT DISTINCT'
            sql
          end
          
          private
          
          def i18n_attr(attribute_name)
            self.base_class.name.underscore.gsub('/', '_') + "_translations.#{attribute_name}"
          end          
        end
        
        module InstanceMethods
          def reload(options = nil)
            globalize.clear
            
            # clear all globalized attributes
            # TODO what's the best way to handle this?
            self.class.globalize_options[:translated_attributes].each do |attr|
              @attributes.delete attr.to_s
            end
            
            super options
          end
          
          def globalize
            @globalize ||= Adapter.new self
          end
          
          def update_globalize_record
            globalize.update_translations!
          end
          
          def translated_locales
            globalize_translations.scoped(:select => 'DISTINCT locale').map {|gt| gt.locale.to_sym }
          end
          
          def set_translations options
            options.keys.each do |key|

              translation = globalize_translations.find_by_locale(key.to_s) ||
                globalize_translations.build(:locale => key.to_s)
              translation.update_attributes!(options[key])
            end
          end
          
        end
      end
    end
  end
end