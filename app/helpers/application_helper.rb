module ApplicationHelper

    module BootstrapExtension
        def dismiss_modal_tag
            button_tag '', type: 'button', class: 'btn-close', data: { bs_dismiss: 'modal' }, aria: { label: 'Close' }
        end
    end
    
    # Add the modified method to ApplicationHelper
    include BootstrapExtension

end
