module Evernote
  module EDAM
    module Type
      class Note
        def notebook
          @notebook ||= note_store.getNotebook(notebookGuid)
	end

	def tags
	  @tags ||= (tagGuids || []).map{|guid| note_store.getTag(guid)}
	end

        def add_resource(filename, image, mime)
          hash_func = Digest::MD5.new

          data = Evernote::EDAM::Type::Data.new
          data.size = image.size
          data.bodyHash = hash_func.digest(image)
          data.body = image

          resource = Evernote::EDAM::Type::Resource.new
          resource.mime = mime
          resource.data = data
          resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
          resource.attributes.fileName = filename

          self.resources = [] unless self.resources
          self.resources << resource

          hash_func.hexdigest(image)
        end
      end
    end
  end
end
