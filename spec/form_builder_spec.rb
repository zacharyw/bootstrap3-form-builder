require 'spec_helper'

include Boostrap3FormBuilderSpecHelper

describe Bootstrap3FormBuilder::BootstrapFormHelper do

  it 'has config options' do
    expect(Bootstrap3FormBuilder).to have_attributes(:error_partial => nil, :default_form_layout => nil)
  end

  it 'yields to a config' do
    expect { |b| Bootstrap3FormBuilder.setup(&b) }.to yield_with_args(Bootstrap3FormBuilder)
  end

  it 'will configure' do
    Bootstrap3FormBuilder.setup do |config|
      config.error_partial = 'error_partial'
      config.default_form_layout = 'form_horizontal'
    end

    expect(Bootstrap3FormBuilder.error_partial).to eq('error_partial')
    expect(Bootstrap3FormBuilder.default_form_layout).to eq('form_horizontal')
  end

  describe 'bootstrap_form_for' do

    let(:view) { ActionView::Base.new }
    let(:new_record) { Boostrap3FormBuilderSpecHelper::Record.new }

    let(:subject) do
      bootstrap_form_for(new_record) do |builder|
        return builder
      end
    end

    def render(partial, locals)
      "Form: "
    end

    def form_for(record, options = {}, &block)
      view.form_for(record, options.merge(:builder => Bootstrap3FormBuilder::FormBuilder), &block)
    end

    it "should create bootstrap submit buttons" do
      expect(subject.submit('Submit')).to include( "class=\"btn btn-default\"")
    end

    it "should create required input for required attribute" do
      expect(subject.text_field('presence')).to include( "required=\"required\"")
    end

    it "should create input prefix and suffix" do
      output = subject.text_field('presence', {:input_prefix => "$", :input_suffix => ".00"})
      expect(output).to include( "class=\"form-control\"")
      expect(output).to include( "required=\"required\"")
      expect(output).to include( "<div class=\"input-group-addon\">$</div><input")
      expect(output).to include( "/><div class=\"input-group-addon\">.00</div>")
    end

    it "should default class to form-control, or accept passed in class" do
      expect(subject.text_field('presence')).to include( "class=\"form-control\"")

      output = subject.text_field('presence', {:class => 'test'})
      expect(output).to include( "class=\"test\"")
      expect(output).not_to include( "class=\"form-control\"")
    end

    it "should create container around input with given class" do
      output = subject.text_field('presence', {:input_container_class => "col-sm-10"})
      expect(output).to include( "<div class=\"col-sm-10\"><input")
    end

    it "should create regex pattern to enforce inclusion" do
      expect(subject.text_field('inclusion')).to include( "pattern=\"(Zach|Morgan|Jake)\"")
    end

    it "should create regex pattern to enforce numericality" do
      expect(subject.text_field('numericality')).to include( "pattern=\"\\d*\"")
      expect(subject.text_field('numericality')).to include( "step=\"any\"")
    end

    it "should create regex pattern to enforce integer only" do
      expect(subject.text_field('integer')).to include( "pattern=\"\\d*\"")
      expect(subject.text_field('integer')).to include( "step=\"1\"")
    end

    it "should create a pattern to enforce a minimum" do
      expect(subject.text_field('minimum')).to include( "pattern=\".{5,}\"")
      expect(subject.text_field('minimum')).to include( "title=\"Minimum - 5 characters minimum\"")
    end

    it "should create a pattern to enforce a maximum" do
      expect(subject.text_field('maximum')).to include( "pattern=\".{0,5}\"")
      expect(subject.text_field('maximum')).to include( "title=\"Maximum - 5 characters maximum\"")
    end

    it "should create a pattern to enforce a range" do
      expect(subject.text_field('range')).to include( "pattern=\".{5,10}\"")
      expect(subject.text_field('range')).to include( "title=\"Range - 5 to 10 characters\"")
    end

    it "should create a pattern to enforce an exact value" do
      expect(subject.text_field('exact')).to include( "pattern=\".{5,5}\"")
      expect(subject.text_field('exact')).to include( "title=\"Exact - Must be exactly 5 characters\"")
    end

    it "should enforce a format regex" do
      output = subject.text_field('legacy')
      expect(output).to include( "A[a-zA-Z]+\\z")
      expect(output).to include( "title=\"only allows letters\"")
    end

    it "should enforce multiple validators" do
      expect(subject.text_field('required_and_number')).to include( "required=\"required\"")
      expect(subject.text_field('required_and_number')).to include( "pattern=\"\\d*\"")
    end

    it "should create a label and container div" do
      output = subject.text_field('presence')
      expect(output).to include("class=\"form-group\"")
      expect(output).to include("label for=\"boostrap3_form_builder_spec_helper_record_presence\"")
    end
  end
end

