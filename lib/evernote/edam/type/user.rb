module Evernote
  module EDAM
    module Type
      class User
        def belongs_to_business?
          self.accounting.businessId != nil
        end
        def business_name
          self.accounting.businessName
        end
      end
    end
  end
end
