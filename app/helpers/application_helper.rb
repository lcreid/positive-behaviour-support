=begin
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
Copyright (c) Jade Systems Inc. 2013, 2014
=end

module ApplicationHelper
  # From http://railscasts.com/episodes/196-nested-model-form-revised
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  # Suggestion from the net to keep forms for nested resources DRY
  def shallow_args(parent, child)
    child.try(:new_record?) ? [parent, child] : child
  end

  def validation_messages(object)
    if object.errors.any?
      content_for :validation_messages do
        content = %[
         <div id="error_explanation">
          <h2> #{pluralize(object.errors.count, "error")} prohibited this #{object.class.name.underscore.humanize.downcase} from being saved:</h2>
          <ul>
        ] 
          object.errors.full_messages.each do |msg|
            content += "<li>#{msg}</li>"
          end
        content += %[
          </ul>
        </div>
        ]
        content
      end  
    end
  end
end
