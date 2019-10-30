# frozen_string_literal: true

class ProfilesController < BaseController
  autocomplete(:promotion, :name, class_name: 'ActsAsTaggableOn::Tag', scopes: 'promotions')
  autocomplete(:topic, :name, class_name: 'ActsAsTaggableOn::Tag', scopes: 'topics')
  autocomplete(:expertise, :name, class_name: 'ActsAsTaggableOn::Tag', scopes: 'expertises')
  autocomplete(:profile, :primary_industry)

  respond_to :json

  def json_for_autocomplete(items, method, extra_data=[])
    seeds = case action_name.to_sym
    when :autocomplete_profile_primary_expertise
      EXPERTISES.select { |e| e.downcase.starts_with? params[:term].downcase }
    when :autocomplete_promotion_name
      PROMOTIONS.select { |e| e.downcase.starts_with? params[:term].downcase }
    when :autocomplete_topic_name
      []
    else
      []
    end

    items = items.map { |item| item.send(method) }
    items = seeds.concat(items).uniq.first(5)
    items = items.map do |item|
      HashWithIndifferentAccess.new({"label" => item, "value" => item})
    end
  end

  def show
  end

  def update
    if current_user.profile.present?
      if current_user.profile.update_attributes(profile_params)
        redirect_to preferences_settings_path if profile_params[:profile_social_sites_attributes].present?
      end
    end
  end

  def destroy
    if current_user.destroy
      redirect_to preferences_settings_path, notice: 'Profile has been removed.'
    end
  end

  def delete
    desctroy
  end

  private

  def profile_params
    params.require(:profile).permit(profile_social_sites_attributes: [:id, :url, :social_site_id, :_destroy])
  end
end
