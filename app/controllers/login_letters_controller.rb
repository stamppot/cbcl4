# encoding: utf-8

class LoginLettersController < ApplicationController
  # layout 'wysiwyg'
  
  def index
    if current_user.admin?  # vis ikke alle breve til admin, kun i dennes center
      @groups = current_user.assigned_centers_and_teams # [current_user.centers.first] + current_user.centers.first.children.inject([]) { |col, team| col << team if team.instance_of?(Team); col }
    else
      @groups = current_user.center_and_teams
    end
    params[:center_id] = current_user.center_id || 1
    params[:group].delete :id if params[:group] && params[:group][:id].blank?
    logger.info "params: #{params.inspect}"
    @letters = LoginLetter.filter(params)
    @group = Group.find(params[:group][:id]) if params[:group] && !params[:group][:id].blank?
    @surveys = Survey.find([2,3,4,5])
    @survey = Survey.find_by_surveytype(params[:survey][:surveytype]) if params[:survey]
    @follow_ups = FollowUp.get
    
    puts "@letters: #{@letters.inspect}"
    @letters = LoginLetter.where('group_id is null').to_a + @letters if current_user.admin?
    @letters = LoginLetter.all if params[:all]
  end

  def show
    @letter = LoginLetter.find(params[:id])
    @page_title = @letter.name
  end

  def new
    @letter = LoginLetter.new
    @role_types = Survey.surveytypes
    @groups = if params[:id]
      used_roles = LoginLetter.find_all_by_group_id(params[:id])
      @role_types.delete_if {|r| used_roles.include?(r.last) }
      Group.find([params[:id]])
    else
      current_user.center_and_teams
    end
    @groups = @groups.map {|g| [g.title, g.id] } if @groups.any?
    @groups.unshift ["Alle grupper", nil] if current_user.admin? && !params[:id] && !Letter.default_letters_exist?
    @follow_ups = FollowUp.get
  end

  def edit
    @letter = LoginLetter.find(params[:id])
    puts "edit: #{@letter.letter}"
    @role_types = Survey.surveytypes
    @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
    @groups.unshift ["Alle grupper", nil] if current_user.admin?
    @page_title = @letter.name
    @follow_ups = FollowUp.get

    unless current_user.can_access_group?(@letter.group_id)
	    flash[:notice] = "Kan ikke rette andres breve!" 
	    redirect_to login_letters_path and return
    end
  end

  def create
    params[:letter][:letter] = params[:letter_contents]
    @letter = LoginLetter.new(params[:letter])
    @group = Group.find_by_id params[:letter][:group_id]
    @letter.group = @group
    @letter.center = @group.center
    existing_letter = @group.letters.select {|l| l.group_id == @group.id && l.surveytype == params[:letter][:surveytype] && l.follow_up == params[:letter][:follow_up] }
    if existing_letter.any?
      flash[:error] = "Gruppen '#{@group.title}' har allerede et brev af typen '#{Survey.get_survey_type(@letter.surveytype)}'. V&aelig;lg en anden gruppe"
    end
    
    if @letter.save
      flash[:notice] = 'Brevet er oprettet.'
      redirect_to(@letter) and return
    else
      @group = [@letter.group.title, @letter.group.id]
      @role_types = Survey.surveytypes
      @groups = [@group]
      # @letter.follow_up = params[:letter][:follow_up].blank? && -1 || params[:letter][:follow_up].to_i
      @follow_ups = FollowUp.get
      render :new, :params => params and return
    end
  end

  def update
    @letter = LoginLetter.find(params[:id])
    params[:letter][:letter] = params[:letter_contents]
    @letter.group_id = params[:letter][:group_id]
    @letter.letter = params[:letter][:letter]

    if @letter.save
      flash[:notice] = 'Brevet er rettet.'
      redirect_to(@letter) and return
    else
      @group = [@letter.group.title, @letter.group.id]
      @follow_ups = FollowUp.get
      @role_types = Survey.surveytypes
      @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
      render :edit
    end
  end
  
  def delete
    @letter = LoginLetter.find(params[:id])
  end

  def destroy
      @letter = LoginLetter.find(params[:id])
      @letter.destroy
      flash[:notice] = "Brevet #{@letter.name} er blevet slettet."
      redirect_to login_letters_path
  end
  
  def show_login
    entry = JournalEntry.includes(:login_user).find(params[:id])
    @login_user = entry.login_user
    # find letter for team, center, system
    @letter = LoginLetter.find_by_priority(entry)

    if @letter.nil?
      render :text => "Intet brev fundet. Brugernavn: #{entry.login_user.login}<p>Password: #{entry.password}" and return
    end
    # puts "letter: #{@letter.inspect}"
    @letter.insert_text_variables(@letter.to_text_variables(entry))
    @page_title = @letter.name
    render :layout => 'letters'
  end
  
  def show_logins
    journal = Journal.find(params[:id])
    logger.info("params: #{params.inspect}")
    if params[:letters].all? {|k,v| v.to_i == 0}
    	params[:letters] = params[:letters].inject({}) {|h,e| h[e.first] = 1; h }
    end 
    selected = params[:letters].select {|k,v| v.to_i == 1 }.inject([]) { |col,v| col << v.first.to_i; col }
    logger.info("selected: #{selected.inspect}")
		entries = journal.not_answered_entries.select {|e| selected.include?(e.id) }
    entries = entries.sort_by {|e| e.survey_id }.uniq {|e| e.survey.surveytype} # exclude multiple logins for same people (parents) (to not send login for infoskema)      # exclude info_skema

    # find letter for team, center, system
		entry_letters = []
		entry_letters = entries.map do |entry|
      letter = LoginLetter.find_by_priority(entry).dup # duplicate to fill multiples of the same letter
			[entry, letter]
		end
		@letters = entry_letters.map do |pair|
			letter = pair.last
			letter.insert_text_variables(letter.to_text_variables(pair.first))
			letter
		end
    render :layout => 'letters'
  end

  def mail_merge
    # find letter for team, center, system
    @letter = LoginLetter.find(params[:id])
    @letter.to_mail_merge
    render :layout => 'letters', :template => 'login_letters/show_login'
  end

  def check_access
    if current_user.nil?
      redirect_to login_path and return
    end
    if ["show_login"].include?(params[:action]) && current_user and (current_user.access? :all_users)
      access = current_user.has_journal_entry? params[:id]
    end
    return access || true
  end
end
