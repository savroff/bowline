module Bowline
  module Binders
    class Base
      extend Bowline::Watcher::Base
      extend Bowline::Desktop::Bridge::ClassMethods
      js_expose
      
      class << self
        def setup
          self.items = all
          true
        end
        
        def instance_invoke(id, meth, *args) #:nodoc:
          self.new(id).send(meth, *args)
        end
        
        def find(id)
          klass.find(id)
        end
        
        def all
          klass.all
        end
        
        def items=(items)
          bowline.populate(name, items.to_js).call
        end
        
        def created(item)
          bowline.created(
            name, 
            item.id, 
            item.to_js
          ).call
        end
        
        def updated(item)
          bowline.updated(
            name, 
            item.id, 
            item.to_js
          ).call
        end
        
        def removed(item)
          bowline.removed(
            name, 
            item.id
          ).call
        end
        
        protected
          # klass needs to respond to:
          #  * all
          #  * find(id)
          #  * after_create(method)
          #  * after_update(method)
          #  * after_destroy(method)
          #
          # klass instance needs to respond to:
          #   * id
          #   * to_js
          def expose(klass)
            @klass = klass
            @klass.after_create(method(:created))
            @klass.after_update(method(:updated))
            @klass.after_destroy(method(:removed))
          end
          
          def klass
            @klass || raise("klass not set - see expose method")
          end
          
          # See Bowline::page
          def page
            Bowline::page
          end
          
          def bowline
            Bowline::bowline
          end
      
          # Equivalent of the 'jQuery' function
          def jquery
            JQuery.new
          end
        
          # See Bowline::logger
          def logger
            Bowline::logger
          end
        
          def trigger(event, data = nil)
            bowline.trigger(
              name,
              format_event(event), 
              data
            ).call
          end
        
          def loading(&block)
            trigger(:loading, true)
            yield
            trigger(:loading, false)
          end
        
          def format_event(name) #:nodoc:
            name.is_a?(Array) ? 
              name.join('.') : 
                name.to_s
          end
      end
    
      attr_reader :element
      attr_reader :item
    
      def initialize(id, *args) #:nodoc:
        @element = JQuery.for_id(id)
        @item    = self.class.find(id)
      end
      
      protected
        # Trigger jQuery events on this element
        def trigger(event, data = nil)
          element.trigger(
            self.class.format_event(event), 
            data
          ).call
        end
        
        def remove!
          self.class.removed(item)
        end
    
        # Shortcut methods
    
        # See self.class.js
        def page
          self.class.page
        end
    
        # See self.class.jquery
        def jquery
          self.class.jquery
        end
      
        # See self.class.logger
        def logger
          self.class.logger
        end
    end
  end
end