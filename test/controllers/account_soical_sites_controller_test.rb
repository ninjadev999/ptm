require 'test_helper'

class AccountSoicalSitesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get account_soical_sites_new_url
    assert_response :success
  end

  test "should get create" do
    get account_soical_sites_create_url
    assert_response :success
  end

  test "should get show" do
    get account_soical_sites_show_url
    assert_response :success
  end

  test "should get update" do
    get account_soical_sites_update_url
    assert_response :success
  end

  test "should get destroy" do
    get account_soical_sites_destroy_url
    assert_response :success
  end

end
