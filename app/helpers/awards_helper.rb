# frozen_string_literal: true

module AwardsHelper
  def error_tag(text = "")
    content_tag(:div, class: "invalid-feedback") do
      block_given? ? yield : text
    end
  end

  def help_tag(text = "")
    content_tag(:small, class: "form-text text-muted") do
      block_given? ? yield : text
    end
  end

  def number_field_tag(name, value = nil, options = {})
    label_keys = %i[hide_label label label_col skip_label]
    label = unless options[:skip_label]
              original_label_options = options.slice(*label_keys)
              label_options = {}
              label_classes = []
              label_text = case original_label_options[:label]
                           when String
                             original_label_options[:label]
                           when Hash
                             label_classes << original_label_options[:label][:class] if original_label_options[:label][:class]
                             original_label_options[:label][:text]
                           end
              label_options[:for] = options[:id] if options[:id]
              label_classes << "sr-only" if original_label_options[:hide_label]
              label_options[:class] = label_classes.compact.join(" ") unless label_classes.empty?
              label_tag(name, label_text, label_options)
            end

    options = options.except(*label_keys)
    classes = [options[:class], "form-control"]
    help = help_tag(options.delete(:help)) if options[:help]
    if options[:error]
      error = error_tag(options.delete(:error))
      classes << "is-invalid"
    end
    options[:class] = classes.compact.join(" ")

    # It's funny that `join` turns this into a string, but reduce done this way doesn't
    # Also, `reduce` can just take `:+`, but then the output is uglier.
    [label, super(name, value, options), help, error].compact.reduce { |memo, x| memo + "\n" + x }
  end
end
