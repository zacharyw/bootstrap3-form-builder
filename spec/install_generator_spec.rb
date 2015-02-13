require 'spec_helper'

# Generators are not automatically loaded by Rails
require 'generators/bootstrap3_form_builder/install_generator'

include Boostrap3FormBuilderSpecHelper

#these tests use the ammeter gem
describe Bootstrap3FormBuilder::Generators::InstallGenerator, :type => :generator do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../../tmp", __FILE__)

  before do
    prepare_destination
  end

  describe 'defaults' do
    before do
      run_generator
    end

    describe 'config/initializers/bootstrap3_form_builder.rb' do
      subject { file('config/initializers/bootstrap3_form_builder.rb') }
      it { should exist }
      it { should contain "config.error_partial = \"bootstrap3_form_builder/error_messages\"" }
    end

    describe 'app/views/bootstrap3_form_builder/_error_messages.html.erb' do
      subject { file('app/views/bootstrap3_form_builder/_error_messages.html.erb') }
      it { should exist }
      it { should contain "\#{pluralize(target.errors.count, \"error\")} prohibited this from being saved:" }
      it { should contain "<div class=\"alert alert-danger\" role=\"alert\">" }
      it { should contain "<% target.errors.full_messages.each do |msg| %>" }
    end
  end

  describe 'haml' do
    before do
      run_generator %w(--view-engine haml)
    end

    describe 'app/views/bootstrap3_form_builder/_error_messages.html.haml' do
      subject { file('app/views/bootstrap3_form_builder/_error_messages.html.haml') }
      it { should exist }
      it { should contain "%div.alert.alert-danger{:role => 'alert'}" }
      it { should contain "=pluralize(target.errors.count, \"error\") + \" prohibited this record from being saved:\"" }
      it { should contain "- target.errors.full_messages.each do |msg|" }
    end
  end 
end
