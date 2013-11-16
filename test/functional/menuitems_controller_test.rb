require 'test_helper'

class MenuitemsControllerTest < ActionController::TestCase
  setup do
    @menuitem = menuitems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:menuitems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create menuitem" do
    assert_difference('Menuitem.count') do
      post :create, menuitem: @menuitem.attributes
    end

    assert_redirected_to menuitem_path(assigns(:menuitem))
  end

  test "should show menuitem" do
    get :show, id: @menuitem.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @menuitem.to_param
    assert_response :success
  end

  test "should update menuitem" do
    put :update, id: @menuitem.to_param, menuitem: @menuitem.attributes
    assert_redirected_to menuitem_path(assigns(:menuitem))
  end

  test "should destroy menuitem" do
    assert_difference('Menuitem.count', -1) do
      delete :destroy, id: @menuitem.to_param
    end

    assert_redirected_to menuitems_path
  end
end
