require 'test_helper'

class SocialSitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @social_site = social_sites(:one)
  end

  test "should get index" do
    get social_sites_url
    assert_response :success
  end

  test "should get new" do
    get new_social_site_url
    assert_response :success
  end

  test "should create social_site" do
    assert_difference('SocialSite.count') do
      post social_sites_url, params: { social_site: { image_url: @social_site.image_url, name: @social_site.name } }
    end

    assert_redirected_to social_site_url(SocialSite.last)
  end

  test "should show social_site" do
    get social_site_url(@social_site)
    assert_response :success
  end

  test "should get edit" do
    get edit_social_site_url(@social_site)
    assert_response :success
  end

  test "should update social_site" do
    patch social_site_url(@social_site), params: { social_site: { image_url: @social_site.image_url, name: @social_site.name } }
    assert_redirected_to social_site_url(@social_site)
  end

  test "should destroy social_site" do
    assert_difference('SocialSite.count', -1) do
      delete social_site_url(@social_site)
    end

    assert_redirected_to social_sites_url
  end
end
