require 'test_helper'

class CsvExportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @csv_export = csv_exports(:one)
  end

  test "should get index" do
    get csv_exports_url
    assert_response :success
  end

  test "should get new" do
    get new_csv_export_url
    assert_response :success
  end

  test "should create csv_export" do
    assert_difference('CsvExport.count') do
      post csv_exports_url, params: { csv_export: { content: @csv_export.content, user_id: @csv_export.user_id, year: @csv_export.year } }
    end

    assert_redirected_to csv_export_url(CsvExport.last)
  end

  test "should show csv_export" do
    get csv_export_url(@csv_export)
    assert_response :success
  end

  test "should get edit" do
    get edit_csv_export_url(@csv_export)
    assert_response :success
  end

  test "should update csv_export" do
    patch csv_export_url(@csv_export), params: { csv_export: { content: @csv_export.content, user_id: @csv_export.user_id, year: @csv_export.year } }
    assert_redirected_to csv_export_url(@csv_export)
  end

  test "should destroy csv_export" do
    assert_difference('CsvExport.count', -1) do
      delete csv_export_url(@csv_export)
    end

    assert_redirected_to csv_exports_url
  end
end
