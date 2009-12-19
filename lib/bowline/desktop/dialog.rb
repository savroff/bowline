module Bowline
  module Desktop
    module Dialog
      def message(msg, options = {})
        style = 0
        style |= YES_NO if options[:yes_no]
        style |= OK     if options[:ok]
        style |= CANCEL if options[:cancel]
        style |= ICON_EXCLAMATION if options[:icon_exclamation]
        style |= ICON_HAND   if options[:icon_hand]
        style |= ICON_ERROR  if options[:icon_error]
        style |= QUESTION    if options[:question]
        style |= INFORMATION if options[:information]
        caption = options[:caption] || "Message"
        
        result = _message(msg, caption, style)
        
        case result
        when YES then :yes
        when NO  then :no
        when OK  then :ok
        when CANCEL then :cancel
        end
      end
      module_function :message
    end
  end
end