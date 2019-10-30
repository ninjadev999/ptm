module SocialShareButtonHelper
  def social_open_button_tag(title = "", opts = {})
      opts[:allow_sites] ||= SocialShareButton.config.allow_sites
      extra_data = {}
      rel = opts[:rel]
      html = []
      html << "<div class='social-share-button' data-title='#{h title}' data-img='#{opts[:image]}'"
      html << "data-url='#{opts[:social_url]}' data-desc='#{opts[:desc]}' data-via='#{opts[:via]}'>"

      opts[:allow_sites].each do |name|
        extra_data = opts.select { |k, _| k.to_s.start_with?('data') } if name.eql?('tumblr')
        special_data = opts.select { |k, _| k.to_s.start_with?('data-' + name) }

        special_data["data-wechat-footer"] = t "social_share_button.wechat_footer" if name == "wechat"

        link_title = t "social_share_button.share_to", :name => t("social_share_button.#{name.downcase}")
        html << link_to("", opts[:social_url], { :rel => ["nofollow", rel],
                                   "data-site" => name,
                                   "data-url" => opts[:social_url],
                                   :class => "ssb-icon ssb-#{name}",
                                   :onclick => "return SocialShareButton.openProfile(this);",
                                   :title => h(link_title) }.merge(extra_data).merge(special_data))
      end
      html << "</div>"
      raw html.join("\n")
  end

  def social_image_url(social_name)
    social_site = SocialSite.where(name: social_name).first
    social_site.nil? ? '' : social_site.image_url
  end
end