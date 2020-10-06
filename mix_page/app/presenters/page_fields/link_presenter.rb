module PageFields
  class LinkPresenter < TextPresenter
    def dom_class
      super.push "link_#{object.view&.full_underscore}"
    end

    def html(**options)
      options = options ? options.dup : {}
      title = text.presence || pretty_blank
      a_(href: url, class: [('pjax' if url), options.delete(:class)], title: title, **options) {[
        pretty_actions(:span),
        title,
      ]}
    end

    def url
      return @url if defined? @url
      @url = object.to_url
    end
  end
end