require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
    @company_without_zip_code = companies(:armstrong_painting)
    @company_with_correct_mail = companies(:perk_painting)
    @company_with_blank_mail = companies(:central_designs)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show City, State text for company without zip code" do
    visit company_path(@company_without_zip_code)

    assert_text @company_without_zip_code.name
    assert_text @company_without_zip_code.phone
    assert_text @company_without_zip_code.email
    assert_text "City, State"
  end

  test "Show city and state for a valid zip_code" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text "Ventura, CA"
  end

  test "Update with blank email" do
    visit edit_company_path(@company_with_blank_mail)

    within("form#edit_company_#{@company_with_blank_mail.id}") do
      fill_in("company_name", with: "Central Designs n DDecor")
      fill_in("company_email", with: "")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company_with_blank_mail.reload
    assert_equal "Central Designs n DDecor", @company_with_blank_mail.name
    assert_equal "", @company_with_blank_mail.email
  end

  test "Update with correct email ending with @getmainstreet" do
    visit edit_company_path(@company_with_correct_mail)

    within("form#edit_company_#{@company_with_correct_mail.id}") do
      fill_in("company_name", with: "Perk Painting")
      fill_in("company_zip_code", with: "31008")
      fill_in("company_email", with: "perk@getmainstreet.com")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company_with_correct_mail.reload
    assert_equal "Perk Painting", @company_with_correct_mail.name
    assert_equal "31008", @company_with_correct_mail.zip_code
    assert_equal "perk@getmainstreet.com", @company_with_correct_mail.email
  end

  test "Won't Update Company with the email not ending with @getmainstreet if email exists" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      click_button "Update Company"
    end

    assert_text "Email :Please Enter your Email in example@getmainstreet.com format"

    @company.reload
    assert_equal "Hometown Painting", @company.name
    assert_equal "93003", @company.zip_code
  end

  test "Won't Create with the email not ending with @getmainstreet if email exists" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@test.com")
      click_button "Create Company"
    end

    assert_text "Email :Please Enter your Email in example@getmainstreet.com format"
  end

  test "Create with email ending with @getmainstreet" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "newtestcompany@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
    assert_equal "newtestcompany@getmainstreet.com", last_company.email
  end

  test "Create with blank email" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
    assert_equal "", last_company.email
  end

  test "Delete" do
    visit company_path(@company)
    del_name = @company.name
    click_link 'Delete'
    a = page.driver.browser.switch_to.alert
    assert ("Are you sure?"), a.text
    a.accept
    assert_text "#{del_name} DELETED!"
  end
end
