# encoding: utf-8

class FollowUpLettersController < ApplicationController
  # layout 'wysiwyg'
  
  def index
    if current_user.admin?  # vis ikke alle breve til admin, kun i dennes center
      @groups = current_user.assigned_centers_and_teams # [current_user.centers.first] + current_user.centers.first.children.inject([]) { |col, team| col << team if team.instance_of?(Team); col }
    else
      @groups = current_user.center_and_teams
    end
    puts "groups: #{@groups.inspect}"
    params[:center_id] = current_user.center_id || 1
    params[:group].delete :id if params[:group] && params[:group][:id].blank?
    logger.info "params: #{params.inspect}"
    @letters = FollowUpLetter.filter(params)
    @group = Group.find(params[:group][:id]) if params[:group] && !params[:group][:id].blank?
    @surveys = Survey.find([2,3,4,5])
    @survey = Survey.find_by_surveytype(params[:survey][:surveytype]) if params[:survey]
    @follow_ups = FollowUp.get
    
    @letters = FollowUpLetter.where('group_id is null').to_a + @letters if current_user.admin?
    @letters = FollowUpLetter.all if params[:all]
  end

  def show
    @letter = FollowUpLetter.find(params[:id])
    @page_title = @letter.name
  end

  def new
    @letter = FollowUpLetter.new(:follow_up => 1, :problematic => false)
    @role_types = Survey.surveytypes
    @groups = if params[:id]
      used_roles = FollowUpLetter.find_all_by_group_id(params[:id])
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
    @letter = FollowUpLetter.find(params[:id])
    puts "edit: #{@letter.letter}"
    @role_types = Survey.surveytypes
    @groups = current_user.center_and_teams.map {|g| [g.title, g.id] }
    @groups.unshift ["Alle grupper", nil] if current_user.admin?
    @page_title = @letter.name
    @follow_ups = FollowUp.get

    unless current_user.can_access_group?(@letter.group_id)
	    flash[:notice] = "Kan ikke rette andres breve!" 
	    redirect_to FollowUpLetter._path and return
    end
  end

  def create
    params[:letter][:letter] = params[:letter_contents]
    @letter = FollowUpLetter.new(params[:letter])
    @group = Group.find_by_id params[:letter][:group_id]

    if @group
      @letter.group = @group
      @letter.center = @group.center if @group

      existing_letter = @group.letters.select do |l| 
        l.group_id == @group.id &&
        l.surveytype == params[:letter][:surveytype] && 
        l.follow_up == params[:letter][:follow_up] &&
        l.problematic == params[:letter][:problematic]
      end
      if existing_letter && existing_letter.any?
        flash[:error] = "Gruppen '#{@group.title}' har allerede et brev af typen '#{Survey.get_survey_type(@letter.surveytype)}'. V&aelig;lg en anden gruppe"
      end
    end

    if @letter.save
      flash[:notice] = 'Brevet er oprettet.'
      redirect_to(@letter) and return
    else
      puts "letter errors: #{@letter.errors.inspect}"
      @groups = @group && [[@group.title, @group.id]] || current_user.center_and_teams.map {|g| [g.title, g.id] }
      # @letter.follow_up = params[:letter][:follow_up].blank? && -1 || params[:letter][:follow_up].to_i
      @follow_ups = FollowUp.get
      render :new, :params => params and return
    end
  end

  def update
    @letter = FollowUpLetter.find(params[:id])
    params[:letter][:letter] = params[:letter_contents]
    @letter.update_attributes params[:letter]
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
    @letter = FollowUpLetter.find(params[:id])
  end

  def destroy
      @letter = FollowUpLetter.find(params[:id])
      @letter.destroy
      flash[:notice] = "Brevet #{@letter.name} er blevet slettet."
      redirect_to follow_up_letters_path
  end
  
  def show_login
    entry = JournalEntry.find(params[:id], :include => :login_user)
    @login_user = entry.login_user
    # find FollowUpLetter.for team, center, system
    @letter = FollowUpLetter.find_by_priority(entry)
    if @letter.nil?
      render :text => "Intet brev fundet. Brugernavn: #{entry.login_user.login}<p>Password: #{entry.password}" and return
    end
    @letter.insert_text_variables(entry)
    @page_title = @letter.name
    render :layout => 'letters'
  end
  
 #  def show_logins
 #    journal = Journal.find(params[:id])
 #    logger.info("params: #{params.inspect}")
 #    if params[:letters].all? {|k,v| v.to_i == 0}
	# params[:letters] = params[:letters].inject({}) {|h,e| h[e.first] = 1; h }
 #    end 
 #    selected = params[:letters].select {|k,v| v.to_i == 1 }.inject([]) { |col,v| col << v.first.to_i; col }
 #    logger.info("selected: #{selected.inspect}")
	# 	entries = journal.not_answered_entries.select {|e| selected.include?(e.id)}
 #    # find letter for team, center, system
	# 	entry_letters = []
	# 	entry_letters = entries.map do |entry|
 #      letter = FollowUpLetter.find_by_priority(entry).dup # duplicate to fill multiples of the same letter
	# 		[entry, letter]
	# 	end
	# 	@letters = entry_letters.map do |pair|
	# 		letter = pair.last
	# 		letter.insert_text_variables(pair.first)
	# 		letter
	# 	end
 #    render :layout => 'letters'
 #  end

  def preview
    @letter = FollowUpLetter.find(params[:id])

    respond_to do |wants|
      wants.html  { render :layout => 'letters' }
      wants.js   { render :layout => false }
    end
  end

  def merge(journal)
    # find FollowUpLetter.for team, center, system
    @letter = FollowUpLetter.find(params[:id])
    @letter.insert_text_variables journal
    render :layout => 'letters', :template => 'login_letters/show_login'
  end

  def mail_merge
    # find FollowUpLetter.for team, center, system
    @letter = FollowUpLetter.find(params[:id])
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
