require 'test_helper'

class RepartitionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:repartitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create repartitions" do
    assert_difference('Repartitions.count') do
      post :create, :repartitions => { }
    end

    assert_redirected_to repartitions_path(assigns(:repartitions))
  end

  test "should show repartitions" do
    get :show, :id => repartitions(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => repartitions(:one).id
    assert_response :success
  end

  test "should update repartitions" do
    put :update, :id => repartitions(:one).id, :repartitions => { }
    assert_redirected_to repartitions_path(assigns(:repartitions))
  end

  test "should destroy repartitions" do
    assert_difference('Repartitions.count', -1) do
      delete :destroy, :id => repartitions(:one).id
    end

    assert_redirected_to repartitions_path
  end
end
