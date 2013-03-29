module Evernote
  module EDAM
    module Type
      class Note

        # Returns the notebook that contains this note.
        #
        # @return [Evernote::EDAM::Type::Notebook]
        def notebook
          @notebook ||= note_store.getNotebook(notebookGuid)
        end

        # Returns the tags that are applied to this note.
        #
        # @return [Array<Evernote::EDAM::Type::Tag>]
        def tags
          @tags ||= (tagGuids || []).map{|guid| note_store.getTag(guid)}
        end

        # Add resource to this note.
        #
        # @param filename [String] the name of the resource
        # @param file [File]
        # @param mime [String] MIME type of the resource
        #
        # @return [String] Hexdigest of the given file
        def add_resource(filename, file, mime)
          hash_func = Digest::MD5.new

          data = Evernote::EDAM::Type::Data.new
          data.size = file.size
          data.bodyHash = hash_func.digest(file)
          data.body = file

          resource = Evernote::EDAM::Type::Resource.new
          resource.mime = mime
          resource.data = data
          resource.attributes = Evernote::EDAM::Type::ResourceAttributes.new
          resource.attributes.fileName = filename

          self.resources = [] unless self.resources
          self.resources << resource

          hash_func.hexdigest(file)
        end
      end
    end
  end
end
