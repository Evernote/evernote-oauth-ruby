module ApplicationHelper

  # These methods are not available to third party applications
  UNAVAILABLE_METHODS = [:authenticate, :authenticateLongSession, :refreshAuthentication, :emailNote, :expungeInactiveNotes,
    :expungeLinkedNotebook, :expungeNote, :expungeNotebook, :expungeNotes, :expungeSearch,
    :expungeSharedNotebooks, :expungeTag, :getAccountSize, :getAds, :getRandomAd]

  def link_to_user_store(method_name)
    link_to link_body(method_name), user_store_path(method: method_name),
      :id => "user_store_#{method_name}"
  end

  def link_to_note_store(method_name)
    link_to link_body(method_name), note_store_path(method: method_name),
      :id => "note_store_#{method_name}"
  end

  def link_to_advanced(method_name)
    link_to method_name.to_s.titleize, advanced_path(method: method_name),
      :id => "advanced_#{method_name}"
  end

  private
  # Show the 'unavailable' label
  def link_body(method_name)
    "#{('[UNAVAILABLE] ' if UNAVAILABLE_METHODS.include?(method_name))}#{method_name}"
  end

end
