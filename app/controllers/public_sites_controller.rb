class PublicSitesController < InheritedResources::Base

  private

    def public_site_params
      params.require(:public_site).permit(:name, :image_url)
    end
end

