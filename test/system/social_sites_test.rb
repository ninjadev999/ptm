require "application_system_test_case"

class SocialSitesTest < ApplicationSystemTestCase
  setup do
    @social_site = social_sites(:one)
  end

  test "visiting the index" do
    visit social_sites_url
    assert_selector "h1", text: "Social Sites"
  end

  test "creating a Social site" do
    visit social_sites_url
    click_on "New Social Site"

    fill_in "Image Url", with: @social_site.image_url
    fill_in "Name", with: @social_site.name
    click_on "Create Social site"

    assert_text "Social site was successfully created"
    click_on "Back"
  end

  test "updating a Social site" do
    visit social_sites_url
    click_on "Edit", match: :first

    fill_in "Image Url", with: @social_site.image_url
    fill_in "Name", with: @social_site.name
    click_on "Update Social site"

    assert_text "Social site was successfully updated"
    click_on "Back"
  end

  test "destroying a Social site" do
    visit social_sites_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Social site was successfully destroyed"
  end
end
