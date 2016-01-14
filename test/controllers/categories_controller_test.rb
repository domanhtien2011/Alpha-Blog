require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  def setup
    # Use create method to create and hit and the database
    @category = Category.create(name: "sports")
    @user = User.create(username: "Yasuo", email: "yasuo@gmail.com", admin: true, password: "123")
  end

  test "Should get categories index"  do
    get :index
    assert_response :success
  end

  test "Should get new"  do
    session[:user_id] = @user.id
    get :new
    assert_response :success
  end

  test "Should get show"  do
    get(:show, { 'id' => @category.id })
    assert_response :success
  end

  test "Should redirect create when admin not logged in " do
    assert_no_difference 'Category.count' do
      post :create, category: {name: "love"}
    end
    assert_redirected_to categories_path
  end
end
