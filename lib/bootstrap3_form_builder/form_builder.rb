module Bootstrap3FormBuilder
  class FormBuilder < ActionView::Helpers::FormBuilder
    #Replace form submit input with styled buttons
    def submit(label, *args)
      options = args.extract_options!
      new_class = options[:class] || Bootstrap3FormBuilder.default_submit_style
      super(label, *(args << options.merge(:class => new_class)))
    end

=begin
Generates form fields that work with Twitter Bootstrap 3.
=end
    def self.create_tagged_field(method_name)
      define_method(method_name) do |label, *args|
        options = args.extract_options!

        custom_label = options[:label] || label.to_s.humanize
        options[:title] = options[:title] || custom_label.capitalize
        label_class = options[:label_class] || ""

        validators = @object.class.validators_on(label)

        if validators.collect(&:class).include?(ActiveRecord::Validations::PresenceValidator) || validators.collect(&:class).include?(ActiveModel::Validations::PresenceValidator)
          options[:required] = true
        end

        allow_pattern = true
        if options[:pattern]
          allow_pattern = false
        end

        length_validator = (validators.select { |v| v.class == ActiveModel::Validations::LengthValidator}).first

        if length_validator && allow_pattern
          maximum = length_validator.options[:maximum] || length_validator.options[:is] || (length_validator.options[:in] ? length_validator.options[:in].max : "")
          minimum = length_validator.options[:minimum] || length_validator.options[:is] || (length_validator.options[:in] ? length_validator.options[:in].min : "0")

          options[:pattern] = ".{#{minimum},#{maximum}}"

          if minimum == "0"
            options[:title] = "#{options[:title]} - #{maximum} characters maximum"
          elsif maximum == ""
            options[:title] = "#{options[:title]} - #{minimum} characters minimum"
          elsif minimum == maximum
            options[:title] = "#{options[:title]} - Must be exactly #{maximum} characters"
          else
            options[:title] = "#{options[:title]} - #{minimum} to #{maximum} characters"
          end
        end

        inclusion_validator = (validators.select { |v| v.class == ActiveModel::Validations::InclusionValidator}).first

        if inclusion_validator && allow_pattern
          valid_options = inclusion_validator.options[:in] || inclusion_validator.options[:within]

          options[:pattern] = "(#{valid_options.join("|")})"
          options[:title] = inclusion_validator.options[:message] || "#{options[:title]} - Must be one of the following: #{valid_options.join(", ")}"
        end

        numericality_validator = (validators.select{ |v| v.class == ActiveModel::Validations::NumericalityValidator}).first

        if numericality_validator && !options[:type]
          options[:type] = "number"

          if allow_pattern
            options[:pattern] = "\\d*"
          end

          if numericality_validator.options[:only_integer]
            options[:step] = 1
          else
            options[:step] = "any"
          end
        end

        format_validator = (validators.select { |v| v.class == ActiveModel::Validations::FormatValidator}).first

        if format_validator && allow_pattern && !method_name.include?('email')
          options[:pattern] = format_validator.options[:with].source.html_safe
          options[:title] = format_validator.options[:message] || "#{options[:title]} is not a valid format"
        end

        control_group_class = "form-group"
        if @object.errors.messages[label]
          control_group_class = control_group_class + " error"
        end

        if !options[:class]
          options[:class] = "form-control"
        end

        input_prefix = ""
        input_suffix = ""

        if options[:input_prefix]
          input_prefix = @template.content_tag("div", options[:input_prefix], :class => "input-group-addon")
        end

        if options[:input_suffix]
          input_suffix = @template.content_tag("div", options[:input_suffix], :class => "input-group-addon")
        end

        if !input_prefix.empty? || !input_suffix.empty?
          input = @template.content_tag("div",
                    input_prefix.html_safe +
                    super(label, *(args << options)) +
                    input_suffix.html_safe,
                    :class => "input-group " + (options[:input_container_class] || ""))
        else
          input = super(label, *(args << options))

          if options[:input_container_class]
            input = @template.content_tag("div", input.html_safe, :class => options[:input_container_class])
          end
        end

        input = input.html_safe +
                (options[:help_block] ? @template.content_tag("p", options[:help_block], :class => "help-block") : "" ) +
                (options[:help_inline] ? @template.content_tag("span", options[:help_inline], :class => "help-inline") : "" )

        @template.content_tag("div",
          @template.content_tag("label",
                    custom_label,
                    :for => "#{@object_name}_#{label}",
                    :class => label_class)  + input.html_safe,
                      :class => control_group_class)
      end
    end

    field_helpers.each do |name|
      create_tagged_field(name)
    end
  end
end
