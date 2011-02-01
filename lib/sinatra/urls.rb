require 'sinatra/scope'
require 'active_support/core_ext/class/attribute'

module Sinatra

  class UrlTracker
    class_attribute :urls
    self.urls = {}

    def self.add(path, scopes = [], options = {})
      name = (scopes.join("_") + "_" + path.to_s).gsub(/^_|_$/, "")

      if name =~ /[a-zA-z0-9_\-%]/
        self.urls[name] = ("/" + scopes.join("/") + "/" + path).squeeze("/")
      end
    end
  end

  module UrlScope

    def scope(path, options = {}, &block)
      UrlTracker.add(super, @scopes, options)
    end

  end

  class Base
    register UrlScope
  end

  module UrlHelpers

    def url(name, *args)
      UrlTracker.urls[name.to_s]
    end

  end

  class Base
    helpers UrlHelpers
  end
end
