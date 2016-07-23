require 'test_helper'

class ImmeublesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:immeubles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create immeubles" do
    assert_difference('Immeubles.count') do
      post :create, :immeubles => { }
    end

    assert_redirected_to immeubles_path(assigns(:immeubles))
  end

  test "should show immeubles" do
    get :show, :id => immeubles(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => immeubles(:one).id
    assert_response :success
  end

  test "should update immeubles" do
    put :update, :id => immeubles(:one).id, :immeubles => { }
    assert_redirected_to immeubles_path(assigns(:immeubles))
  end

  test "should destroy immeubles" do
    assert_difference('Immeubles.count', -1) do
      delete :destroy, :id => immeubles(:one).id
    end

    assert_redirected_to immeubles_path
  end
end
