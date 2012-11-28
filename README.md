# Sinatra::Scope

Simple nested routes in sinatra.

## Installation

    > gem install sinatra-scope

    # Gemfile
    gem 'sinatra-scope'

## Usage

The `scope` method is provided as a class method for `Sinatra::Base`. An
example shows this better than anything else.

```ruby
class Blog < Sinatra::Base
  register Sinatra::Scope

  scope :posts do
    get do
      @posts = Post.published.paginate(params)
      erb :posts
    end

    get(:new) do
      @post = Post.new
      erb(:new_post)
    end

    post do
      @post = Post.new(params[:post])
      if @post.save
        redirect "/posts/#{@post.id}"
      else
        erb(:new_post)
      end
    end

    scope ":id" do
      before { @post = Post.find(params[:id]) }

      get { erb(:post) }

      get(:edit) { erb(:edit_post) }

      put do
        if @post.update_attributes params[:post]
          redirect "/posts/#{@post.id}"
        else
          erb(:edit_post)
        end
      end

      delete do
        @post.destroy
        redirect "/posts"
      end
    end
  end
end
```

## TODO

* before and after in an unamed scope leak out of the scope
* Is there a way to scope template names?
* Track scopes as named urls
