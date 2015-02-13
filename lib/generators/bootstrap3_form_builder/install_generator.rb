module Bootstrap3FormBuilder
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/bootstrap3_form_builder", __FILE__)

      class_option :view_engine, :type => :string, :aliases => "-t", :desc => "Template engine for the views. Available options are 'erb' and 'haml'.", :default => "erb"
      class_option :haml, :type => :boolean, :default => false

      # all public methods in here will be run in order
      def add_my_initializer
        template "initializer.rb", "config/initializers/bootstrap3_form_builder.rb"
      end

      def create_error_partials
        if options[:view_engine] == "haml" || options[:haml]
          copy_file "_error_messages.html.haml", "app/views/bootstrap3_form_builder/_error_messages.html.haml"
        elsif
          copy_file "_error_messages.html.erb", "app/views/bootstrap3_form_builder/_error_messages.html.erb"
        end
      end
    end
  end
end