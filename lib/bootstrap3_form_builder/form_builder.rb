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

        allow_pattern = allow_pattern?(options)

        validators = @object.class.validators_on(label).select { |validator| !validator.options.key? :if }

        set_presence_options(validators, options)
        set_length_options(validators, options)
        set_inclusion_options(validators, options)
        set_numericality_options(validators, options)
        set_format_options(validators, options, method_name)

        if !options[:class] && method_name != :check_box
          options[:class] = "form-control"
        end

        input_prefix = options[:input_prefix] ? @template.content_tag("div", options[:input_prefix], :class => "input-group-addon") : ""
        input_suffix = options[:input_suffix] ? @template.content_tag("div", options[:input_suffix], :class => "input-group-addon") : ""

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

        if method_name == :check_box
          return @template.content_tag("div",
                    @template.content_tag("label",
                      input.html_safe + custom_label),
                        :class => "checkbox")
        end

        @template.content_tag("div",
          @template.content_tag("label",
                    custom_label,
                    :for => "#{@object_name}_#{label}",
                    :class => label_class)  + input.html_safe,
                      :class => control_group_class(label))
      end
    end

    field_helpers.each do |name|
      create_tagged_field(name)
    end

    private
    def allow_pattern?(options)
      if options[:pattern]
        return false
      end

      true
    end

    def set_presence_options(validators, options)
      if validators.collect(&:class).include?(ActiveRecord::Validations::PresenceValidator) || validators.collect(&:class).include?(ActiveModel::Validations::PresenceValidator)
        options[:required] = true
      end
    end

    def set_length_options(validators, options)
      length_validator = (validators.select { |v| v.class == ActiveModel::Validations::LengthValidator}).first

      if length_validator && allow_pattern?(options)
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
    end

    def set_inclusion_options(validators, options)
      inclusion_validator = (validators.select { |v| v.class == ActiveModel::Validations::InclusionValidator}).first

        if inclusion_validator && allow_pattern?(options)
          valid_options = inclusion_validator.options[:in] || inclusion_validator.options[:within]

          options[:pattern] = "(#{valid_options.join("|")})"
          options[:title] = inclusion_validator.options[:message] || "#{options[:title]} - Must be one of the following: #{valid_options.join(", ")}"
        end
    end

    def set_numericality_options(validators, options)
      numericality_validator = (validators.select{ |v| v.class == ActiveModel::Validations::NumericalityValidator}).first

      if numericality_validator && !options[:type]
        options[:type] = "number"

        if allow_pattern?(options)
          options[:pattern] = "\\d*"
        end

        if numericality_validator.options[:only_integer]
          options[:step] = 1
        else
          options[:step] = "any"
        end
      end
    end

    def set_format_options(validators, options, method_name)
      format_validator = (validators.select { |v| v.class == ActiveModel::Validations::FormatValidator}).first

      if format_validator && allow_pattern?(options) && !method_name.to_s.include?('email')
        options[:pattern] = format_validator.options[:with].source.html_safe
        options[:title] = format_validator.options[:message] || "#{options[:title]} is not a valid format"
      end
    end

    def control_group_class(label)
      unless @object.errors.messages[label].blank? && @object.errors.messages[label.to_sym].blank?
        return "form-group error"
      end

      "form-group"
    end
  end
end
