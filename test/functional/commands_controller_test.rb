require 'test_helper'

class CommandsControllerTest < ActionController::TestCase
  setup do
    @command = commands(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:commands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create command" do
    assert_difference('Command.count') do
      post :create, command: @command.attributes
    end

    assert_redirected_to command_path(assigns(:command))
  end

  test "should show command" do
    get :show, id: @command.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @command.to_param
    assert_response :success
  end

  test "should update command" do
    put :update, id: @command.to_param, command: @command.attributes
    assert_redirected_to command_path(assigns(:command))
  end

  test "should destroy command" do
    assert_difference('Command.count', -1) do
      delete :destroy, id: @command.to_param
    end

    assert_redirected_to commands_path
  end
end
