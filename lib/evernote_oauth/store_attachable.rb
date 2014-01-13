module EvernoteOAuth
  module StoreAttachable
    def attach_user_store(*field_symbols)
      attach_store('user', *field_symbols)
    end

    def attach_note_store(*field_symbols)
      attach_store('note', *field_symbols)
    end

    def attach_store(type, *field_symbols)
      field_symbols.each do |fs|
        define_method(fs) do
          original = "@#{fs}".to_sym
          target = "@#{fs}_with_#{type}_stores".to_sym
          with_stores = (
            instance_variable_get(target) ||
            begin
              store_name = "#{type}_store"
              if respond_to?(store_name.to_sym)
                store = eval(store_name)
                [instance_variable_get(original)].flatten.each{|n|
                  n.define_singleton_method(store_name.to_sym){store}
                }
              end
              instance_variable_get(original)
            end
          )
          instance_variable_set(target, with_stores)
        end
      end
    end
  end
end
