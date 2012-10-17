module EvernoteOAuth

  module ThriftClientDelegation
    def method_missing(name, *args, &block)
      method = @client.class.instance_method(name)
      parameters = method.parameters
      if parameters.size != args.size &&
	idx_token = parameters.index{|e| e.last == :authenticationToken}
	new_args = args.dup.insert(idx_token, @token)
	begin
	  @client.send(name, *new_args, &block)
	rescue ArgumentError => e
	  puts e.inspect
	  @client.send(name, *args, &block)
	end
      else
	@client.send(name, *args, &block)
      end
    end
  end

end
