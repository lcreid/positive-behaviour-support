# frozen_string_literal: true

module ApplicationHelper
  # Convert a string into something that can be used as a CSS class, when it's only
  # needed for testing, i.e., doesn't affect appearance of the page.
  def css_test_class(string)
    "test-" + string.parameterize
  end

  # From http://railscasts.com/episodes/196-nested-model-form-revised
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: "add_fields", data: { id: id, fields: fields.delete("\n") })
  end

  # Suggestion from the net to keep forms for nested resources DRY
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end

  def validation_messages(object)
    content_for :flashes do
      render partial: "flashes", locals: { object: object }
    end
    #    if object.errors.any?
    #      content_for :validation_messages do
    #        content = %[
    #         <div id="error_explanation">
    #          <h2> #{pluralize(object.errors.count, "error")} prohibited this #{object.class.name.underscore.humanize.downcase} from being saved:</h2>
    #          <ul>
    #        ]
    #          object.errors.full_messages.each do |msg|
    #            content += "<li>#{msg}</li>"
    #          end
    #        content += %[
    #          </ul>
    #        </div>
    #        ]
    #        content.html_safe
    #      end
    #    end
  end
end
