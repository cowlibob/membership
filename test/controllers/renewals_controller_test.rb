require 'test_helper'

class RenewalsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should prevent duplicate renewals and send reminder email" do
    # Setup: Create an existing renewal for this year
    existing_renewal = Renewal.create!(
      membership_class: 'Full',
      email: 'test@example.com',
      address_1: '123 Test Street',
      postcode: 'S1 1AA'
    )
    existing_renewal.generate_token!
    existing_renewal.create_primary_member!(
      first_name: 'Test',
      last_name: 'Member',
      email: 'test@example.com',
      phone: '01234567890',
      primary: true
    )
    
    # Attempt to create a duplicate renewal with same primary member email
    assert_difference 'Renewal.count', 0 do
      post :create, params: {
        renewal: {
          membership_class: 'Full',
          email: 'test@example.com',
          address_1: '456 Different Street',
          postcode: 'S2 2BB',
          primary_member_attributes: {
            first_name: 'Test',
            last_name: 'Member',
            email: 'test@example.com',
            phone: '01234567890'
          }
        }
      }
    end
    
    # Should redirect back to new renewal page with notice
    assert_redirected_to new_renewal_path
    assert_match /already have a renewal in progress/, flash[:notice]
  end

end
