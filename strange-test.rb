module Scope
  module ScopeMethods
    def helpers(&block)
      instance_eval(&block)
    end
  end

  def scope(path, &block)
    (@path_parts ||= []) << path

    context = eval('self', block.binding).dup
    context.extend ScopeMethods 
    context.instance_eval(&block)

    @path_parts.pop
  end
end

include Scope

scope "something" do
  helpers do
    def foo
      "bar"
    end
  end

  puts foo # => should work
end

puts foo # => should error


