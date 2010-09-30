require File.expand_path 'helper', File.dirname(__FILE__)

class UrlHelperTest < Test::Unit::TestCase

  it "supports the url method" do
    mock_app do
      scope "admin" do
        get do
          "hello #{url(:admin)}"
        end
      end
    end

    get "/admin"
    assert ok?
    assert_equal "hello /admin", body
  end

  it "supports nested scopes with the url method" do
    mock_app do
      scope "admin" do
        scope "projects" do
          get do
            "hello #{url(:admin_projects)}"
          end
        end
      end
    end

    get "/admin/projects"
    assert ok?
    assert_equal "hello /admin/projects", body
  end

end
