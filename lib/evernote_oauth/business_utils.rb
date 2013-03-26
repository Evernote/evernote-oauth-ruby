module EvernoteOAuth

  module BusinessUtils
    include ::EvernoteOAuth::UserStore
    include ::EvernoteOAuth::NoteStore
    include ::EvernoteOAuth::SharedNoteStore
    include ::EvernoteOAuth::BusinessNoteStore

    # Creates a note in the given business notebook.
    #
    # @param note [Evernote::EDAM::Type::Note] See {http://dev.evernote.com/documentation/reference/Types.html#Struct_Note}.
    # @param business_notebook [Evernote::EDAM::Type::LinkedNotebook] A LinkedNotebook object corresponding to the business notebook. See {http://dev.evernote.com/documentation/reference/Types.html#Struct_LinkedNotebook}.
    # @return [Evernote::EDAM::Type::Note] The newly created Note from the service. The server-side GUIDs for the Note and any Resources will be saved in this object.
    def create_note_in_business_notebook(note, business_notebook)
      shared_notebook = shared_note_store(business_notebook).getSharedNotebookByAuth
      note.notebookGuid = shared_notebook.notebookGuid
      shared_note_store(business_notebook).createNote(note)
    end

    # Lists all business notebooks the user can access.
    #
    # @return [Array<Evernote::EDAM::Type::LinkedNotebook>] The list of LinkedNotebook. See {http://dev.evernote.com/documentation/reference/Types.html#Struct_LinkedNotebook}.
    def list_business_notebooks
      note_store.listLinkedNotebooks.select(&:businessId)
    end

    # Creates a business notebook in the business account and LinkedNotebook for the user.
    #
    # @param notebook [Evernote::EDAM::Type::Notebook] See {http://dev.evernote.com/documentation/reference/Types.html#Struct_Notebook}.
    # @return [Evernote::EDAM::Type::LinkedNotebook] The LinkedNotebook corresponding to the notebook in the business account. See {http://dev.evernote.com/documentation/reference/Types.html#Struct_LinkedNotebook}.
    def create_business_notebook(notebook)
      business_notebook = business_note_store.createNotebook(notebook)
      shared_notebook = business_notebook.sharedNotebooks.first
      business_user = business_note_store.user
      linked_notebook = Evernote::EDAM::Type::LinkedNotebook.new(
        shareKey: shared_notebook.shareKey,
        shareName: business_notebook.name,
        username: business_user.username,
        shardId: business_user.shardId
      )
      note_store.createLinkedNotebook(linked_notebook)
    end

    # Get a notebook object corresponding to the given business notebook.
    #
    # @param business_notebook [Evernote::EDAM::Type::LinkedNotebook] A LinkedNotebook object. See {http://dev.evernote.com/documentation/reference/Types.html#Struct_LinkedNotebook}.
    # @return [Evernote::EDAM::Type::Notebook] A Notebook object corresponding to the given LinkedNotebook.
    def get_corresponding_notebook(business_notebook)
      shared_notebook = shared_note_store(business_notebook).getSharedNotebookByAuth
      business_note_store.getNotebook(shared_notebook.notebookGuid)
    end

  end

end
