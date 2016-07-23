require File.dirname(__FILE__) + '/../test_helper'

class AppartementsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:appartements)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_appartement
    assert_difference('Appartement.count') do
      post :create, :appartement => { }
    end

    assert_redirected_to appartement_path(assigns(:appartement))
  end

  def test_should_show_appartement
    get :show, :id => appartements(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => appartements(:one).id
    assert_response :success
  end

  def test_should_update_appartement
    put :update, :id => appartements(:one).id, :appartement => { }
    assert_redirected_to appartement_path(assigns(:appartement))
  end

  def test_should_destroy_appartement
    assert_difference('Appartement.count', -1) do
      delete :destroy, :id => appartements(:one).id
    end

    assert_redirected_to appartements_path
  end
end
