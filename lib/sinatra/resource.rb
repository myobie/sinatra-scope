require 'sinatra/scope'

module Sinatra
  module Resource

    def resource(name, &block)
      scope name, &block
    end
    alias resources resource

    def member(&block)
      scope ":id", &block
    end

    def index(&block)
      get &block
    end

    def _new(&block)
      get "/new", &block
    end

    def create(&block)
      post &block
    end

    def show(&block)
      if block.arity == 0
        get &block
      else
        get { block.call(params[:id]) }
      end
    end

    def edit(&block)
      if block.arity == 0
        get "/edit", &block
      else
        get("/edit") { block.call(params[:id]) }
      end
    end

    def update(&block)
      if block.arity == 0
        put &block
      else
        put { block.call(params[:id]) }
      end
    end

    def _delete(&block)
      if block.arity == 0
        get "/delete", &block
      else
        get("/delete") { block.call(params[:id]) }
      end
    end

    def destroy(&block)
      if block.arity == 0
        delete &block
      else
        delete { block.call(params[:id]) }
      end
    end

  end

  class Base
    register Resource
  end
end
