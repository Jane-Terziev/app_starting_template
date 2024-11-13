module ApplicationHelper
  def input_field(form:, field_name:, name:, type: "text", label:, options: {})
    unless [Array, Symbol, String].include?(field_name.class)
      raise StandardError.new("#{field_name} is not an array of strings, symbols or integers. #{field_name.class.name}")
    end

    field_names_array = [ field_name ] unless field_name.is_a?(Array)

    div_class = options[:div_class] || "field label round border no-margin"
    field_errors = form.errors.dig(*field_names_array)
    div_class += " invalid" if field_errors

    input_div = content_tag(:div, class: div_class) do
      concat tag(:input, { "type" => type, "name" => name, "id" => sanitize_to_id(name), "value" => form.params.dig(*field_names_array) }.update(options.stringify_keys))
      concat label_tag(name, label)
    end

    error_div = content_tag(:div, class: "error-text left-margin bottom-margin") do
      concat content_tag(:span, (field_errors&.join(" and ") || "").humanize)
    end

    content_tag(:div) do
      concat input_div
      concat error_div
    end.html_safe
  end
end
