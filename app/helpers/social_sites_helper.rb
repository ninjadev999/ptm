module SocialSitesHelper
  def all_social_sites
    @social_sites = SocialSite.all.order(:name)
  end
end
