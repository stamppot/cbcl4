# encoding: utf-8

module SurveyHelper

  SURVEY_TYPES = [ ["Lærer", "teacher"], ["Forælder", "parent"], ["Ung", "youth"], ["Pædagog", "pedagogue"], ["Andet", "other"] ]

  def div_item(html, type)
    #content_tag("div", html, { :class => type } )
    "<div class='#{type}'>#{html}</div>"
  end

  def set_focus_to_id(id)
    javascript_tag("$('#{id}').focus()");
  end
  
  # help is form needing help
  # used by answer_by question
  def help_tip(help, div_id)
    script = "$('help_#{div_id}').toggle();"
    "<img onclick=\"#{script}\" title=\"Vis svarmuligheder\" alt='Svarmuligheder' class='help_icon' src='/assets/icon_comment.gif'>" +
    "<div id='help_#{div_id}' class='' style='display:none;'><div class='help_tip'>#{help}</div></div>"
  end
end
