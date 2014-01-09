require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "EvernoteOAuth::BusinessUtils" do
  include EvernoteOAuth::BusinessUtils

  context "#create_note_in_business_notebook" do
    it "calls createNote with shared_note_store" do
      note = Evernote::EDAM::Type::Note.new
      business_notebook = Evernote::EDAM::Type::LinkedNotebook.new
      shared_notebook = Evernote::EDAM::Type::SharedNotebook.new(notebookGuid: 'notebook_guid')
      shared_note_store = double(Object)
      shared_note_store.stub(:getSharedNotebookByAuth).and_return(shared_notebook)
      shared_note_store.stub(:createNote).and_return(note)
      should_receive(:shared_note_store).with(business_notebook).twice.and_return(shared_note_store)
      create_note_in_business_notebook(note, business_notebook).should == note
    end
  end

  context "#list_business_notebooks" do
    it "calls listLinkedNotebooks with note_store" do
      ln1 = Evernote::EDAM::Type::LinkedNotebook.new(businessId: 'Evernote')
      ln2 = Evernote::EDAM::Type::LinkedNotebook.new
      ln3 = Evernote::EDAM::Type::LinkedNotebook.new(businessId: 'Evernote')
      note_store = double(Object)
      note_store.stub(:listLinkedNotebooks).and_return([ln1, ln2, ln3])
      should_receive(:note_store).and_return(note_store)
      list_business_notebooks.should == [ln1, ln3]
    end
  end

  context "#create_business_notebook" do
    it "calls createNote with shared_note_store" do
      notebook = Evernote::EDAM::Type::Notebook.new
      shared_notebook = Evernote::EDAM::Type::SharedNotebook.new(
        shareKey: 'shareKey'
      )
      business_notebook = Evernote::EDAM::Type::Notebook.new(
        name: 'name',
        sharedNotebooks: [shared_notebook]
      )
      business_note_store = double(Object)
      business_note_store.stub(:createNotebook).with(notebook).and_return(business_notebook)
      should_receive(:business_note_store).twice.and_return(business_note_store)

      business_user = Evernote::EDAM::Type::User.new(
        username: 'username',
        shardId: 'shardId'
      )
      business_note_store.stub(:user).and_return(business_user)

      note_store = double(Object)
      note_store.should_receive(:createLinkedNotebook).with(
        Evernote::EDAM::Type::LinkedNotebook.new(
          shareKey: 'shareKey',
          shareName: 'name',
          username: 'username',
          shardId: 'shardId'
        )
      )
      should_receive(:note_store).and_return(note_store)

      create_business_notebook(notebook)
    end
  end

  context "#get_corresponding_notebook" do
    it "calls getNotebookWithGuid with business_note_store" do
      business_notebook = Evernote::EDAM::Type::LinkedNotebook.new
      shared_notebook = Evernote::EDAM::Type::SharedNotebook.new(notebookGuid: 'notebook_guid')
      shared_note_store = double(Object)
      shared_note_store.stub(:getSharedNotebookByAuth).and_return(shared_notebook)
      should_receive(:shared_note_store).with(business_notebook).and_return(shared_note_store)

      business_note_store = double(Object)
      business_note_store.should_receive(:getNotebook).with('notebook_guid')
      should_receive(:business_note_store).and_return(business_note_store)

      get_corresponding_notebook(business_notebook)
    end
  end

end
