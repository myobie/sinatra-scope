require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'
require 'sinatra/base'

module Sinatra
  module Scope

    [:get, :post, :put, :delete, :head].each do |verb|
      define_method verb do |path = '', options = {}, &block|
        super(full_path(path), options, &block)
      end
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

      (@scopes ||= []) << path
      block.call
      @scopes.pop
    end

  protected
    def full_path(path)
      return path if @scopes.nil? || @scopes.empty?
      
      case path
      when String, Symbol
        "/" + @scopes.join("/") + path.to_s
      when Regexp
        Regexp.new(Regexp.escape("/" + @scopes.join("/")) + path.source)
      else
        path
      end
    end

  end

  class Base
    register Scope
  end
end
