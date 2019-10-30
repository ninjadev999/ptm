class SocialSitesController < InheritedResources::Base

  private

    def social_site_params
      params.require(:social_site).permit(:name, :image_url)
    end
end

