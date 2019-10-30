require "application_system_test_case"

class PublicSitesTest < ApplicationSystemTestCase
  setup do
    @public_site = public_sites(:one)
  end

  test "visiting the index" do
    visit public_sites_url
    assert_selector "h1", text: "Public Sites"
  end

  test "creating a Public site" do
    visit public_sites_url
    click_on "New Public Site"

    fill_in "Image Url", with: @public_site.image_url
    fill_in "Name", with: @public_site.name
    fill_in "Url", with: @public_site.url
    click_on "Create Public site"

    assert_text "Public site was successfully created"
    click_on "Back"
  end

  test "updating a Public site" do
    visit public_sites_url
    click_on "Edit", match: :first

    fill_in "Image Url", with: @public_site.image_url
    fill_in "Name", with: @public_site.name
    fill_in "Url", with: @public_site.url
    click_on "Update Public site"

    assert_text "Public site was successfully updated"
    click_on "Back"
  end

  test "destroying a Public site" do
    visit public_sites_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Public site was successfully destroyed"
  end
end
