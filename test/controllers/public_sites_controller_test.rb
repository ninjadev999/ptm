require 'test_helper'

class PublicSitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @public_site = public_sites(:one)
  end

  test "should get index" do
    get public_sites_url
    assert_response :success
  end

  test "should get new" do
    get new_public_site_url
    assert_response :success
  end

  test "should create public_site" do
    assert_difference('PublicSite.count') do
      post public_sites_url, params: { public_site: { image_url: @public_site.image_url, name: @public_site.name, url: @public_site.url } }
    end

    assert_redirected_to public_site_url(PublicSite.last)
  end

  test "should show public_site" do
    get public_site_url(@public_site)
    assert_response :success
  end

  test "should get edit" do
    get edit_public_site_url(@public_site)
    assert_response :success
  end

  test "should update public_site" do
    patch public_site_url(@public_site), params: { public_site: { image_url: @public_site.image_url, name: @public_site.name, url: @public_site.url } }
    assert_redirected_to public_site_url(@public_site)
  end

  test "should destroy public_site" do
    assert_difference('PublicSite.count', -1) do
      delete public_site_url(@public_site)
    end

    assert_redirected_to public_sites_url
  end
end
