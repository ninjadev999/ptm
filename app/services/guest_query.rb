class GuestQuery

  attr_accessor :interview, :filter_params

  delegate :posting?, to: :interview

  def initialize(interview, filter_params={})
    @interview = interview
    @filter_params = filter_params
  end

  ###
  # @usage Completed interview page - all matching guests
  #        Interview type B : creation process - plus/pro guests
  #        Interview type B : Search PTM guest - plus/pro guests, with search filter
  #
  def search
    if all_filter_null?
      User.all.order(:first_name, :last_name).where.not('users.id IN (?)', already_invited_user_ids)
    else
      User.search_for(definition).records
    end
  end

  def definition
    query = 
    {
      query: {
        bool: {
          must: [
            {
              match: { guest: true }
            }
          ],
          must_not: [
            {
              terms: { _id: already_invited_user_ids }
            }
          ],
          filter: [],
          "should": [
            {
              "terms_set": {
                "topic_list": {
                    "terms": topic_list || [],
                    "minimum_should_match_script": {
                       "source": "Math.min(params.num_terms, 1)"
                    }
                }
              }
            },
            {
              "terms_set": {
                "promotion_list": {
                    "terms": promotion_list || [],
                    "minimum_should_match_script": {
                       "source": "Math.min(params.num_terms, 1)"
                    }
                }
              }
            },
            {
              "terms_set": {
                "expertise_list": {
                    "terms": expertise_list || [],
                    "minimum_should_match_script": {
                       "source": "Math.min(params.num_terms, 1)"
                    }
                }
              }
            }
            # ,
            # {
            #   "terms": { "primary_expertise": expertise_list || [] }
            # }
          ],
          "minimum_should_match": 1
        }
      }
    }

    filters = query[:query][:bool][:filter]
    unless interview.ended?
      filters <<
      {
        terms: { subscription_level: [:basic, :pro] }
      }
    end

    query
  end

  private

    def topic_list
      return filter_params[:topic_list].reject(&:blank?) if filter?
      posting? ? @interview.topic_list : guests.map(&:topic_list).flatten.compact
    end

    def promotion_list
      return filter_params[:promotion_list].reject(&:blank?) if filter?
      posting? ? @interview.promotion_list : guests.map(&:promotion_list).flatten.compact
    end

    def expertise_list
      return filter_params[:expertise_list].reject(&:blank?) if filter?
      posting? ? @interview.expertise_list : guests.map(&:expertise_list).flatten.compact
    end

    def guests
      @interview.invited_guests
    end

    def filter?
      filter_params.is_a? ActionController::Parameters
    end

    def all_filter_null?
      topic_list.blank? && promotion_list.blank? && expertise_list.blank?
    end

    def already_invited_user_ids
      @interview.members.pluck(:guest_id)
    end
end