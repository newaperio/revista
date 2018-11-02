defmodule Admin.InputHelpers do
  use Phoenix.HTML

  def input(form, field, opts \\ []) do
    type = opts[:using] || Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "form-group #{state_class(form, field)}"]
    label_opts = [class: "control-label"]
    input_opts = [class: "form-control"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = input(type, form, field, input_opts)
      error = Admin.ErrorHelpers.error_tag(form, field)
      [label, input, error || ""]
    end
  end

  defp state_class(form, field) do
    cond do
      # # The form was not yet submitted
      # !form.source.action -> ""
      form.errors[field] -> "has-error"
      true -> "has-success"
    end
  end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end
end
