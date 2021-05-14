module ApplicationHelper

    module BootstrapExtension
        FORM_LABEL_CLASS = 'form-label'
        FORM_CONTROL_CLASS = 'form-control'
        FORM_SELECT_CLASS = 'form-select'
    
        # Override the 'label' method defined in FormHelper
        #
        # https://github.com/rails/rails/blob/main/actionview/lib/action_view/helpers/form_helper.rb
        def label(object_name, method, content_or_options = nil, options = nil, &block)
            class_name = options[:class]
            if class_name.nil?
                options[:class] = FORM_LABEL_CLASS
            else
                options[:class] << " #{FORM_LABEL_CLASS}" if " #{class_name} ".index(" #{FORM_LABEL_CLASS} ").nil?
            end

            super
        end

        def text_field(object_name, method, options = {})
            class_name = options[:class]
            if class_name.nil?
                options[:class] = FORM_CONTROL_CLASS
            else
                options[:class] << " #{FORM_CONTROL_CLASS}" if " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
            end

            super
        end

        def date_field(object_name, method, options = {})
            class_name = options[:class]
            if class_name.nil?
                options[:class] = FORM_CONTROL_CLASS
            else
                options[:class] << " #{FORM_CONTROL_CLASS}" if " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
            end

            super
        end

        def select(object, method, choices = nil, options = {}, html_options = {}, &block)
            class_name = html_options[:class]
            if class_name.nil?
                html_options[:class] = FORM_SELECT_CLASS
            else
                html_options[:class] << " #{FORM_SELECT_CLASS}" if " #{class_name} ".index(" #{FORM_SELECT_CLASS} ").nil?
            end

            super
        end

        def dismiss_modal_tag
            button_tag '', type: 'button', class: 'btn-close', data: { bs_dismiss: 'modal' }, aria: { label: 'Close' }
        end
    end
    
    # Add the modified method to ApplicationHelper
    include BootstrapExtension

end
