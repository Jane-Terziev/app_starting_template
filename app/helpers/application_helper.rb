module ApplicationHelper
  def input_field(form:, field_name:, name:, type: "text", label:, options: {})
    output = ""
    div_class = options.has_key?(:div_class) ? options[:div_class] : "field label round border no-margin"
    error_text = show_error(form, field_name.to_sym)
    div_class += " invalid" if error_text
    input_div = content_tag(:div, class: div_class) do
      concat tag(:input, { "type" => type, "name" => name, "id" => sanitize_to_id(name), "value" => form.params.dig(field_name) }.update(options.stringify_keys))
      concat label_tag(name, label)
    end
    output << content_tag(:div) do
      concat input_div
      concat content_tag(:div, error_text, class: "error-text left-margin bottom-margin")
    end

    output.html_safe
  end

  def show_error(validator, keys)
    return unless validator.errors
    keys = [ keys ] unless keys.is_a?(Array)
    field_name = keys.last
    if validator.errors.any?
      result = find_value(validator.errors, keys)
      "#{field_name.to_s.humanize} #{result.join(', ')}" unless result.blank?
    end
  end

  def find_value(hash, keys)
    result = hash
    keys.each do |key|
      if result.is_a?(Hash) && result.key?(key)
        result = result[key]
      elsif result.is_a?(Array)
        result = result.map { |item| item.is_a?(Hash) ? item[key] : nil }.compact
        result = result.first if result.length == 1 # If there's only one element in the array
      else
        return nil
      end
    end
    result
  end
end
