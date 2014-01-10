require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "EvernoteOAuth::StoreAttachable" do

  context "#attach_user_store" do
    it "assigns user_store to a field" do
      class MyObject
        extend EvernoteOAuth::StoreAttachable
        attr_accessor :dummy_field
        attach_user_store :dummy_field
      end
      object = MyObject.new
      object.define_singleton_method(:user_store) do
        :dummy_user_store
      end
      object.dummy_field = Object.new

      object.dummy_field.user_store.should == object.user_store
    end
  end

  context "#attach_note_store" do
    it "assigns note_store to a field" do
      class MyObject
        extend EvernoteOAuth::StoreAttachable
        attr_accessor :dummy_field
        attach_note_store :dummy_field
      end
      object = MyObject.new
      object.define_singleton_method(:note_store) do
        :dummy_note_store
      end
      object.dummy_field = Object.new

      object.dummy_field.note_store.should == object.note_store
    end
  end

end
