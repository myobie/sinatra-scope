require File.expand_path 'helper', File.dirname(__FILE__)

class ResourceTest < Test::Unit::TestCase

  it 'supports the resource method' do
    mock_app {
      resource "pages" do
        get do
          "Pages are great!"
        end
      end
    }

    get "/pages"
    assert ok?
    assert_equal "Pages are great!", body
  end

  it 'supports the resources method' do
    mock_app {
      resources "pages" do
        get do
          "Pages are great!"
        end
      end
    }

    get "/pages"
    assert ok?
    assert_equal "Pages are great!", body
  end

  it 'supports the member method' do
    mock_app {
      resource "pages" do
        member do
          get do
            "Page id: #{params[:id]}"
          end
        end
      end
    }

    get "/pages/3"
    assert ok?
    assert_equal "Page id: 3", body
  end

  it "supports the index method of a resource" do
    mock_app do
      resource "pages" do
        index do
          "Hello"
        end
      end
    end

    get "/pages"
    assert ok?
    assert_equal "Hello", body
  end

  it "supports the new (_new) method of a resource" do
    mock_app do
      resource "pages" do
        _new do
          "New page"
        end
      end
    end

    get "/pages/new"
    assert ok?
    assert_equal "New page", body
  end

  it "supports the create method of a resource" do
    mock_app do
      resource "pages" do
        create do
          "Created the page"
        end
      end
    end

    post "/pages", {}
    assert ok?
    assert_equal "Created the page", body
  end

  it "supports the show method of a resource" do
    mock_app do
      resource "pages" do
        member do
          show do
            "Page #{params[:id]}"
          end
        end
      end
    end

    get "/pages/1"
    assert ok?
    assert_equal "Page 1", body
  end

  it "supports the show method of a resource with the id argument" do
    mock_app do
      resource "pages" do
        member do
          show do |id|
            "Page #{id}"
          end
        end
      end
    end

    get "/pages/1"
    assert ok?
    assert_equal "Page 1", body
  end

  it "supports the edit method of a resource" do
    mock_app do
      resource "pages" do
        member do
          edit do
            "Edit page #{params[:id]}"
          end
        end
      end
    end

    get "/pages/1/edit"
    assert ok?
    assert_equal "Edit page 1", body
  end

  it "supports the edit method of a resource with the id argument" do
    mock_app do
      resource "pages" do
        member do
          edit do |id|
            "Edit page #{id}"
          end
        end
      end
    end

    get "/pages/1/edit"
    assert ok?
    assert_equal "Edit page 1", body
  end

  it "supports the update method of a resource" do
    mock_app do
      resource "pages" do
        member do
          update do
            "Updated page #{params[:id]}"
          end
        end
      end
    end

    put "/pages/1", {}
    assert ok?
    assert_equal "Updated page 1", body
  end

  it "supports the update method of a resource with the id argument" do
    mock_app do
      resource "pages" do
        member do
          update do |id|
            "Updated page #{id}"
          end
        end
      end
    end

    put "/pages/1", {}
    assert ok?
    assert_equal "Updated page 1", body
  end

  it "supports the delete (_delete) method of a resource" do
    mock_app do
      resource "pages" do
        member do
          _delete do
            "Page #{params[:id]}"
          end
        end
      end
    end

    get "/pages/1/delete"
    assert ok?
    assert_equal "Page 1", body
  end

  it "supports the delete (_delete) method of a resource with the id argument" do
    mock_app do
      resource "pages" do
        member do
          _delete do |id|
            "Page #{id}"
          end
        end
      end
    end

    get "/pages/1/delete"
    assert ok?
    assert_equal "Page 1", body
  end

  it "supports the destroy method of a resource" do
    mock_app do
      resource "pages" do
        member do
          destroy do
            "destroyd page #{params[:id]}"
          end
        end
      end
    end

    delete "/pages/1", {}
    assert ok?
    assert_equal "destroyd page 1", body
  end

  it "supports the destroy method of a resource with the id argument" do
    mock_app do
      resource "pages" do
        member do
          destroy do |id|
            "destroyd page #{id}"
          end
        end
      end
    end

    delete "/pages/1", {}
    assert ok?
    assert_equal "destroyd page 1", body
  end

  it 'supports using a class as a resource' do
    class Page; end

    mock_app {
      resource Page do
        _new do
          "Create a new page?"
        end
      end
    }

    get "/pages/new"
    assert ok?
    assert_equal "Create a new page?", body
  end

end
