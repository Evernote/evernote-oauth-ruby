module Evernote
  module EDAM
    module Type
      class User

        # Determines if this user is a part of a business
        #
        # @return [Boolean]
        def belongs_to_business?
          self.accounting.businessId != nil
        end

        # Returns the business name
        #
        # @return [String]
        def business_name
          self.accounting.businessName
        end

      end
    end
  end
end
