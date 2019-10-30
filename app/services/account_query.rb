class AccountQuery

  attr_accessor :interview, :filter_params

  delegate :posting?, to: :interview

  def initialize(interview, filter_params={})
    @interview = interview
    @filter_params = filter_params
  end

  def search
    if all_filter_null?
      Account.all.order(:name)
    else
      Account.search_for(definition).records
    end
  end

  def definition
    query = 
    {
      query: {
        bool: {
          must_not: [
            {
              terms: { _id: @interview.members.pluck(:account_id) }
            }
          ],
          "should": [
            {
              "terms_set": {
                "most_topics": {
                    "terms": topic_list || [],
                    "minimum_should_match_script": {
                       "source": "Math.min(params.num_terms, 1)"
                    }
                }
              }
            },
            {
              "terms_set": {
                "most_promotions": {
                    "terms": promotion_list || [],
                    "minimum_should_match_script": {
                       "source": "Math.min(params.num_terms, 1)"
                    }
                }
              }
            },
            {
              "terms_set": {
                "most_expertises": {
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

    query
  end

  private

    def topic_list
      return filter_params[:topic_list].reject(&:blank?) if filter?
      @interview.topic_list
    end

    def promotion_list
      return filter_params[:promotion_list].reject(&:blank?) if filter?
      @interview.promotion_list
    end

    def expertise_list
      return filter_params[:expertise_list].reject(&:blank?) if filter?
      @interview.expertise_list
    end

    def filter?
      filter_params.is_a? ActionController::Parameters
    end

    def all_filter_null?
      topic_list.blank? && promotion_list.blank? && expertise_list.blank?
    end
end