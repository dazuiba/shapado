class WelcomeController < ApplicationController
  helper :questions
  tabs :default => :welcome

  def index
    @active_subtab = params.fetch(:tab, "activity")

    order = "activity_at desc"
    case @active_subtab
      when "activity"
        order = "activity_at desc"
      when "hot"
        order = "hotness desc"
    end

    @langs_conds = scoped_conditions[:language][:$in]
    add_feeds_url(url_for(:format => "atom", :languages => @langs_conds),
                                                    t("feeds.questions"))

    @questions = Question.paginate({:per_page => 15,
                                   :page => params[:page] || 1,
                                   :fields => (Question.keys.keys - ["_keywords", "watchers"]),
                                   :order => order}.merge(
                                   scoped_conditions({:banned => false})))
  end

  def feedback
  end

  def send_feedback
    Notifier.deliver_new_feedback(current_user, params[:feedback][:title],
                                      params[:feedback][:description])
    redirect_to root_path
  end

  def facts
  end
end

