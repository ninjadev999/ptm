require 'test_helper'

class AccountSoicalSitesContollerControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get account_soical_sites_contoller_new_url
    assert_response :success
  end

  test "should get create" do
    get account_soical_sites_contoller_create_url
    assert_response :success
  end

  test "should get show" do
    get account_soical_sites_contoller_show_url
    assert_response :success
  end

  test "should get update" do
    get account_soical_sites_contoller_update_url
    assert_response :success
  end

  test "should get destroy" do
    get account_soical_sites_contoller_destroy_url
    assert_response :success
  end

end
