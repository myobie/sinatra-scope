require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

module Sinatra
  module Scope

    [:get, :post, :put, :delete, :head].each do |verb|
      class_eval <<-EOT
        def #{verb}(path = '', options = {}, &block)
          super(full_path(path), options, &block)
        end
      EOT
    end

    def scope(path, options = {}, &block)
      case path
      when Class
        path = path.name
        path = path.demodulize unless options.delete(:full_classname)
        path = path.underscore.dasherize
        path = path.pluralize unless options.delete(:singular)
      else
        path = path.to_s
      end
      (@path_parts ||= []) << path
      block.call
      @path_parts.pop
    end

  protected
    def full_path(path)
      return path if @path_parts.nil? || @path_parts.empty?
      
      case path
      when String, Symbol
        "/" + @path_parts.join("/") + path.to_s
      when Regexp
        Regexp.new(Regexp.escape("/" + @path_parts.join("/")) + path.source)
      else
        path
      end
    end

  end

  register Scope
end
