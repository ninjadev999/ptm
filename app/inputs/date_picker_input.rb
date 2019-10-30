# frozen_string_literal: true

class DatePickerInput < SimpleForm::Inputs::Base
  def input
    template.content_tag(:div, class: "input-group date form_date") do
      template.concat @builder.text_field(attribute_name, input_html_options)
      template.concat span_remove
      template.concat span_table
    end
  end

  def input_html_options
    # super.merge({class: 'form-control datetimepicker-input', data: { 'date-use-current' => 'false', 'date-default-date' => 7.days.from_now.to_date, 'date-min-date' => 7.days.from_now.to_date, 'date-max-date' => 3.weeks.from_now.to_date, toggle: "datetimepicker", target: "#interview_starts_at" }})
    super.merge(class: "form-control", value: value, data: { "date-use-current" => "false", "date-default-date" => DateTime.now.to_date, "date-min-date" => DateTime.now.to_date, "date-max-date" => 1.month.from_now.to_date, toggle: "datetimepicker", target: "##{object.model_name.param_key}_#{attribute_name}" })
  end

  def span_remove
    template.content_tag(:span, class: "input-group-addon") do
      template.concat icon_remove
    end
  end

  def span_table
    template.content_tag(:span, class: "input-group-addon") do
      template.concat icon_table
    end
  end

  def icon_remove
    "<i class='glyphicon glyphicon-remove'></i>".html_safe
  end

  def icon_table
    "<i class='glyphicon glyphicon-th'></i>".html_safe
  end

private

  def value
    if object[attribute_name]
      object[attribute_name]
    else
      Date.tomorrow
    end.strftime("%m/%d/%Y")
  end
end
