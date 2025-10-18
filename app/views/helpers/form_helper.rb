# frozen_string_literal: true

module Forked
  module Views
    module Helpers
      module FormHelper
        INPUT_CLASSES = "dark:read-only:bg-stone-900 read-only:bg-stone-100 dark:disabled:bg-stone-900 disabled:bg-stone-100 w-full px-3 py-2 border border-stone-200 dark:border-stone-700 bg-white dark:bg-stone-800 text-black dark:text-stone-100 rounded text-sm focus:outline-none focus:border-black dark:focus:border-stone-500 autofill:bg-stone-50 dark:autofill:bg-stone-800 autofill:text-black dark:autofill:text-stone-100 autofill:border-stone-300 dark:autofill:border-yellow-500 autofill:shadow-[inset_0_0_0px_1000px_rgb(250,250,249)] dark:autofill:shadow-[inset_0_0_0px_1000px_rgb(41,37,36)] autofill:[-webkit-text-fill-color:rgb(28,25,23)] dark:autofill:[-webkit-text-fill-color:rgb(245,245,244)]"
        LABEL_CLASSES = "block text-sm font-medium text-black dark:text-stone-100 mb-2"
        BUTTON_CLASSES = "bg-black dark:bg-stone-100 text-white dark:text-stone-900 px-4 py-2 rounded text-sm font-medium hover:bg-stone-800 dark:hover:bg-stone-200 cursor-pointer"
        ERROR_CLASSES = "text-red-600 dark:text-red-400 text-sm mt-1"
        CHECKBOX_CLASSES = "w-4 h-4 accent-stone-900 dark:accent-stone-100 focus:ring-stone-500 dark:focus:ring-stone-400 border-stone-300 dark:border-stone-600 bg-white dark:bg-stone-800"

        def app_form_for(model, url:, method: :post, **options, &block)
          form_options = {
            action: url,
            method: method == :get ? "get" : "post",
            class: options[:class]
          }.compact

          # Resolve the model if it's a symbol (exposed value name)
          resolved_model = if model.is_a?(Symbol)
            if respond_to?(model)
              public_send(model)
            else
              model
            end
          else
            model
          end

          form_html = tag.form(**form_options) do
            csrf_html = method != :get ? tag.input(name: "_csrf_token", value: csrf_token, type: "hidden") : ""
            method_html = method_override_field(method) if [:put, :patch, :delete].include?(method)

            builder = FormBuilder.new(resolved_model, self)
            # Can't use capture here directly because of Hanami's tag helpers
            # capture { block.call(builder) }
            form_content = block.call(builder)

            safe_join([csrf_html, method_html, form_content].compact)
          end

          form_html
        end

        private

        def method_override_field(method)
          tag.input(name: "_method", value: method.to_s, type: "hidden") if [:put, :patch, :delete].include?(method)
        end

        def safe_join(array)
          array.join.html_safe
        end

        class FormBuilder
          attr_reader :model, :template

          def initialize(model, template)
            @model = model
            @template = template
          end

          def hidden_field_tag(name, value, options = {})
            template.tag.input(
              type: "hidden",
              name: name,
              value: value,
              **options
            )
          end

          def text_field(method, options = {})
            add_default_classes(options, FormHelper::INPUT_CLASSES)
            value = get_value(method)

            template.tag.input(
              type: "text",
              name: field_name(method),
              id: field_id(method),
              value: value,
              **options
            )
          end

          def email_field(method, options = {})
            add_default_classes(options, FormHelper::INPUT_CLASSES)
            value = get_value(method)

            template.tag.input(
              type: "email",
              name: field_name(method),
              id: field_id(method),
              value: value,
              **options
            )
          end

          def password_field(method, options = {})
            add_default_classes(options, FormHelper::INPUT_CLASSES)

            template.tag.input(
              type: "password",
              name: field_name(method),
              id: field_id(method),
              **options
            )
          end

          def text_area(method, options = {})
            add_default_classes(options, FormHelper::INPUT_CLASSES)
            value = get_value(method)

            template.tag.textarea(
              value || "",
              name: field_name(method),
              id: field_id(method),
              **options
            )
          end

          def select(method, choices, options = {}, html_options = {})
            add_default_classes(html_options, FormHelper::INPUT_CLASSES)
            value = get_value(method)

            option_tags = choices.map do |choice|
              if choice.is_a?(Array)
                text, val = choice
                selected = val.to_s == value.to_s
                template.tag.option(text, value: val, selected: selected)
              else
                selected = choice.to_s == value.to_s
                template.tag.option(choice, value: choice, selected: selected)
              end
            end.join

            template.tag.select(
              option_tags.html_safe,
              name: field_name(method),
              id: field_id(method),
              **html_options
            )
          end

          def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
            add_default_classes(options, FormHelper::CHECKBOX_CLASSES)
            value = get_value(method)
            checked = [true, "true", "1", 1, checked_value].include?(value)

            hidden = template.tag.input(type: "hidden", name: field_name(method), value: unchecked_value)
            checkbox = template.tag.input(
              type: "checkbox",
              name: field_name(method),
              id: field_id(method),
              value: checked_value,
              checked: checked,
              **options
            )

            (hidden + checkbox).html_safe
          end

          def radio_button(method, tag_value, options = {})
            value = get_value(method)
            checked = value.to_s == tag_value.to_s

            template.tag.input(
              type: "radio",
              name: field_name(method),
              id: "#{field_id(method)}_#{tag_value}",
              value: tag_value,
              checked: checked,
              **options
            )
          end

          def label(method, text = nil, options = {})
            add_default_classes(options, FormHelper::LABEL_CLASSES)
            label_text = text || method.to_s.split("_").map(&:capitalize).join(" ")

            template.tag.label(
              label_text,
              for: field_id(method),
              **options
            )
          end

          def submit(value = "Submit", options = {})
            add_default_classes(options, FormHelper::BUTTON_CLASSES)

            template.tag.input(
              type: "submit",
              value: value,
              **options
            )
          end

          def field_with_label(method, field_type = :text_field, options = {})
            field_options = options.except(:label, :wrapper_class, :error, :choices, :select_options)
            label_text = options[:label] || method.to_s.split("_").map(&:capitalize).join(" ")
            wrapper_class = options[:wrapper_class] || ""

            template.tag.div(class: wrapper_class) do
              label_html = label(method, label_text)

              field_html = case field_type
              when :text_area
                text_area(method, field_options)
              when :email_field
                email_field(method, field_options)
              when :password_field
                password_field(method, field_options)
              when :select
                select(method, options[:choices] || [], options[:select_options] || {}, field_options)
              else
                text_field(method, field_options)
              end

              error_html = field_error(method)

              (label_html + field_html + error_html).html_safe
            end
          end

          def radio_button_group(method, options = {})
            label_text = options[:label] || method.to_s.split("_").map(&:capitalize).join(" ")
            radio_options = options[:options] || []
            wrapper_class = options[:wrapper_class] || ""

            template.tag.div(class: wrapper_class) do
              label_html = template.tag.h3(label_text, class: "text-sm font-medium text-primary mb-3")

              radio_html = template.tag.div(class: "space-y-3") do
                radio_options.map do |value, title, description|
                  template.tag.label(class: "flex items-start gap-3") do
                    radio_button_html = radio_button(
                      method,
                      value,
                      class: "mt-1 w-4 h-4 accent-stone-900 dark:accent-stone-100 focus:ring-stone-500 dark:focus:ring-stone-400 border-stone-300 dark:border-stone-600 bg-white dark:bg-stone-800"
                    )

                    content_html = template.tag.div do
                      title_html = template.tag.div(title, class: "text-sm font-medium text-primary")
                      desc_html = description ? template.tag.div(description, class: "text-xs text-secondary") : ""
                      (title_html + desc_html).html_safe
                    end

                    (radio_button_html + content_html).html_safe
                  end
                end.join.html_safe
              end

              error_html = field_error(method)

              (label_html + radio_html + error_html).html_safe
            end
          end

          private

          def field_name(method)
            if model_name
              "#{model_name}[#{method}]"
            else
              method.to_s
            end
          end

          def field_id(method)
            if model_name
              "#{model_name}_#{method}"
            else
              method.to_s
            end
          end

          def model_name
            @model_name ||= if @model.is_a?(String)
              @model
            elsif @model.is_a?(Symbol)
              @model.to_s
            elsif @model.class.respond_to?(:model_name)
              @model.class.model_name.param_key
            elsif @model.class.name
              # Handle ROM::Struct, Dry::Struct, or regular classes
              class_name = @model.class.name.split("::").last
              class_name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
            else
              nil
            end
          end

          def get_value(method)
            return nil unless @model
            return nil if @model.is_a?(String) || @model.is_a?(Symbol)

            method_sym = method.to_sym
            method_str = method.to_s

            if @model.respond_to?(method_sym)
              @model.public_send(method_sym)
            elsif @model.respond_to?(method_str)
              @model.public_send(method_str)
            elsif @model.respond_to?(:[])
              # Try symbol first, then string
              @model[method_sym] || @model[method_str]
            end
          end

          def field_error(method)
            return "" unless @model && @model.respond_to?(:errors)

            method_sym = method.to_sym
            method_str = method.to_s

            errors = if @model.errors.respond_to?(:[])
              # Try symbol first, then string
              @model.errors[method_sym] || @model.errors[method_str]
            elsif @model.errors.respond_to?(:on)
              @model.errors.on(method_sym) || @model.errors.on(method_str)
            end

            if errors && !errors.empty?
              error_message = errors.is_a?(Array) ? errors.first : errors
              template.tag.div(error_message, class: FormHelper::ERROR_CLASSES)
            else
              ""
            end
          end

          def add_default_classes(options, default_classes)
            if options[:class] && !options[:class].empty?
              options[:class] = "#{default_classes} #{options[:class]}"
            else
              options[:class] = default_classes
            end
          end
        end
      end
    end
  end
end
