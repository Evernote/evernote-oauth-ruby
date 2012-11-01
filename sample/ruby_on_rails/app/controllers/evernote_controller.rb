class EvernoteController < ApplicationController

  DOC_URL_BASE = 'http://dev.evernote.com/documentation/reference'

  def call
    begin
      send(params[:method])
    rescue NoMethodError => e
      redirect_to root_path and return
    end

    @result = (run_code? && @code ? eval(@code) : 'N/A') rescue $!
    @code ||= 'N/A'
    @doc = doc

    render 'home/api_result'
  end

  private
  # Scrape Evernote API reference
  def doc(clazz=controller_name.classify, method=params[:method])
    doc_id = "Fn_#{clazz}_#{method}"
    doc_page = "#{DOC_URL_BASE}/#{clazz}.html"
    @doc_url = "#{doc_page}##{doc_id}"

    doc = Nokogiri::HTML(open(@doc_url)).css('div.definition').select{|n|
      n.child.attributes['id'].value == doc_id
    }.first
    doc.xpath('.//a').each do |el|
      href = el.attributes['href'].value
      el.attributes['href'].value = "#{DOC_URL_BASE}/#{href}" unless href.start_with?('http')
    end
    doc.to_s.html_safe
  end

  def run_code?
    !session[:dry_run]
  end

end
