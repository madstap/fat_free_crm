# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EmailsController, "handling GET /emails" do
  MEDIATOR = [:account, :campaign, :contact, :lead, :opportunity].freeze

  before(:each) do
    require_user
  end

  # DELETE /emails/1
  # DELETE /emails/1.xml                                                 AJAX
  #----------------------------------------------------------------------------
  describe "responding to DELETE destroy" do
    describe "AJAX request" do
      describe "with valid params" do
        MEDIATOR.each do |asset|
          it "should destroy the requested email and render [destroy] template" do
            @asset = FactoryGirl.create(asset)
            @email = FactoryGirl.create(:email, mediator: @asset, user: current_user)
            allow(Email).to receive(:new).and_return(@email)

            xhr :delete, :destroy, id: @email.id
            expect { Email.find(@email.id) }.to raise_error(ActiveRecord::RecordNotFound)
            expect(response).to render_template("emails/destroy")
          end
        end
      end
    end
  end
end
