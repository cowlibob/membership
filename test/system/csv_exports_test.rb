require "application_system_test_case"

class CsvExportsTest < ApplicationSystemTestCase
  setup do
    @csv_export = csv_exports(:one)
  end

  test "visiting the index" do
    visit csv_exports_url
    assert_selector "h1", text: "Csv Exports"
  end

  test "creating a Csv export" do
    visit csv_exports_url
    click_on "New Csv Export"

    fill_in "Content", with: @csv_export.content
    fill_in "User", with: @csv_export.user_id
    fill_in "Year", with: @csv_export.year
    click_on "Create Csv export"

    assert_text "Csv export was successfully created"
    click_on "Back"
  end

  test "updating a Csv export" do
    visit csv_exports_url
    click_on "Edit", match: :first

    fill_in "Content", with: @csv_export.content
    fill_in "User", with: @csv_export.user_id
    fill_in "Year", with: @csv_export.year
    click_on "Update Csv export"

    assert_text "Csv export was successfully updated"
    click_on "Back"
  end

  test "destroying a Csv export" do
    visit csv_exports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Csv export was successfully destroyed"
  end
end
