module EvernoteOAuth

  module ThriftClientDelegation
    def method_missing(name, *args, &block)
      method = @client.class.instance_method(name)
      parameters = method.parameters
      if parameters.size != args.size &&
        idx_token = parameters.index{|e| e.last == :authenticationToken}
        new_args = args.dup.insert(idx_token, @token)
        begin
          result = @client.send(name, *new_args, &block)
        rescue ArgumentError => e
          result = @client.send(name, *args, &block)
        end
      else
        result = @client.send(name, *args, &block)
      end

      attr_value = self
      [result].flatten.each{|r|
        begin
          r.define_singleton_method(attr_name){attr_value}
        rescue TypeError # Fixnum/TrueClass/FalseClass/NilClass
          next
        end
      }
      result
    end

    private
    def attr_name
      name = underscore(self.class.name.gsub(/::Store$/, '').split('::').last)
      if name.end_with?('user_store')
        :user_store
      elsif name.end_with?('note_store')
        :note_store
      else
        raise "Unsupported type: #{self.class.name}"
      end
    end

    def underscore(word)
      word.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end

end
