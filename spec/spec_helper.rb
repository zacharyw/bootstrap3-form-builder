ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment", __FILE__)
require 'bootstrap3_form_builder'

module Rails
  module VERSION
    include ActionPack::VERSION
  end
end

require 'ammeter/init'

module Boostrap3FormBuilderSpecHelper
  include Bootstrap3FormBuilder::BootstrapFormHelper
  include Rails.application.routes.url_helpers
  include ActionController::PolymorphicRoutes if defined?(ActionController::PolymorphicRoutes)
  include ActionDispatch::Routing::PolymorphicRoutes

  Bootstrap3FormBuilder.setup do |config|
		config.default_submit_style = 'btn btn-default'
	end

	class Record
		extend ActiveModel::Naming if defined?(ActiveModel::Naming)
		include ActiveModel::Validations
		include ActiveModel::Conversion
		validates_presence_of :presence
    validates_presence_of :presence_if, if: "true"
		validates_inclusion_of :inclusion, in: %w(Zach Morgan Jake)
		validates_numericality_of :numericality
		validates_numericality_of :integer, only_integer: true
		validates_length_of :minimum, minimum: 5
		validates_length_of :maximum, maximum: 5
		validates_length_of :range, in: 5..10
		validates_length_of :exact, is: 5
		validates_presence_of :required_and_number
		validates_numericality_of :required_and_number
		validates_format_of :legacy, with: /\A[a-zA-Z]+\z/, message: "only allows letters"

		def presence
		end

    def presence_if
    end

		def inclusion
		end

		def numericality
		end

		def integer
		end

		def minimum
		end

		def maximum
		end

		def range
		end

		def exact
		end

		def required_and_number
		end

		def legacy
		end

		def persisted?
			return false
		end

	end

	def boostrap3_form_builder_spec_helper_records_path(*args); "/records"; end

	def protect_against_forgery?
      false
  end
end
