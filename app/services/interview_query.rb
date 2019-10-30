class InterviewQuery
  attr_accessor :user, :account, :filter_params
  delegate :host?, :guest?, to: :user

  def initialize(user, account=nil, filter_params={})
    @user = user
    @account = account
    @filter_params = filter_params
  end

  def search
    if all_filter_null?
      solicited_search? ? Interview.solicited.order(:created_at) : Interview.posting.order(:created_at)
    else
      Interview.search_for(definition).records
    end
  end

  def definition
    query =
    {
      query: {
        bool: {
          must_not: [],
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
          ],
          "minimum_should_match": 1
        }
      }
    }

    must_not = query[:query][:bool][:must_not]
    must_not_ids = solicited_search? ? @account.members.pluck(:interview_id) : @user.guest_members.pluck(:interview_id)
    must_not << { terms: { _id: must_not_ids } } if must_not_ids.present?

    filters = query[:query][:bool][:filter]
    filters <<
      {
        match: { type: solicited_search? ? 'SolicitedInterview' : 'HostInterview' }
      }
    query
  end

  private

    def topic_list
      return filter_params[:topic_list].reject(&:blank?) if filter?
      guest? ? user.topic_list : account.most_topics.map(&:name)
    end

    def promotion_list
      return filter_params[:promotion_list].reject(&:blank?) if filter?
      guest? ? user.promotion_list : account.most_promotions.map(&:name)
    end

    def expertise_list
      return filter_params[:expertise_list].reject(&:blank?) if filter?
      guest? ? user.expertise_list : account.most_expertises.map(&:name)
    end

    def filter?
      filter_params.is_a? ActionController::Parameters
    end

    def all_filter_null?
      topic_list.blank? && promotion_list.blank? && expertise_list.blank?
    end

    def solicited_search?
      account.present?
    end
end