module ActionView
  
  module Helpers
    
    module ProtoTypeHelper
      
      class JavascriptGenerator
        
        module GeneratorMethods
          
          def replace_html(id, *options_for_render)
            record "$(#{id}).set({html: '#{escape_javascript(render *options_for_render)}'})"
          end
          
          def record(line)
            line = "#{line.to_s.chomp.gsub(/\;\z/, '')};"
            line
          end
            
        end
        
      end
      
    end
    
  end
  
end