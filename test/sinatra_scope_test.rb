require File.expand_path 'helper', File.dirname(__FILE__)

class ScopeTest < Test::Unit::TestCase

  it "supports the scope method" do
    mock_app do
      scope "admin" do
        get "/login" do
          "/admin/login works"
        end
      end
    end

    get "/admin/login"
    assert ok?
    assert_equal "/admin/login works", response.body
  end

  %w[get put post delete].each do |verb|
    it "defines #{verb.upcase} request handlers with #{verb}" do
      mock_app {
        send verb, '/hello' do
          'Hello World'
        end
      }

      request = Rack::MockRequest.new(@app)
      response = request.request(verb.upcase, '/hello', {})
      assert response.ok?
      assert_equal 'Hello World', response.body
    end
  end

  %w[get put post delete].each do |verb|
    it "defines scoped #{verb.upcase} request handlers with #{verb}" do
      mock_app {
        scope "something" do
          send verb, '/hello' do
            'Hello World'
          end
        end
      }

      request = Rack::MockRequest.new(@app)
      response = request.request(verb.upcase, '/something/hello', {})
      assert response.ok?
      assert_equal 'Hello World', response.body
    end
  end

  it "defines HEAD request handlers with HEAD" do
    mock_app {
      head '/hello' do
        response['X-Hello'] = 'World!'
        'remove me'
      end
    }

    request = Rack::MockRequest.new(@app)
    response = request.request('HEAD', '/hello', {})
    assert response.ok?
    assert_equal 'World!', response['X-Hello']
    assert_equal '', response.body
  end

  it "defines scoped HEAD request handlers with HEAD" do
    mock_app {
      scope "something" do
        head '/hello' do
          response['X-Hello'] = 'World!'
          'remove me'
        end
      end
    }

    request = Rack::MockRequest.new(@app)
    response = request.request('HEAD', '/something/hello', {})
    assert response.ok?
    assert_equal 'World!', response['X-Hello']
    assert_equal '', response.body
  end
  
  it "404s when no route satisfies the request" do
    mock_app {
      get('/foo') { }
    }
    get '/bar'
    assert_equal 404, status
  end
  
  it 'takes multiple definitions of a route' do
    mock_app {
      user_agent(/Foo/)
      get '/foo' do
        'foo'
      end

      get '/foo' do
        'not foo'
      end
    }

    get '/foo', {}, 'HTTP_USER_AGENT' => 'Foo'
    assert ok?
    assert_equal 'foo', body

    get '/foo'
    assert ok?
    assert_equal 'not foo', body
  end
 
  it 'takes multiple definitions of a scoped route' do
    mock_app {
      scope "something" do
        user_agent(/Foo/)
        get '/foo' do
          'foo'
        end

        get '/foo' do
          'not foo'
        end
      end
    }

    get '/something/foo', {}, 'HTTP_USER_AGENT' => 'Foo'
    assert ok?
    assert_equal 'foo', body

    get '/something/foo'
    assert ok?
    assert_equal 'not foo', body
  end

  it 'supports regular expressions' do
    mock_app {
      get(/^\/foo...\/bar$/) do
        'Hello World'
      end
    }

    get '/foooom/bar'
    assert ok?
    assert_equal 'Hello World', body
  end
  
  it 'supports regular expressions' do
    mock_app {
      scope "something" do
        get(/\/foo...\/bar$/) do
          'Hello World'
        end
      end
    }

    get '/something/foooom/bar'
    assert ok?
    assert_equal 'Hello World', body
  end
  
  it 'raises a TypeError when pattern is not a String or Regexp' do
    assert_raise(TypeError) {
      mock_app { get(42){} }
    }
  end

  it 'supports helpers' do
    mock_app {
      helpers do
        def foo
          "bar"
        end
      end

      get "/foo" do
        foo
      end
      
      scope "something" do
        get "/foo" do
          foo
        end
      end
    }

    get '/foo'
    assert ok?
    assert_equal 'bar', body
  end
  
  it 'supports helpers in scoped urls' do
    mock_app {
      helpers do
        def foo
          "bar"
        end
      end

      get "/foo" do
        foo
      end
      
      scope "something" do
        get "/foo" do
          foo
        end
      end
    }

    get '/something/foo'
    assert ok?
    assert_equal 'bar', body
  end

  it 'supports helpers inside the scope' do
    mock_app {
      scope "something" do
        helpers do
          def foo
            "bar"
          end
        end

        get "/foo" do
          foo
        end
      end
    }

    get '/something/foo'
    assert ok?
    assert_equal 'bar', body
  end

  it 'keeps helpers inside the scope' do
    mock_app {
      scope "something" do
        helpers do
          def foo
            "bar"
          end
        end

        get "/foo" do
          foo
        end
      end

      get "/foo" do
        foo
      end
    }

    assert_raise(NoMethodError) {
      get '/foo'
    }
  end

end
