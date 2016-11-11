class SubscriptionsController < ApplicationController

  # in_place_edit_for :subscription, :note
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => "post", :only => [ :create, :update ]

  def index
    @page_title = "CBCL - Abonnementer på spørgeskemaer"
    @options = params
    @surveys = current_user.surveys.to_a
    @centers = 
    if current_user.has_access? :subscription_show_all
      Center.all.to_a
    elsif current_user.has_access? :subscription_show
      current_user.centers
    end 
    
    @active = current_user.center || current_user.centers.last
    @centers = @centers.sort_by {|c| c.title }
    # @subscription_presenters = @centers.map { |center| center.subscription_presenter(@surveys) }
    # @subscription_counts_per_center = @centers.inject({}) {|hash, center| hash[center.id] = Subscription.subscriptions_count(center); hash }
    # @subscription_summaries_per_center = @centers.inject({}) {|hash, center| hash[center.id] = center.subscription_summary(params); hash }
  end

  def show
    puts "PARAMS: #{params.inspect}"
    @group = Center.find(params[:id])
    @start = DateTime.parse(params[:start])
    @stop = DateTime.parse(params[:stop])
    # counts all answers, also for deleted entries
    # sas = SurveyAnswer.where(:center_id => @group.id, :done => 1)
    #         .where("created_at > ?", @start)
    #         .where("created_at < ?", @stop)
    states = [5,6]
    jes = JournalEntry.in_center(@group.id).for_states(states).answered_between(@start, @stop)
            # .where("answered_at > ?", @start)
            # .where("answered_at < ?", @stop)
    @count = jes.count
    @login_count = JournalEntry.in_center(@group.id).answered_by_login_user.answered_between(@start, @stop).count
    
    @journal_entries = JournalEntry.in_center(@group.id).for_states(states).
      answered_between(@start, @stop).all(:order => 'journals.title asc', :include => :journal)


    respond_to do |format|
      format.html
      format.js { render :partial => 'reminders/entries' }
    end
  end

  def all
    @centers = 
    if current_user.has_access? :subscription_show_all
      Center.all.to_a
    elsif current_user.has_access? :subscription_show
      current_user.centers
    end 

    @subscription_presenters = @centers.map &:subscription_presenter
    @surveys = current_user.surveys.group_by {|s| s.id}

    # render :partial => 'center', :locals => {:subscription_presenter => subscription_presenter, :group => group }

    @centers = @centers.sort_by {|c| c.title }
    # @subscription_presenters = @centers.map { |center| center.subscription_presenter(@surveys) }

    @subscription_counts_per_center = @centers.inject({}) {|hash, center| hash[center.id] = Subscription.subscriptions_count(center); hash }
    @subscription_summaries_per_center = @centers.inject({}) do |hash, center| 
      sub_service = SubscriptionService.new(center)
      hash[center.id] = sub_service.subscription_summary; hash 
    end    
  end

  
  def center
    group = Center.find params[:id]
    subscriptions = group.subscriptions(:include => :periods).select {|sub| sub.survey.bundle == "CBCL"}
    subscription_presenter = group.subscription_presenter(subscriptions)
    # @surveys = surveys.group_by {|s| s.id}

    render :partial => 'center', :locals => {:subscription_presenter => subscription_presenter, :group => group }
  end
  # def show
  #   @page_title = "CBCL - Abonnementer på spørgeskemaer"
  #   @options = params  # for show options
  #   @group = Center.find(params[:id])
  #   # @subscription_count = @subscription.subscriptions_count
  #   @subscription_presenter = @group.subscription_presenter(@group.surveys)
  #   @subscription_summary = @group.subscription_service.subscription_summary(params) # @group.subscription_summary(params)
  #   puts "subs presenter: #{@subscription_presenter.inspect}"
  #   puts "subs summary: #{@subscription_summary.inspect}"
  #   # @surveys = []
  # end

  def new
    @group = Group.find(params[:id])
    @surveys = Survey.find(:all)
    @subscribed = Subscription.active.in_center(@group)
  end


  def create
    @group = Group.find(params[:group][:id])
    if @group.valid?
      surveys = params[:group][:surveys] || []
      subscriptions = Subscription.in_center(@group)
      subscriptions.each do |sub|
        if surveys.include? sub.survey_id.to_s   # in survey and in db
          sub.activate! unless sub.active?
        else   # not in surveys, but in db, so deactivate
          sub.deactivate! unless sub.inactive?
        end
        surveys.delete sub.survey_id.to_s   # remove already done subs
      end
      # elsif not exists in db, create new subscription

      start_date = subscriptions.any? && subscriptions.first.periods.last.start || DateTime.now
      puts "start_date: #{start_date.to_s(:long)}"

      surveys.each do |survey| @group.subscriptions.create(
          :center => @group,
         :survey_id => survey.to_i, :state => 1, :start => start_date)
      end
      if @group.save
        flash[:notice] = "Abonnementer for center #{@group.title} blev ændret."
        redirect_to center_path(@group)
      else
        @surveys = Survey.find(:all)
        @subscribed = Subscription.active.in_center(@group)
        # flash[:error] = "Kunne ikke oprette abonnement: #{@group.errors.map &:inspect}"
        # redirect_to new_subscription_path(@group)
        render :new
      end
    else
      flash[:error] = "Der er en fejl i centerets oplysninger. Check centerets kode (skal være 4 cifre)."
      redirect_to edit_center_path(@group)
    end
  end


  # reset counter for active copy
  def reset
    @subscription = Subscription.find(params[:id])
    if request.post? && params["yes"]
      active_period = @subscription.find_active_period
      active_period.used = 0
      active_period.save
      flash[:notice] = "Tæller for abonnement blev nulstillet."
    end
    redirect_to subscription_path(@subscription) 
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to subscription_path(@subscription)
  end
  
  # reset counter for all periods, also paid
  def reset_all
    @subscription = Subscription.find(params[:id])
    if request.post? && params["yes"]
      @subscription.periods.each { |copy| copy.reset! }
      flash[:notice] = "Tæller for abonnement blev nulstillet."
      @subscription.save
    end
    redirect_to subscription_path(@subscription)
    
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Dette abonnement kunne ikke findes.'
      redirect_to subscription_path(@subscription)
  end
  

  def activate
    @subscription = Subscription.find(params[:id])
    if @subscription.activate!
      flash[:notice] = "Abonnementet er aktiveret."
      redirect_to subscription_path(@subscription)
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Dette abonnement kunne ikke findes.'
    redirect_to subscriptions_path
  end

  def deactivate
    @subscription = Subscription.active.find(params[:id])
    if @subscription.deactivate!
      flash[:notice] = "Abonnementet er deaktiveret."
      redirect_to subscription_path(@subscription)
    end
    
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Dette abonnement kunne ikke findes.'
    redirect_to subscriptions_path
  end
    
  protected
  before_filter :admin_access, :except => [ :list, :index, :show, :center ]
  before_filter :subscription_show, :only => [ :list, :index, :show ]

  
  def admin_access
    if current_user && current_user.access?(:subscription_new_edit)
      return true
    elsif current_user
      flash[:error] = "Du har ikke adgang til denne side"
      redirect_to main_path
    else
      redirect_to login_path
    end
  end

  def check_access
    current_user && current_user.access?(:superadmin)
  end
  
  def subscription_show
    if !(current_user && current_user.access?(:subscription_show))
      flash[:notice] = "Du har ikke adgang til denne side"
      redirect_to main_path
    end
  end
  
end
