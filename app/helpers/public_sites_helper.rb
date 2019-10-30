module PublicSitesHelper
  def all_public_sites
    @public_sites = PublicSite.all.order(:name)
  end
end
