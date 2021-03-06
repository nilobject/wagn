require File.expand_path('../../spec_helper', File.dirname(__FILE__))

describe Card, "account functions" do
  before(:each) do
    Account.current_id= Card['joe_user'].id
    @auth_card = Account.current
    #warn "auth is #{@auth_card.inspect}"
  end

  it "should not show account for link on user's card (allready has an account)" do
    # render rules menu
    rendered = Wagn::Renderer::Html.new(@auth_card).render_options
    rendered.should_not match("Add a sign-in account for")
  end

  it "should not show account for link on another user's card (allready has an account)" do
    # render rules menu
    Account.current_id= Card['joe_admin'].id
    rendered = Wagn::Renderer::Html.new(@auth_card).render_options
    rendered.should_not match("Add a sign-in account for")
  end

  it 'should show for card without "accountable" on' do
    rendered = Wagn::Renderer::Html.new(Card['A']).render_options
    rendered.should_not match("Add a sign-in account for")
  end

  it 'should show for card with "accountable" on' do
    Account.as_bot do
      Card.create :name=>'A+*self+*accountable', :content=>'1'
      Card.create :name=>'*account+*right+*create', :content=>'[[Anyone Signed In]]'
    end
    rendered = Wagn::Renderer::Html.new(Card['A']).render_options
    rendered.should match("Add a sign-in account for")
  end

  it "should generate new password on forgotpassword" do
  end

end
