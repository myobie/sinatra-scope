module Sinatra
  module Scope

    [:get, :post, :put, :delete, :head].each do |verb|
      class_eval <<-EOT
        def #{verb}(path = nil, options = {}, &block)
          super(full_path(path), options, &block)
        end
      EOT
    end

    def scope(path, &block)
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
end
