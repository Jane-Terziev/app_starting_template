module ApplicationHelper
  def input_field(form:, field_name:, name:, type: "text", label:, options: {})
    div_class = options[:div_class] || "field label round border no-margin"
    field_errors = form.errors.to_hash.dig(field_name.to_sym)
    div_class += " invalid" if field_errors

    input_div = content_tag(:div, class: div_class) do
      concat tag(:input, { "type" => type, "name" => name, "id" => sanitize_to_id(name), "value" => form.send(field_name.to_sym) }.update(options.stringify_keys))
      concat label_tag(name, label)
    end

    error_div = content_tag(:div, class: "error-text left-margin bottom-margin") do
      concat content_tag(:span, field_errors&.join(" and ") || "")
    end

    content_tag(:div) do
      concat input_div
      concat error_div
    end.html_safe
  end
end
