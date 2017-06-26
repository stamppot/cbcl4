# encoding: utf-8

class QuestionCell < ActiveRecord::Base
	belongs_to :question
	belongs_to :choice

	#serialize :question_items, Array
	serialize :preferences
	attr_accessor :value, :number, :question_items  # must be accessed through self.question_items
	attr_accessor :question_text, :options
	attr_accessible :question, :col, :row, :answer_item, :items, :preferences, :prop_mask, :span, :prespan

	attr_accessible :type  # TODO: remove again

  PROPERTIES = %w{input report}
  
	scope :ratings, -> { where('type = ?', 'Rating') }
	scope :answerable, -> { where(['type IN (?)', ['Rating', 'Checkbox', 'ListItemComment', 'SelectOption', 'Textbox']]) }  # and ListItem???? TODO: check if this can be answered, otherwise answerable part should be extracted to other type
	scope :unanswerable, -> { where(['type not IN (?)', ['Rating', 'Checkbox', 'ListItemComment', 'ListItem', 'SelectOption', 'Textbox']]) }
	scope :with_property, lambda { |prop| where("prop_mask & #{2**PROPERTIES.index(prop.to_s)} > 0") }

 	def prop_index(p) 2**PROPERTIES.index(p) end

 	def add_prop(prop)
 	  self.properties << prop if PROPERTIES.include?(prop)
 	end
 	
 	def properties=(props)
 	  raise RunTimeError("properties arg must be array") unless props.is_a? Array
 	  self.prop_mask = (props & PROPERTIES).map { |p| prop_index(p) }.sum
 	end
 	
 	def properties
 	  PROPERTIES.reject { |p| ((prop_mask || 0) & prop_index(p)).zero? }
 	end
  
	def row_data
		self.answer_text if question_text.nil?
		data = {:item => self.answer_item, :text => self.question_text, :question => self.question.number }
		data[:score] = item_options.size > 1 && item_options_text || "text"
		data
	end
	
	def datatype # || self.type == "Checkbox"  - for now only ratings are numeric values
		self.is_a?(Rating) && :numeric || :string
	end
			
	def cell_same_row
		cells = self.question.question_cells(:conditions => ['col != ? AND row = ?', self.col, self.row])
		cell = cells.first if cells.any?
	end

	def mix(other_cell)
		if self.answerable?
			self.question_text = other_cell.item_options.first[:text]
		else
			self.question_text = self.item_options.first[:text]
			self.options = other_cell.item_options_text
		end
		self
	end
	# private :mix, :cell_same_row
	
	def value_to_text
		self.question_items.map { |item| [item.value.blank? && item.text || item.value, item.position] }
	end
	
	def answer_text
		other_cell = cell_same_row
		mix(other_cell) if other_cell
	end
	
	def answerable?
		# or check if item_options returns more than one element array
		['Rating', 'Checkbox', 'ListItemComment', 'SelectOption', 'Textbox'].include? self.class.to_s
	end
	
	# initialize self.items to array of QuestionItems
	def question_items
		@question_items = [] if @question_items.nil?
		if !@question_items.empty?
			return @question_items
		elsif !self.items.nil? and !self.items.empty?
			items.split("\#\#\#").each_with_index do |item, i|
				fields = item.split("::")
				q_item = QuestionItem.new
				q_item.qtype = (fields[0].nil? ? "" : fields[0])
				q_item.value = (fields[1].nil? ? "" : fields[1])
				q_item.text  = (fields[2].nil? ? "" : fields[2])
				q_item.position = i+1
				@question_items << q_item
			end
		end
		return @question_items
	end

	# create question_item objects from "items"=>[["radio", 0], ["radio", 1]]
	def create_question_items(items)
		question_items = []
		items.each_with_index do |item, i|  # item == ["option", "value"]  # sort by 2nd in array, which is item value
			@q_item = QuestionItem.new
			@q_item.qtype = item.first
			@q_item.text  = item[1]  # second item is value
			# @q_item.value = item[1]
			@q_item.position = i+1   #from zero-index to 1-indexed
			if item.size == 3 and @q_item.qtype.downcase =~ /option|radio|checkbox|checkboxaccess/
				@q_item.value = item.last
			end
			question_items << @q_item
		end
		return question_items
	end

	# "items"=>[["radio", 0], ["radio", 1]]
	def add_question_items(items)   #params is hash of type => value
		new_q_items = create_question_items(items)
		add_q_items(new_q_items)
	end

	def add_switch_source(source)
		self.preferences ||= Hash.new
		if self.preferences[:switch].nil?
			self.preferences[:switch] = [source.to_s]
		else
			self.preferences[:switch] << source.to_s
		end
	end

	# returns nil if nothing is removed
	def remove_switch_source(source)
		self.preferences ||= Hash.new
		if self.preferences[:switch].nil?
			return nil
		else
			return self.preferences[:switch].delete(source.to_s)
		end
	end

	# sets one switch source, removes others if present
	def set_switch_source(source)
		self.preferences ||= Hash.new
		self.preferences[:switch] = [source.to_s]
	end

	# switches are an array of identifiers
	def switch_source(options = {})
		return {} if preferences.blank?
		if options[:disabled]
			""
		elsif preferences && preferences[:switch]
			preferences[:switch].collect { |s| "switch-#{s}" }.join(" ")
		else
			""
		end
	end

	# sets one switch target, removes others if present
	# true == onstate
	# false == offstate
	def set_switch_target(target, state)
		self.preferences ||= Hash.new
		self.preferences[:targets] = [ {:target => target.to_s, :state => (state ? "onstate" : "offstate")} ]
	end

	# targets are a hash of target, state. A cell can have multiple targets
	# preference[:target] => [ {:target => "a", true}, {:target => "b", false} ]
	# true == onstate, false == offstate
	# if exists, switch is replaced
	def add_switch_target(target, state)
		self.preferences ||= Hash.new
		if self.preferences[:targets].nil?
			self.preferences[:targets] = [{ :target => target.to_s, :state => (state ? "onstate" : "offstate")}]
		else
			self.remove_switch_target(target)
			self.preferences[:targets] << { :target => target.to_s, :state => (state ? "onstate" : "offstate")}
		end
	end

	# returns nil if nothing is removed
	def remove_switch_target(target)
		self.preferences ||= Hash.new
		if self.preferences[:targets].nil?
			nil
		else
			self.preferences[:targets].delete_if { |elem| elem[:target] == (target.to_s) }
		end
	end

	# to be deprecated by validation
	def set_required(boolean)
		self.preferences ||= Hash.new
		self.preferences[:required] = boolean
	end

	def required?
		!self.preferences.blank? && self.preferences && self.preferences[:required]
	end
	alias :required :required?

	def set_default_value=(value)
		self.preferences ||= Hash.new
		self.preferences[:value] = value
	end

	def default_value
		self.preferences && self.preferences[:value]
	end

	def set_validation(validation)
		self.preferences ||= Hash.new
		self.preferences[:validation] = validation unless validation.blank?
	end

	def validation
		return {} if preferences.blank?
		self.preferences && self.preferences[:validation]
	end

	def clear_prefs!
		preferences = nil
		self.save
	end

	def switch_target(options = {})
		# puts "preferences: #{preferences.inspect} #{self.id}" if preferences.blank?
		return "" if preferences.blank?

		if options[:disabled]
			""
		elsif preferences && preferences[:targets]
			preferences[:targets].collect { |t| "#{t[:state]}-#{t[:target]}" }.join(" ")
		else
			""
		end
	end

	def item_options
		options = self.question_items.map { |item| { :text => item.text, :value => item.value } }
	end

	def item_options_text
		options = self.question_items.map { |item| "#{item.value.blank? && 'text' || item.value} = #{item.text}" }
	end

	# def answer_options
	# 	if self.choice_id
	# 		options = self.choice.get_options[item.value.to_i]
	# 	else
	# 		self.question_items.inject({}) do |h, item|
	# 			h[item.value.to_i] = item.text
	# 			h
	# 		end
	# 	end
	# end

	def to_s
		info = ""
		items = ""
		info << "qtype: " << qtype.to_s << "\n"
		info << "row: " << row.to_s << "\n"
		info << "\t"*(col-1) << "col: " << col.to_s << "\n"
		self.question_items.each do |item|
			items += item.qtype.to_s + ": " + item.value.to_s + "\n"
		end
		return info
	end

  def outer_span(last = false)
    span = "span-7" if col == 1
    span = "span-8" if col != 1
    span << " last" if last
    span
  end
  
	def to_html(options = {})
		onclick  = options[:onclick]
		options[:outer_span] = outer_span
		
		id_class = id_and_class(options)
	    id_class.gsub!(/onstate-(.)/, '')
    	id_class.gsub!(/offstate-(.)/, '')
	    "<div #{onclick} #{id_class} >#{create_form(options)}</div>"
	end

	def to_fast_input_html(options = {})
		options[:outer_span] = outer_span
    	# "<div #{id_and_class(options)} >#{fast_input_form(options)}</div>"
    	fast_input_form(options)
	end

	def to_answer(options = {})
		to_html(options)
	end

	# comparison based on row first, then column
	def <=>(other)
		if self.row == other.row
			self.col <=> other.col
		else
			self.row <=> other.row
		end
	end

	def eql_cell?(other)
		!other.nil? && (self.row == other.row) && (self.col == other.col)
	end

	# sets id and class for td cells
	def id_and_class(options = {}) # change to {}
		ids = ["id='td_#{self.cell_id(options[:number])}' class='#{self.class_name} #{options[:outer_span]}"]
		ids << " " << options[:target] if options[:target]
		(ids << "'").join
		# end
	end

	def cell_id(no = self.question.number)
		no ||= self.question.number
		return "q#{no}_#{row}_#{col}"
	end

	# generates class names used for layout. E.g. for items of type desc, it adds lab1 etc.
	def class_name
		name = self.class.to_s.downcase
		if self.instance_of?(Description) or self.instance_of?(Rating)
			name += self.question_items.size.to_s
			item = self.question_items.collect { |item| item.text.length unless item.text.nil? }.compact.max
			name << case item
			when (1..1) then "lab"    # labels 0 1 2 etc
			when (2..4) then "lab1"    # nej, ja, etc
			when (5..8) then "lab2"    # middel, daarligt, bedre etc
			when (9..15) then "lab3"   # laengere
			when (16..40) then "lab4"  # lange fx mindre end gennemsnit etc
			else ""
			end
		end
		name
	end

	def div_item(html, type, id = nil)
		id_attr = id.blank? ? "" : "id='#{id}'"
		"<div #{id_attr} class='#{type}'>#{html}</div>"
	end

	def span_item(html, type, id = nil)
		id_attr = id.blank? ? "" : "id='#{id}'"
		"<span #{id_attr} class='#{type}'>#{html}</span>"
	end

	def span_item(html, type)
		#content_tag("div", html, { :class => type } )
		"<span class='#{type}'>#{html}</span>"
	end

	def form_template(value = nil, disabled = false, show_all = true)
		form = self.question_items.collect { |item| (item.text.nil? ? "" : item.text) + ": " + (item.value.nil? ? "" : item.value) }
		form.join
	end

	def create_form(options = {})
		# options[:value]    = options[:value]
		options[:disabled] = options[:disabled] ? true : false
		options[:show_all] = options[:show_all] && true || false
		options[:fast]     = options[:fast] ? true : false
		options[:edit]     = options[:action] == "edit"
		options[:print]    = options[:action] == "print"
		options[:action]   = options[:action]
		self.form_template(options)
	end

	def fast_input_form(options = {}, value = nil)
		options[:disabled] = false
		options[:show_all] = false
		options[:number]   ||= self.question.number.to_s
		options[:edit]     = options[:action] == "edit"
		options[:print]    = options[:action] == "print"
		options[:action]   = options[:action]
		self.create_form(options)
	end

	def edit_form
		self.create_form
	end

	def svar_item(cut = true)
		if self.answer_item.nil? or self.answer_item.empty?
			""
		elsif !cut
		  self.answer_item + ". "
		elsif
		   self.answer_item.match(/\d+([a-z]+)/)  # cut off number prefix (fx 1.)
			"\t" + $1 + ". "
		else self.answer_item + ". "
		end
	end

	def values
		vals = self.question_items.collect { |item| item.value.to_s unless item.value.empty? }.compact.sort
		return vals
	end

	def text_values
		self.question_items.collect { |item| "#{item.text = item.value}" }.compact.sort
	end

	# if two values are 'overlapping strings' such as 8 and 88, then exactlyOneOf validation is returned
	# values are string-sorted
	def validation_type
		values = self.question_items.map {|item| item.value.to_s}.sort # string sort
		b = []
		0.upto(values.length-2) do |i|
			b << true if(values[i+1].include?(values[i]))
		end
		if b.length > 0
			"exactlyoneof"
		else
			"oneof"
		end
	end

	# insert javascript piece to check value is one of valid values
	# cannot be named validate, then it's called automatically
	def add_validation(options = {})
		return "" if options[:disabled]
		no = options[:number] || self.question.number.to_s 
		#validation = options[:validate] || ""
		#callback = options[:callback] || nil

		#values = @question_items.collect { |item| item.value.to_s unless item.value.empty? }.sort
		errormsg = "Ugyldig værdi. Brug " << self.values.join(", ")
		script = "\t\t<script type='text/javascript'>" <<
		case self.validation_type
		when "oneof" then "\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { oneOf : #{self.values.inspect} });\n"
		when "exactlyoneof" then
			"\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { exactlyOneOf : #{self.values.inspect} } );"
			# todo  how to check value of checkbox
		when "checkbox" then "\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { oneOf : '[\"0\",\"1\"]' });\n"
		else
			"\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { oneOf : #{self.values.inspect} } );"
			# "\tValidation.add('#{self.cell_id}', '#{errormsg}', { oneOf : #{self.values.inspect});\n"
		end
		script << "\t\t</script>"
	end

	def to_xml2
		xml = []
		xml << "<question_cell id='#{self.id.to_s}' >"
		xml << "  <type>#{self.type.to_s}</type>"
		xml << "  <col>#{self.col.to_s}</col>"
		xml << "  <row>#{self.row.to_s}</row>"
		xml << "  <item>#{self.answer_item}</item>"
		xml << "  <question_items>"
		xml << self.question_items.collect { |question_item| question_item.to_xml }
		xml << "  </question_items>"
		xml << "</question_cell>"
	end

	private

	def after_initialize 
		self.preferences ||= Hash.new 
	end

	# append directly to items field
	def add_q_items(question_items)
		self.items = "" if self.items.nil? or self.items.empty?
		question_items.each do |item| 
			if self.items.empty?
				self.items += item.to_db
			else
				self.items += "###" + item.to_db
			end
		end
		# return question_items.inspect
		#self.save
		return self.question_items     # return new items to enable chaining
	end
end

class Questiontext < QuestionCell
  
	def outer_span(last = false)
	  span = "6"
	  span.succ! unless self.col == 1    # span += 1 if row == 1
	  span = "span-#{span}"
	  span << " last" if last # self.col == self.question.columns
	  span
	end
	
	def inner_span
	  outer_span
	end
  	
  	def answer_span(last = false)
  		span = "12"
  		span.succ! unless self.col == 1
	 	span = "span-#{span}"
	 	span << " last" if last
	 	span
	end

	def answer_inner_span
		"span-12"
	end

	def to_answer(options = {})
		options[:outer_span] = self.span && "span-#{span}" || answer_span
		options[:inner_span] = answer_inner_span
		answer_template(options)
	end

	def to_fast_input_html(options = {})
    	options[:outer_span] = outer_span
		"<div #{id_and_class(options)} >#{form_template(options)}</div>"
	end

	def form_template(options = {}) #value = nil, disabled = false, show_all = true)
		newform = ""
		in_span = options[:inner_span] || inner_span
		answer_item = (self.answer_item.nil? or (self.answer_item =~ /\d+([a-z]+)/).nil?) ?  "" : "\t" + $1 + ". "
		
		self.question_items.each do |item|
			newform = if item.position==1
				div_item( answer_item + item.text, "#{in_span} itemquestiontext #{switch_target(options)}".rstrip)
			else
				div_item( item.text, "#{in_span} itemquestiontext #{switch_target(options)}".rstrip)
			end
		end
		newform
	end

	def answer_template(options = {}) #value = nil, disabled = false, show_all = true)
		newform = ""
		out_span = options[:outer_span] || answer_span
		in_span = options[:inner_span] || answer_inner_span
		answer_item = (self.answer_item.nil? or (self.answer_item =~ /\d+([a-z]+)/).nil?) ?  "" : "\t" + $1 + ". "
		
		if self.question.columns == 3
			out_span = self.span && "span-#{span}" || "span-8"
			in_span = "span-8"
		end

		self.question_items.each do |item|
			newform << span_item(answer_item, "span-1") if !answer_item.blank?
			newform << if item.position==1
				span_item(item.text, "#{out_span} #{switch_target(options)}".rstrip)
			else
				span_item(item.text, "#{out_span} #{switch_target(options)}".rstrip)
			end
		end
		newform
	end

	# cell with inline editing
	def edit_form
		newform = ""
		item_text = question_items.first.text #
		answer_item = (self.answer_item.nil? or (self.answer_item =~ /\d+([a-z]+)/).nil?) ?  "" : "\t" + $1 + ". "
		self.question_items.each do |item|
			newform = if item.position==1
				div_item( answer_item + item.text, "itemquestiontext span-9")
			else
				div_item( item_text, "itemquestiontext span-9")
			end
		end
		newform
	end

end

class Information < QuestionCell

	def to_html(options = {})
		"<div id='td_#{cell_id(options[:number])}' class='#{class_name} information span-22 last' >#{question_items.first.text}</div>"
	end

	def to_answer(options = {})
		"<span id='td_#{cell_id(options[:number])}' class='#{class_name} information span-21 last' >#{question_items.first.text}</span>"
	end

	def to_fast_input_html(options = {})
		"<div id='td_#{cell_id(options[:number])}' class='#{class_name} information span-22 last' >#{question_items.first.text}</div>"
	end

	def form_template(options = {})
		div_item(question_items.first.text, "iteminformation")
	end

	def fast_input_form(options = {}, value = nil)
		form_template()
	end

	# cell with inline editing Cdisabled!)
	def edit_form
		item_text = question_items.first.text #in_place_editor_field :question_cell, :items, {}, :rows => 3
		div_item(item_text, "iteminformation")
	end

end

class SectionTitle < QuestionCell

	def to_html(options = {})
		"<div id='td_#{cell_id(options[:number])}' class='#{class_name} sectiontitle span-22 last' >#{question_items.first.text}</div>"
	end

	def to_answer(options = {})
		"<span id='td_#{cell_id(options[:number])}' class='#{class_name} sectiontitle span-21 last' >#{question_items.first.text}</span>"
	end

	def to_fast_input_html(options = {})
		"<div id='td_#{cell_id(options[:number])}' class='#{class_name} sectiontitle span-22 last' >#{question_items.first.text}</div>"
	end

	def form_template(options = {})
		div_item(question_items.first.text, "itemsectiontitle")
	end

	def fast_input_form(options = {}, value = nil)
		form_template()
	end
end

class SectionSubtitle < QuestionCell

	def to_html(options = {})
		"<div id='td_#{cell_id(options[:number])}' class='#{class_name} sectionsubtitle span-22 last' >#{question_items.first.text}</div>"
	end

	def to_answer(options = {})
		"<span id='td_#{cell_id(options[:number])}' class='#{class_name} sectionsubtitle span-21 last' >#{question_items.first.text}</span>"
	end

	def to_fast_input_html(options = {})
		"<div id='td_#{cell_id(options[:number])}' class='#{class_name} sectionsubtitle span-22 last' >#{question_items.first.text}</div>"
	end

	def form_template(options = {})
		div_item(question_items.first.text, "itemsectionsubtitle")
	end

	def fast_input_form(options = {}, value = nil)
		form_template()
	end
end

class Placeholder < QuestionCell

 	def outer_span
 		s = span || 4
    	"span-#{s}"
	end

	def to_answer(options = {})
		"" #div_item(question_items.first.value + "&nbsp;", "itemplaceholder span-1")
	end
  
	def form_template(options = {})
		div_item(question_items.first.value + "&nbsp;", "#{outer_span} itemplaceholder")
	end

	def fast_input_form(options = {}, value = nil)
		form_template()
	end

	def to_answer(options = {})
		sp = if question.columns == 3
				"span-8"
			elsif question.columns == 2
				"span-11"
			else
				"span-7"
			end
		span_item("&nbsp;", "#{sp}")
	end
end

# view like ListItem, answer is shown differently
class QuestionComment < QuestionCell

	def to_html(options = {})
	  # onclick    = options[:onclick]
	  switch_off = options[:switch_off]
	  class_switch = switch_target(options) unless switch_off
	  class_names  = class_name <<
	  ((class_switch.blank? or !switch_off.blank?) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )
	
	  options[:outer_span] = outer_span(options[:last])
	  id_class = id_and_class(options)
	    
	  klass_name = class_name
	  fast = options[:fast] ? true : false
	  klass_name << (fast && "" || " " + switch_target(options))
	
	  "<div id='td_#{cell_id(options[:number])}' class='#{klass_name}'>#{form_template(options)}</div>"
	end
	
	def to_answer(options = {})
		options[:span] = answer_span
	    switch_off = options[:switch_off]
    	class_switch = switch_target(options) unless switch_off
	    class_names  = class_name <<
    	((class_switch.blank? or !switch_off.blank?) ? " #{answer_span}" : " #{class_switch} #{answer_span}" )
  
	    options[:outer_span] = answer_span(options[:last])
	    options[:inner_span] = answer_inner_span
	    options[:answer] = true

    	id_class = id_and_class(options)
      
	    klass_name = class_name
    	fast = options[:fast] ? true : false
	    klass_name << (fast && "" || " " + switch_target(options))
  
	    answer_template(options)
  	end

	def to_fast_input_html(options = {})
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
		class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{fast_outer_span}" : " #{class_switch} #{fast_outer_span}" )
		"<div id='td_#{cell_id(options[:number])}' class='#{class_names}'>#{fast_input_form(options)}</div>"
	end

	def outer_span(last = false)
	  span = if col == 2 and self.question.columns == 2
	    "span-10"
	  else
	    "span-6"
	  end
	  span << " last" if last
	  span
	end
	
	def inner_span
	  outer_span 
	end
	
	def answer_inner_span(last = false)
		return "span-#{span}" if self.span
	 	span = if col == 2 and self.question.columns == 2
	    	"span-8"
	  	else
	    	"span-8"
	  	end
	  	span << " last" if last
	  	span
	end

	def answer_span(last = false)
		return "span-#{span}" if self.span
    	span = if col == 2 and self.question.columns == 2
    		"span-12"
    		else
    		"span-12"
    	end
 	end

	def fast_outer_span(last = false)
	  outer_span(last)
	end
  
	def form_template(options = {})  # value = nil, disabled = false, show_all = true, edit = false)
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all]
		fast     = options[:fast]
		edit     = options[:edit]
		no       = options[:number].to_s || self.question.number.to_s
		span     = options[:outer_span] || outer_span
		in_span  = options[:inner_span] || inner_span 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
    
		self.question_items.each_with_index do |item, i|
			item_text = edit ? item.text : item.text
			field = (i == 0 && (i == question_items.size-1) ? self.svar_item : "")# only show answer_item label in first item for cell with multiple list items
			has_no_text = item_text.blank?
			if(has_no_text)     	# listitem without predefined text
				if(disabled)      	# show answer value
					field << value
				else                        # show text field, possibly with value
		        	case options[:action]
			    	when /print|show/ then 
			      	field << (value || "")
			      	newform << div_item(field, "listitemfield #{span}")
			    	when /create|edit/ then
		            	field << "<textarea id='#{c_id}' class='textfield' name='#{question_no}[#{cell_id(no)}]' type='text' maxlength='2000' rows='1'>#{value}</textarea>"
        		    	newform << field
          			end
				end
			else  # with predefined text. show text in item (no input field)
		        newform << span_item(field + item_text, "#{in_span} #{options[:answer] && 'answerlistitemtext' || 'listitemtext'}")
			end
		end
		span_item(newform.join, "#{class_name} #{span}")
	end

	def answer_template(options = {})  # value = nil, disabled = false, show_all = true, edit = false)
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all]
		fast     = options[:fast]
		edit     = options[:edit]
		no       = options[:number].to_s || self.question.number.to_s
		span     = options[:outer_span] || outer_span
		in_span  = options[:inner_span] || answer_inner_span
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
    
		self.question_items.each_with_index do |item, i|
			item_text = edit ? item.text : item.text
			field = (i == 0 && (i == question_items.size-1) ? self.svar_item : "")# only show answer_item label in first item for cell with multiple list items
			has_no_text = item_text.blank?
			if(has_no_text)     # listitem without predefined text
				if(disabled)      # show answer value
					field << value
				else                        # show text field, possibly with value
		           	span_width = value.nil? && 0 || case value.length
		           	when 0..3 then 1
		           	when 4..12 then 2
		           	when 13..20 then 3
		           	when 21..30 then 8
		           	else 12
		           	end
       		    	newform << span_item(item_text, "span-1") if !item_text.blank?
       		    	newform << span_item(field, "span-#{in_span}") if !field.blank?
       		    	newform << span_item(value + " ", "span-#{span_width}") if !value.blank?
				end
			else  # with predefined text. show text in item (no input field)
				puts "field: #{field}, value: #{value}, item_text: #{item_text}"
				newform << span_item(field, "span-1") if !field.blank? && i == 0
				newform << span_item(item_text, "span-10")
			end
		end
		span_item(newform.join, "#{class_name} #{span}")
	end

	def fast_input_form(options = {}, value = nil)
		options[:disabled] = false
		options[:show_all] = true
		form_template(options)
	end

	# cell with inline editing. Only works for listitems with contents (ie. not answerable)
	def edit_form
		options = { :disabled => false, :show_all => true, :edit => true}
		form_template(options)
	end

end


class ListItem < QuestionCell

	def to_html(options = {})
	  # onclick    = options[:onclick]
	  switch_off = options[:switch_off]
	  class_switch = switch_target(options) unless switch_off
	  class_names  = class_name <<
	  ((class_switch.blank? or !switch_off.blank?) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )
	
	  options[:outer_span] = outer_span(options[:last])
	  id_class = id_and_class(options)
	    
	  klass_name = class_name
	  fast = options[:fast] ? true : false
	  klass_name << (fast && "" || " " + switch_target(options))
	
	  "<div id='td_#{cell_id(options[:number])}' class='#{klass_name}'>#{form_template(options)}</div>"
	end
	
	def to_answer(options = {})
		options[:span] = answer_span
	    switch_off = options[:switch_off]
    	class_switch = switch_target(options) unless switch_off
	    class_names  = class_name <<
    	((class_switch.blank? or !switch_off.blank?) ? " #{answer_span}" : " #{class_switch} #{answer_span}" )
  
	    options[:outer_span] = self.span && self.span || answer_span(options[:last])
	    options[:inner_span] = answer_inner_span
	    options[:answer] = true

    	id_class = id_and_class(options)
      
	    klass_name = class_name
    	fast = options[:fast] ? true : false
	    klass_name << (fast && "" || " " + switch_target(options))
  
	    answer_info(options)
  	end

	def answer_info(options = {})  # value = nil, disabled = false, show_all = true, edit = false)
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all]
		fast     = options[:fast]
		edit     = options[:edit]
		no       = options[:number].to_s || self.question.number.to_s
		span     = options[:outer_span] || answer_span
		in_span  = options[:inner_span] || answer_inner_span
		indent   = options[:indent]
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
    	
    	if preferences && preferences[:indent]
    		newform << span_item("nbsp;", "span-#{preferences[:indent]}")
    		puts "INDENT: #{p[:indent]}"
    	end

		self.question_items.each_with_index do |item, i|
			item_text = edit ? item.text : item.text
			field = (i == 0 && (i == question_items.size-1) ? self.svar_item : "")# only show answer_item label in first item for cell with multiple list items
			has_no_text = item_text.blank?
			if has_no_text     # listitem without predefined text
				# if(disabled)      # show answer value
				# 	field << value
				# else                        # show text field, possibly with value
       		    	newform << span_item(item_text, "span-1") if !item_text.blank? || indent
       		    	newform << span_item(field, "span-#{in_span}") if !field.blank?
       		    	newform << span_item(value + " ", " answer_value") if !value.blank?
				# end
			else  # with predefined text. show text in item (no input field)
				# puts "field: #{field}, value: #{value}, item_text: #{item_text}"
				newform << span_item(field, "span-1") if (!field.blank? && i == 0) || indent
  		    	# newform << span_item(self.value + " ", " answer_value") if !self.value.blank?
				newform <<
				if self.span
					span_item(item_text, "span-#{self.span-2}")
				else
					sp = span && span || 9
					span_item(item_text, "span-#{sp}")
				end
			end
		end
		puts "class_name: #{class_name} span: #{span}"
		span_item(newform.join, "#{class_name} #{span}")
	end

	def to_fast_input_html(options = {})
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
		class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{fast_outer_span}" : " #{class_switch} #{fast_outer_span}" )
		"<div id='td_#{cell_id(options[:number])}' class='#{class_names}'>#{fast_input_form(options)}</div>"
	end

	def outer_span(last = false)
	  span = if col == 2 and self.question.columns == 2
	    "span-9"
		# elsif self.question.columns == 3
		# "span-7"
	  else
	    "span-6"
	  end
	  span << " last" if last
	  span
	end
	
	def inner_span
	  outer_span 
	end
	
	def answer_inner_span(last = false)
		if self.span
			# puts "in span: #{span} #{self.answer_item}"
			return "span-#{span}" 
		end
	 	span = if col == 2 and self.question.columns == 2
	    	"span-9"
	  	else
	    	"span-9"
	  	end
	  	span << " last" if last
	  	span
	end

	def answer_span(last = false)
		return "span-#{span}" if self.span
    	span = if col == 2 and self.question.columns == 2
    		"span-11"
    	elsif self.question.columns == 3
    		"span-7"
    	# elsif self.question.columns == 4
    	# 	"span-6"
    	else
    		"span-12"
    	end
 	end

	def fast_outer_span(last = false)
	  outer_span(last)
	end
  
	def form_template(options = {})  # value = nil, disabled = false, show_all = true, edit = false)
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all]
		fast     = options[:fast]
		edit     = options[:edit]
		no       = options[:number].to_s || self.question.number.to_s
		span     = options[:outer_span] || outer_span
		in_span  = options[:inner_span] || inner_span 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
    
		self.question_items.each_with_index do |item, i|
			item_text = edit ? item.text : item.text
			field = (i == 0 && (i == question_items.size-1) ? self.svar_item : "")# only show answer_item label in first item for cell with multiple list items
			has_no_text = item_text.blank?
			case item.qtype
			when "itemunit" then
        		# answer_item_set = true if self.col == 1
			  	newform <<
				span_item(((answer_item_set && self.col > 2) ? "" : answer_item) + 
					"<input id='#{c_id}' name='#{question_no}[#{c_id}]' class='textfield' type='text' maxlength='20' value='#{item.value}'>#{self.value}</input> #{item.text}", "unitfield answer_value #{span}")
			else
				if(has_no_text)     	# listitem without predefined text
					if(disabled)      	# show answer value
						field << value
					else                        # show text field, possibly with value
			        	case options[:action]
				    	when /print|show/ then 
				      	field << (value || "")
				      	newform << div_item(field, "listitemfield #{span}")
			    		when /create|edit/ then
		            		field << "<textarea id='#{c_id}' class='textfield' name='#{question_no}[#{cell_id(no)}]' type='text' maxlength='2000' rows='1'>#{value}</textarea>"
        		    		newform << field
	          			end
					end
				else  # with predefined text. show text in item (no input field)
		    	    newform << span_item(field + item_text, "#{in_span} #{options[:answer] && 'answerlistitemtext' || 'listitemtext'}")
				end
			end
		end
		span_item(newform.join, "#{class_name} #{span}")
	end

	# def self.to_answer_splitrow(cols, options)
	# 	row1 = cols[0..1]
	# 	row2 = cols[2...3]
	# 	output = []
	# 	output << row1.map {|c| c.to_answer(options)}
	# 	output << "</div></td></tr>"
	# 	output << "<td id='#{options[:number]}_#{options[:row]}_2' class='row'><div class='span-2'>&nbsp;</div>"
	# 	output << row2.map {|c| c.to_answer(options) }
	# 	output << "</td></tr>"
	# 	output.join
	# end

	def answer_template(options = {})  # value = nil, disabled = false, show_all = true, edit = false)
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all]
		fast     = options[:fast]
		edit     = options[:edit]
		no       = options[:number].to_s || self.question.number.to_s
		span     = options[:outer_span] || answer_span
		in_span  = options[:inner_span] || answer_inner_span
		indent   = options[:indent]
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
    	
    	if preferences && preferences[:indent]
    		newform << span_item("nbsp;", "span-#{preferences[:indent]}")
    		puts "INDENT: #{p[:indent]}"
    	end

		self.question_items.each_with_index do |item, i|
			item_text = edit ? item.text : item.text
			field = (i == 0 && (i == question_items.size-1) ? self.svar_item : "")# only show answer_item label in first item for cell with multiple list items
			has_no_text = item_text.blank?
			if(has_no_text)     # listitem without predefined text
				# if(disabled)      # show answer value
				# 	field << value
				# else                        # show text field, possibly with value
       		    	newform << span_item(item_text, "span-1") if !item_text.blank? || indent
       		    	newform << span_item(field, "span-#{in_span}") if !field.blank?
       		    	newform << span_item(value + " ", " answer_value") if !value.blank?
				# end
			else  # with predefined text. show text in item (no input field)
				# puts "field: #{field}, value: #{value}, item_text: #{item_text}"
				newform << span_item(field, "span-1") if (!field.blank? && i == 0) || indent
				newform <<
				if self.span
					span_item(item_text, "span-#{self.span-2}")
				else
					sp = span && span || 9
					span_item(item_text, "span-#{sp}")
				end
			end
		end
		puts "class_name: #{class_name} span: #{span}"
		span_item(newform.join, "#{class_name} #{span}")
	end

	def fast_input_form(options = {}, value = nil)
		options[:disabled] = false
		options[:show_all] = true
		form_template(options)
	end

	# cell with inline editing. Only works for listitems with contents (ie. not answerable)
	def edit_form
		options = { :disabled => false, :show_all => true, :edit => true}
		form_template(options)
	end

end


class SelectOption < QuestionCell

	def outer_span(last = false)
	  span = "span-4"
	  span = "span-6" if self.question.columns == 2 and col == 1 #and self.question.number > 3
	  span << " last" if last
	  span
	end
	
	def inner_span
	  "span-6"
	end
	
	def answer_span(last = false)
		span = "span-9"
	 	span = "span-12" if self.question.columns == 2 and col == 1 #and self.question.number > 3
	 	span << " last" if last
	 	span
	end

	def answer_inner_span
		span = self.span && "span-#{span}" || "span-7"
	end

	def fast_outer_span(last = false)
	  span = "span-6"
	  span = "span-6" if self.question.columns == 2 and col == 1 #and self.question.number > 3
	  span << " last" if last
	  span
	end
  
	def to_html(options = {})
		options[:outer_span] = answer_span
		options[:target] = switch_target(options) unless switch_target.empty? or options[:switch_off]
		super(options)
	end

	def to_answer(options = {})
		options[:outer_span] = answer_span
		options[:inner_span] = answer_inner_span
		p = preferences
		show_all      = options[:show_all].nil? || options[:show_all]
		no            = options[:number].to_s || self.question.number.to_s
		switch_off    = options[:switch_off]
		c_id          = cell_id(no) + "_#{self.question_id}"
		q_no          = "Q#{no}"
		indent 		  = preferences && preferences[:indent] || 0
		outer_span    = self.span && self.span || options[:outer_span] || answer_span
		in_span       = p && p[:indent] && "span-#{p[:in]}" || options[:inner_span] || answer_inner_span
		newform = []
		target = !switch_off ? switch_target(options) : ""

		# puts "Indent: #{indent}  row: #{row} col: #{col} q: #{question_id}  span: #{self.span} outer: #{outer_span}"
		if indent
	    	newform << span_item("&nbsp;", "answer_value span-#{indent}")
	    	# in_span.succ!
	    	puts newform.join + " 	INDENT"
    	end	

    	# create options array
		qitems = self.question_items.collect { |item| [item.qtype, item.value, item.text] }
		if qitems.first[0] == "listitem"
			label = qitems.shift
			newform << span_item(label.last, in_span)
		end 
		# sel_options = ["<option value=''>Vælg et svar</option>"]
		selected = qitems.select { |option| !value.nil? && option[1] == value }.first

		text_value = if self.choice 
			text = self.choice.get_options[self.value.to_s]
		else
			self.value
		end
	
		newform << "<span class='answer_value #{in_span}'>#{text_value} #{selected && selected.last}</span>"
		span_item(newform.join, "#{c_id} span-#{outer_span} selectanswer #{target}".rstrip)
	end

	def to_fast_input_html(options = {})
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
    	class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{fast_outer_span}" : " #{class_switch} #{fast_outer_span}" )
		"<div id='td_#{cell_id(options[:number])}' class='#{class_names}'>#{fast_input_form(options)}</div>"
	end

	def form_template(options = {})
		disabled      = options[:disabled] ? "disabled" : nil
		show_all      = options[:show_all].nil? || options[:show_all]
		#edit          = options[:edit] ? true : false
		no            = options[:number].to_s || self.question.number.to_s
		switch_off    = options[:switch_off]
		c_id          = cell_id(no)
		q_no          = "Q#{no}"
		do_validation = self.validation && self.validation || ""
		span 		  = options[:outer_span] || outer_span
		in_span       = options[:inner_span] || inner_span
		newform = []
		target = (!disabled and !switch_off) ? switch_target(options) : ""

		# create options array
		qitems = self.question_items.collect { |item| [item.qtype, item.value, item.text] }
		if qitems.first[0] == "listitem"
			label = qitems.shift
			newform << "<label for=#{c_id} class='selectlabel'>#{label.last || ""}</label><br>"
		end 
		sel_options = ["<option value=''>Vælg et svar</option>"]
		qitems.each do |option|
			sel_options << "<option value='#{option[1]}' "
			sel_options << "selected='selected'" if !value.nil? and option[1] == value
			sel_options << ">#{option[2]}</option>"
		end
		if disabled # and !value.nil?  # disabled means show answer
			# find text for this value answer
			answer_vals = qitems.detect { |item| item[1].to_s == value.to_s } # item array: index 1 -> value, index 2 -> værdi?
			newform >> (answer_vals && answer_vals[2] || (value == "0" && "ikke besvaret" || "ingen værdi"))
		else
			newform << "<select id='#{c_id}' name='#{q_no}[#{c_id}]' #{disabled} >" + sel_options.join + "\n</select>"
		end
		newform << self.add_validation(options) unless disabled
		div_item(newform.join, "#{in_span} selectoption #{target}".rstrip)
	end

	def fast_input_form(options = {}, value = nil)
		disabled = options[:disabled] ? "disabled" : nil  # Disabled == show answer
		no       = options[:number] || self.question.number.to_s
		fast     = options[:fast] ? true : false
		c_id     = cell_id(no)
		question_no = "Q#{no}"

		answer_item = svar_item
		target = ""# switch_target(options) unless fast
		# 12-2-8 Decision: hurtig input har ingen required, tester kun for rette værdier. Eller alle skal være required
		req = self.required? ? "required" : ""

		newform = []
		# make validation here
		qitems = self.question_items.collect { |item| [item.qtype, item.value, item.text] }
		if qitems.first[0] != "option"  # Select options has label of type listitem
			label = qitems.shift
			target = ""
			newform << "<label for=#{question_no}_#{c_id} class='selectlabel#{target}'>#{label.last}</label>"
		end
		values = qitems.map { |item| item[1] }
		help = qitems.map { |item| (item[1] == item[2]) ? item[1] : "#{item[1]} = #{item[2]}" }.join("<br>")

    input = answer_item.lstrip + "<input id='#{c_id}' name='#{question_no}[#{c_id}]' class='selectoption #{req} #{c_id}' type='text' " +
		(self.value.nil? ? " >" : "value='#{self.value}' >")
		input << help_div(c_id, help)
		newform << span_item(input, "selectoption #{target} #{fast_outer_span}".rstrip) # << # removed />
    # newform <<   # TODO: fix values of help not shown for q7

		newform << self.add_validation(options) if options[:validation] && !disabled
		newform.join
	end

	def help_div(cell_id, help_message)
		"<img src='/assets/icon_comment.gif' class='help_icon' alt='Svarmuligheder' title='Vis svarmuligheder' onclick='Element.toggle(\"help_#{cell_id}\");' >" <<
		"<div id='help_#{cell_id}' style='display:none;'><div class='help_tip'>#{help_message}</div></div>"
	end

	def values  # valid values
		vals = self.question_items.collect { |item| item.value.to_s unless item.value.empty? }.compact.sort
		# vals << "9" unless vals.include? "9"
	end

	def add_validation(options = {}) # TODO: første skal indfyldes; fejlværdig (ikke udfyldt?)
		# puts "options[:disabled]: #{options[:disabled].inspect}"
		return "" if !options[:validation]
		no = options[:number] || self.question.number.to_s 
		script = []
		if self.preferences # && self.preferences[:validation]
			errormsg = "Ugyldig værdi. Brug " << self.values.join(", ")
			script << "\t\t<script type='text/javascript'>"

			if self.preferences[:validation].respond_to? :size  # array
				script << "\nValidation.addAllThese([['#{self.cell_id(no)}', 'Værdi er ugyldig eller ikke udfyldt.', {\n"
				script << "  xOneOf : #{self.values.inspect},"
				script << "  oneOf : #{self.values.inspect},"
				validations = []
				self.preferences[:validation].each do |elem|  # array of tuples (hash-pairs)
					validations << elem.map { |k,v| "\n  #{k} : '#{v}'" }
				end
				script << validations.join(",")
				script << "\n}]]);\n"
			else
				script << "Validation.add('#{self.cell_id(no)}', '#{errormsg}', { xOneOf : #{self.values.inspect} } );"
			end        
			script << "\t\t</script>"
		end
		script.join
	end

end

class Checkbox < QuestionCell

  	def outer_span
  		s = span || 4
  		sp = "span-#{s}"
		if prespan
  			s -= prespan
  			sp << " prepend-#{prespan} "
  		end
  		sp
  	end
  	
  	def inner_span
		s = span || 4
  		sp = ""
  		if prespan
  			s -= prespan
  		end
  		sp << "span-#{s}"
  		sp
  	end

  	def fast_outer_span
  		"span-6"
  	end

  	def answer_inner_span
  		"span-8"
  	end

  	def to_answer(options = {})
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
		klass_name = "#{switch_target(options)} #{switch_source(options)}".strip
		klass_name = "class='#{klass_name}'" unless klass_name.empty?

		self.question_items.each do |item|
			label = "<label for='#{c_id}'>#{item.text}</label>"
			checkbox = "<input id='#{c_id}' name='#{question_no}[#{c_id}]' onclick='toggleCheck(this);' #{klass_name} type='checkbox' value='1' "
			checkbox += ((self.default_value || item.value).to_s == "1") ? "checked='checked' class='answer_value'>" : ">" # removed />
			checkbox += "<input name='#{question_no}[#{c_id}]' type='hidden' value='0' >" # removed />
			newform << checkbox + label
		end
		# outer_span = span && "span-#{span}" || "span-8"
		span_item(newform.join, outer_span)
  	end

	def create_form(options = {})
		form_template(options)
	end
  
	def form_template(options = {}) # value = nil, disabled = false, show_all = true)
		disabled = options[:disabled] ? "disabled" : nil
		answer   = options[:answers]
		show_all = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
		klass_name = "#{switch_target(options)} #{switch_source(options)}".strip
		klass_name = "" if klass_name == "{}"
		klass_name = "class='#{klass_name}'" unless klass_name.empty?

		self.question_items.each do |item|
			label = "<label for='#{c_id}'>#{item.text}</label>"
			checkbox = "<input id='#{c_id}' name='#{question_no}[#{c_id}]' onclick='toggleCheck(this);' #{klass_name} type='checkbox' value='1' #{disabled} "
			checkbox += (self.default_value) ? "checked='checked' >" : ">" # removed />
			checkbox += "<input name='#{question_no}[#{c_id}]' type='hidden' id='#{c_id}_h' value='0' >" # removed />
			newform << div_item(checkbox + label, "checkbox")
		end
		newform.join
	end

	def fast_input_form(options = {})
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
		klass_name = "#{switch_target(options)} #{switch_source(options)}".strip
		klass_name = "class='#{klass_name}'" unless klass_name.empty?

		self.question_items.each do |item|
			label = "<label for='#{c_id}'>#{item.text}</label>"
			checkbox = "<input id='#{c_id}' name='#{question_no}[#{c_id}]' #{klass_name} type='checkbox' value='1' #{disabled} "
			checkbox += ((value.nil? ? item.value.to_s : value.to_s) == "1") ? "checked='checked' />" : "/>"
			checkbox += "<input name='#{question_no}[#{c_id}]' type='hidden' value='0' >" # removed />
      	newform << self.add_validation(:validate => "checkbox", :number => no) if options[:validation]
		newform << div_item(checkbox + label, "checkbox #{fast_outer_span}")
		end
		div_item(newform.join, "checkbox span-8")
	end

	def validation_type
		"checkbox"
	end

	def values
		vals = ["0", "1"]
	end
end


class ListItemComment < QuestionCell

	def to_html(options = {})
		options[:target] = switch_target(options) unless switch_target.empty? or options[:switch_off]
		super(options)
	end

	def outer_span
		"span-6"
	end

	def fast_outer_span
    	outer_span
  	end
  	
  	def answer_span(last = false)
  		current_row_columns = question.question_cells.where(:row => self.row).count
  		span = self.span && "span-#{span}" || question.columns == 3 && "span-4" || "span-12"
  		if question.columns == 3 && current_row_columns < 3
  			span = "span-8"
  		end
  		span << " last" if last
  		span
  	end

  	def answer_inner_span
  		question.columns == 3 && "span-8" || "span-9"
  	end

	def to_answer(options = {})
		options[:span] = answer_span
		disabled   = options[:disabled] ? "disabled" : nil
		answer     = options[:answers] ? true : false
		show_all   = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast       = options[:fast] || false
		edit       = options[:edit] || false
		no         = options[:number].to_s || self.question.number.to_s 
		switch_off = options[:switch_off]
    	span 	   = self.span && "span-#{self.span}" || options[:outer_span] || answer_span

		c_id     = cell_id(no)
		newform = []
		question_no = "Q" + no
		answer_item = self.svar_item
		answer_item_set = false
		# answer_item_set = true if col > 1
		target = (fast or switch_off) ? "" : switch_target(options)

   		part = []
    
		self.question_items.each do |item|
		  listitem_without_predefined_text = item.text.nil? || item.text.empty?
		  case item.qtype
				# enable/disable button
			when "textbox" then 
				tcols = self.value && self.value.length > 200 && 120 || 40
				trows = self.value && self.value.length / 120
				current_row_columns = question.question_cells.where(:row => self.row).count
				box_span = (question.columns == 3 && current_row_columns >= 3) && "span-4" || "span-11"

				if (listitem_without_predefined_text)
					answer_val = self.value.blank? ? "" : "<div id='#{c_id}' class='comment answer_value'><span>#{CGI.unescape(self.value)}</span></div>"
					part << span_item(answer_item_set ? "" : answer_item, "span-1") if !answer_item_set || !answer_item.blank?
					part << span_item(answer_val, "itemtextbox #{box_span} #{target}".rstrip) unless answer_val.blank?
				else 
					part << span_item(answer_item_set ? "" : answer_item, "span-1") + span_item(item.text, "listitemtext #{box_span} #{target}".rstrip)
				end
			when "listitem" then 
				if (listitem_without_predefined_text)
					# part << span_item(answer_item_set && self.col > 2 ? "" : answer_item, "span-1")
					part << span_item("<span>" + CGI.unescape(self.value.to_s) + "</span>", "listitemfield answer_value #{span}")
				else 
					part << span_item(answer_item, "span-1")  #if !(self.col > 2)
					part << span_item(item.text, "listitem #{target} #{answer_inner_span}".strip)
				end
				answer_item_set = true;
				answer_item_set = true if self.col == 1
			when "itemunit" then 
        		# answer_item_set = true if self.col == 1
			  	newform <<
				span_item(((answer_item_set && self.col > 2) ? "" : answer_item) + 
					"#{self.value} #{item.text}", "unitfield answer_value #{span} #{target}")
			end
		end
		newform << span_item(part.join, answer_span)
		newform.join
  	end

	def self.to_answer(cols, options = {})
    	cells = cols.values.reverse
    	cell = cells.first
		answer_item = cell.svar_item
		no         = options[:number].to_s || cell.first.question.number.to_s 
    	span 	   = options[:outer_span] || cell.answer_span
		question_no = "Q" + no
		c_id     = cell.cell_id(no)

    	listitem = cells.first
    	rating = cells.last
		newform = []
		answer_item_set = false

		cell.question_items.each do |item|
			listitem_without_predefined_text = item.text.nil? || item.text.empty?
			case item.qtype
			when "textbox" then 
			when "listitem" then 
        		part = []		
				part << cell.span_item(answer_item, "span-1") if !(answer_item_set || cell.col > 2)
				part << cell.span_item(item.text, "listitem span-9".strip)
				# answer_item_set = true;
				# answer_item_set = true if cell.col == 1
				newform << cell.span_item(part.join, "span-11 listitem") # wrap

				rating_val = cell.span_item(rating.choice.get_options[rating.value], "span-10") 
				answer_val = cell.value.blank? ? "" : "<span class='span-9' id='#{c_id}' class='answer_comment'>#{cell.value}</span>"

				newform << if answer_val.blank?
					rating_val
				else
					cell.span_item(rating_val + "<br/>" + answer_val, "span-9")
				end
			end
		end
		newform.join
  	end


	def to_fast_input_html(options = {})
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
    	class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{fast_outer_span}" : " #{class_switch} #{fast_outer_span}" )
		"<div id='td_#{cell_id(options[:number])}' class='#{class_names}'>#{fast_input_form(options)}</div>"
	end

	def fast_input_form(options = {}, value = nil)
		no = options[:number] || self.question.number.to_s 
		options[:disabled] = true
		options[:show_all] = true
		options[:number] = no
		options[:fast] = true
		options[:hidden] = true
		c_id     = cell_id(no)

		comment_box = "<a href='#' onclick='return toggleComment(\"#{c_id}\");' >" <<
		"<img src='/assets/icon_comment.gif' border=0 title='Kommentar' alt='kommentar' class='' >" << # removed />
		"</a>" unless options[:answers]
		form = form_template(options) << comment_box.to_s
	end

	def form_template(options = {}) # value = nil, disabled = false, show_all = true)
		disabled   = options[:disabled] == "disabled" ? "disabled" : nil
		answer     = options[:answers] ? true : false
		show_all   = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast       = options[:fast] || false
		edit       = options[:edit] || false
		no         = options[:number].to_s || self.question.number.to_s 
		switch_off = options[:switch_off]
    	span 	   = options[:outer_span] || "span-9"

		c_id     = cell_id(no)
		newform = []
		question_no = "Q" + no
		answer_item = self.svar_item
		answer_item_set = false
		target = (fast or switch_off) ? "" : switch_target(options)
    
		self.question_items.each do |item|
		  listitem_without_predefined_text = item.text.nil? || item.text.empty?
		  case item.qtype
				# enable/disable button
			when "textbox" then 
				tcols = self.value && self.value.length > 200 && 120 || 40
				trows = self.value && self.value.length / 120
				newform << 
				if (listitem_without_predefined_text)
					input_or_answer = answer ?
					  (self.value.blank? ? "" : "<div id='#{c_id}' class='answer_comment'>#{self.value}</div>") :
					  "<textarea id='#{c_id}' name='#{question_no}[#{c_id}]' maxlength='2000' class='comment' cols='#{tcols}' rows='#{trows}' #{disabled ? ' disabled style="display:none;"' : ''}>#{self.value}</textarea>"
					div_item((answer_item_set ? "" : answer_item) + input_or_answer,
					"itemtextbox #{span} #{target}".rstrip)
				else div_item((answer_item_set ? "" : answer_item) + item.text, "listitemtext #{span} #{target}".rstrip)
				end
			when "listitem" then 
        		# answer_item_set = true if self.col == 1
			  	newform <<
				if (listitem_without_predefined_text)
					span_item(((answer_item_set && self.col > 2) ? "" : answer_item) + 
					"<textarea id='#{c_id}' name='#{question_no}[#{c_id}]' class='textfield' type='text' maxlength='2000' rows='1' value='#{item.value}'>#{self.value}</textarea>", "listitemfield #{span} #{target}")
				else div_item(((answer_item_set || self.col > 2) ? "" : answer_item) + item.text, "listitemtext #{span} #{target}".strip)
				end
				answer_item_set = true;
			when "itemunit" then 
        		# answer_item_set = true if self.col == 1
			  	newform <<
				span_item(((answer_item_set && self.col > 2) ? "" : answer_item) + 
					"<input id='#{c_id}' name='#{question_no}[#{c_id}]' class='textfield' type='text' maxlength='20' value='#{item.value}'>#{self.value}</input> #{item.text}", "unitfield #{span} #{target}")
			end
		end
		newform.join
	end
end

class Rating < QuestionCell

	def to_html(options = {})  # :fast => true, use fast_input_form
		onclick    = options[:onclick]
		switch_off = options[:switch_off]
		
		# todo switch target
		class_switch = switch_target(options) unless switch_off
		class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )
		klass_name = "class='#{class_names}'".rstrip unless class_name.blank? 

		colspan = "colspan='3'" if class_name == "rating4"  # not needed anymore?
		"<div #{colspan} id='td_#{cell_id(options[:number])}' #{onclick} #{klass_name}>#{form_template(options)}</div>"
	end

	def to_answer(options = {})
		if choice
			text = choice.get_options[self.value.to_s]
			if question.columns == 2 && datatype == :numeric
				span_item(text, "span-9 answer_value")
			elsif text && question.columns == 3 && datatype == :numeric
				in_span = "span-7 answer_value"
				in_span = case text.length
				when 1..3 then "span-1 answer_value"
				when 3..6 then "span-2 answer_value"
				else "span-7"
				end #if text
				span_item(text, in_span)
			elsif self.span
				span_item(text, "span-#{span} answer_value")
			else
				span_item("#{text}", "answer_value")
			end
		else
			span_item(value, "rating-tralala")
		end
	end

	def to_fast_input_html(options = {})  # :fast => true, use fast_input_form
		# todo switch target   # no switches in fast_input
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
    	class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{fast_outer_span}" : " #{class_switch} #{fast_outer_span}" )
		
    # klass_name = "class='#{class_name} #{fast_outer_span}'".rstrip unless class_name.empty?
		"<div id='td_#{cell_id(options[:number])}' class='#{class_names}'>#{fast_input_form(options)}</div>"
	end

  def outer_span(last = false)
    sp = case class_name
    when "rating3lab"  then "span-4"
    when "rating2lab1" then "span-3"
    when "rating3lab2" then "span-4"
    when "rating3lab3" then "span-3"
    when "rating3lab4" then "span-6"
    when "rating5lab4" then "span-6"
    when "rating4" then "span-12"
    when "rating3" then "span-9"
    when "rating7" then "span-16"
    # when "rating7": "span-16"
    else ""
    end
    sp << " last" if last
    sp << " prepend-#{prespan}" if prespan
    sp
  end
  
  def inner_span(last = false)
    sp = case class_name
    when "rating3lab"  then "span-1"
    when "rating2lab1" then "span-2"
    when "rating3lab2" then "span-3"
    when "rating3lab3" then "span-4"
    when "rating3lab4" then "span-4"
    when "rating5lab4" then "span-4"
    when "rating1" then "span-3"
    when "rating4" then "span-3"
    when "rating5" then "span-3"
    when "rating3" then "span-3"
    when "rating7" then "span-2_5"
    # when "rating7": "span-16"
    else
      "span-#{9 / [self.question_items.size, 3].max}"
    end
	sp << " prepend-#{prespan} " if prespan
    sp << " last" if last && question_items.size > 1
    sp
  end
  
  def fast_outer_span(last = false)
    sp = case class_name
    when "rating3lab"  then "span-4"
    when "rating2lab1" then "span-4"
    when "rating3lab2" then "span-4"
    when "rating3lab3" then "span-3"
    when "rating3lab4" then "span-3"
    when "rating5lab4" then "span-6"
    when "rating5" then "span-6"
    when "rating4" then "span-12"
    when "rating3" then "span-7"
    when "rating7" then "span-16"
    # when "rating7": "span-16"
    else ""
    end
    sp << " last" if last
    sp
  end
  
  def fast_inner_span(last = false)
    sp = case class_name
    when "rating5"  "span-7"
    when "rating2lab1" then "span-3"
    when "rating3lab"  then "prepend-1 span-3"
    else inner_span(last)
    end
  end
  
	def create_form_disabled
	end

	# if given value, set as checked, or already chosen value
	def form_template(options = {}) # value = nil, disabled = false, show_all = true)
		disabled = options[:disabled] ? true : false
		answer   = options[:answers]
		show_all = options[:show_all] && true || false
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		onclick  = options[:onclick] || "onclick='toggleRadio(this)'"
		no       = options[:number].to_s || self.question.number.to_s
		switch_off = options[:switch_off]
		c_id     = cell_id(no)

		newform = []
		question_no = "Q#{no}" # self.question.number.to_s
		checked = false

		q_items = self.question_items
		
		q_items.each_with_index do |item, i|
		  span = inner_span(q_items.size-1 == i)
			switch_src = (i > 0) ? switch_source(options) : "" # set switch on positive answers; 0 is 'no'
  		
			if show_all
				checked = (value == item.value ? 'checked="checked"' : nil)
				switch  = ((switch_src.blank? || switch_off) ? nil : "class='rating #{switch_src}'")
				disable = (disabled ? "disabled" : nil)
				# id = "id='#{c_id.strip}_#{i}'"
				newform << div_item(
				"<input id='#{c_id}_#{i}' #{onclick} name='#{question_no}[#{c_id}]' type='radio' value='#{item.value}' #{switch} #{disable} #{checked} >" + # removed />
				(item.text.blank? ? "" : "<label class='radiolabel' for='#{c_id}_#{i}'>#{item.text}</label>"), "radio #{span} #{(i+1)==q_items.length ? self.validation : ""}".rstrip)
			else # show only answers, not all radiobuttons, disabled
				newform << if value == item.value    # show checked radiobutton
          span_item("<input id='#{c_id}_#{i}' name='#{question_no}[#{c_id}]' type='radio' value='#{item.value}' checked='checked'" +
          					(disabled ? " disabled" : "") + " />" +
          					(item.text.empty? ? "" : "<label class='radiolabel' for='#{c_id}_#{i}'>#{item.text}</label>"), "radio #{span}")
				else     # spacing
					span_item(item.text.empty? ? "&nbsp;&nbsp;&nbsp&nbsp;&nbsp;" : div_item(item.text, "radiolabel"), "radio #{span}")
				end
			end
		end
		# default value, obsoleted. Default value is set when no value is given in create_cells
		if show_all
			newform << div_item("<input id='#{c_id}_9' name='#{question_no}[#{c_id}]' type='radio' value='9' #{checked ? '' : checked} style='display:none;' >",  # removed />
			"hidden_radio")
		end
		newform.join
	end  

	# TODO: like to_html but for fast
	def fast_input_form(options = {}, value = nil)  # 20-9 is value deprecated?
		disabled = options[:disabled] ? true : false
		show_all = options[:show_all].nil? || options[:show_all] #show_all = options[:show_all].nil? ? false : true
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		value    = options[:value] || nil
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no # self.question_no.number.to_s
		required = self.required? ? "required" : ""

		label = []
		switch_src = ""
		show_value = false
		self.question_items.each_with_index do |item, i|
			switch_src = (i > 0 && !fast) ? switch_source(options) : "" # set switch on positive answers; 0 is 'no'
			values << item.value
			show_value = true if(item.text.to_i == 0 and not ((item.text == "0") || (item.text == "1")))
			label << (show_value || (item.text.to_i == 0 and not ((item.text == "0") || (item.text == "1"))) ? ("<span>#{item.value} = #{item.text}</span>") : item.text) unless item.text.empty?
		end
		# if items.to_i has duplicates, they are probably 0's, meaning that they have text in them, not just numbers as values. When more than one text becomes 0, there's more than one not-integer text
		# shows text values, except where all item texts are numbers
		show_label = self.question_items.map { |item| item.text.to_i }.select {|i| i == 0}.size > 1
		newform = div_item((show_label ? label.map {|l| span_item(l, fast_inner_span)}.join : ""), "radiolabel") <<
		span_item(" <input id='#{c_id}' " <<
		"name='#{question_no}[#{c_id}]' class='rating #{required} #{switch_src} #{c_id}' type='text' #{(self.value.nil? ? "" : "value='" + self.value.to_s + "'")} size='2' >", "radio")  << # removed />
		"\n" << self.add_validation(options)
		return div_item(newform, "#{class_name} #{fast_inner_span}")
	end

	def values
		vals = self.question_items.collect { |item| item.value.to_s unless item.value.empty? }.compact.sort
		vals << "9"
	end

	def validation_type
		"oneOf"
	end  
end

class Description < QuestionCell

	def to_html(options = {})
		onclick    = options[:onclick]
		switch_off = options[:switch_off]

		sp 	 ||= outer_span(options[:last])
		sp 	   = options[:outer_span] || outer_span(options[:last])
		class_switch = switch_target(options) unless switch_off
    	class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{sp}" : " #{class_switch} #{sp}" )

		colspan = class_name.include?("description4lab4") && "colspan='3'" || ""
		id_class = id_and_class(options)
    
    	klass_name = class_name
    	fast = options[:fast] ? true : false
    	klass_name << (fast && "" || " " + switch_target(options))
	
    	"<div #{onclick} #{colspan} id='td_#{cell_id(options[:number])}' class='#{klass_name}'>#{form_template(options)}</div>"
	end

	def to_answer(options = {})
		onclick    = options[:onclick]
		switch_off = options[:switch_off]

		span 	   ||= outer_span(options[:last])
		outer_span   = span && "span-#{span}" || "span-#{outer_span(options[:last])}"
		class_switch = switch_target(options) unless switch_off
    	class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )

		colspan = class_name.include?("description4lab4") && "colspan='3'" || ""
		id_class = id_and_class(options)
    
    	klass_name = class_name
    	fast = options[:fast] ? true : false
    	klass_name << (fast && "" || " " + switch_target(options))
	
    	"<div #{onclick} #{colspan} id='td_#{cell_id(options[:number])}' class='#{klass_name}'>#{answer_template(options)}</div>"
	end

	def to_fast_input_html(options = {})  # :fast => true, use fast_input_form
		# todo switch target   # no switches in fast_input
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
    	class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{fast_outer_span}" : " #{class_switch} #{fast_outer_span(options[:last])}" )

		options[:outer_span] = fast_inner_span(options[:last])
		"<div id='td_#{cell_id(options[:number])}' class='#{class_names}'>#{fast_input_form(options)}</div>"
	end
	
	def answer_span(last = false)
		sp = question.columns == 3 && "span-8" || "span-12"
		sp << " prepend-#{prespan}" if prespan
		sp
	end

  	def outer_span(last = false)
    	sp = case class_name
    	when "description3lab"  then "span-4"
    	when "description2lab1" then "span-6"
    	when "description3lab2" then "span-9"
    	when "description3lab3" then "span-9"
    	when "description3lab4" then "span-12"
    	when "description5lab4" then "span-17"
    	when "description4" then "span-12"
    	when "description3" then "span-10"
    	when "description7" then "span-17"
    	  # when "rating7": "span-16"
    	else ""
    	end
    	sp << " last" if last
   	    sp << " prepend-#{prespan}" if prespan
   	    # puts "DESC: #{sp}"
    	sp
  	end
  
  # def outer_span(last = false)
  #   # puts "Class_name: #{class_name}"
  #   span = case class_name
  #   when /description3lab4/: "span-9"
  #   when /description4lab4/: "span-12"
  #   when /description5lab4/: "span-16"
  #   when /description7lab4/: "span-16"
  #   else "span-9"
  #   end
  #   span << " last" if last
  #   span
  # end
  
	def inner_span(no_items = 3, last = false)
	  span = no_items < 6 && "span-3" || "span-2_5"
	  span = "#{span} last" if last
	  # puts "desc span: #{span}"
	  span
	end
	
	def fast_outer_span(last = false)
	  span = case class_name
	  when "description3lab"  then "span-4"
	  when "description2lab1" then "span-6"
	  when "description3lab2" then "span-9"
	  when "description3lab3" then "span-9"
	  when "description3lab4" then
	    s = "prepend-1 "
	    s << (last && "span-7" || "span-6")
	  when "description4lab4" then "span-9"
	  when "description5lab4" then "span-7"
	  when "description7lab4" then "span-16"
	  when "description4" then "span-12"
	  when "description3" then "span-10"
	  when "description7" then "span-17"
	    # when "rating7": "span-16"
	  else ""
	  end
	  span << " last" if last
	  span
	end
	
	def fast_inner_span(items_size = 3, last = false)
	  span = case class_name
	  when "description7lab4" then "span-16"
	  else "span-7"
	  end
	end
  
	def form_template(options = {}) # value = nil, show_all = true, disabled = false)
		show_values = options[:show_values]
    	newform = []

		question_items.each_with_index do |item, i|
		  sp = if(options[:fast])
		    fast_inner_span(question_items.size, question_items.size-1 == i)
		  else
		    inner_span(question_items.size, question_items.size-1 == i)
	      end
	       	sp << " prepend-#{prespan}" if prespan
 
			text = if show_values
				span_item(item.value.nil? ? item.value : "#{item.value} = #{item.text}", sp)
			else
				div_item(item.text, sp)
			end
			newform << text
		end
		newform.join
	end

	def answer_template(options = {}) # value = nil, show_all = true, disabled = false)
		show_values = options[:show_values]
	    newform = []


	    if self.choice
	    	o_span = self.span && self.span || question.columns == 3 && 8 || 10
	   		newform << span_item(self.choice.full, "span-#{o_span}")
	    else
			desc = question_items.map { |item| span_item(item.text, "span-3") }
			newform << span_item(desc.join, "span-10")
		end
		newform.join
	end

	def fast_input_form(options = {})
	  div_item(form_template(options.merge({:show_values => true, :inner_span => fast_inner_span})), class_name)
	end
    
end


class TextBox < QuestionCell

	def outer_span(last = false)
    	aspan = "span-7"
    	aspan << " last" if last
    	aspan
  	end
  
  	def inner_span
    	"span-7"
  	end

  	def answer_span(last = false)
  		aspan = self.span && "span-#{span}" || "span-11"
  		aspan << " last" if last
  		aspan
  	end

  	def answer_inner_span
  		self.span && "span-#{self.span}" || "span-11"
  	end

  	def to_answer(options = {})
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)
  		self.value.blank? ? "" : "<span id='#{c_id}' class='#{answer_span} answer_value'><span>#{CGI.unescape(self.value)}</span></span>"
  	end

	def form_template(options = {}) # value = nil, show_all = true, disabled = false)
		disabled = options[:disabled] ? true : false
		answer   = options[:answers]
		show_all = options[:show_all].nil? || options[:show_all] #show_all = options[:show_all].nil? ? false : true
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)
    	span 	 = options[:outer_span] || "span-7"


		question_no = "Q" + no # self.question.number.to_s
    
		newform = []
		self.question_items.each do |item|
			if disabled
				newform << div_item(self.value, "itemtextbox #{span}")
			elsif answer
				newform << (self.value.blank? ? "" : "<div id='#{c_id}' class='#{span}'>#{self.value}</div>")
			else
				newform << div_item("<textarea id='#{c_id}' class='' name='#{question_no}[#{c_id}]' maxlength='2000' cols='38' rows='5'>#{self.value}</textarea>", "itemtextbox #{span}")
			end
		end
		newform.join
	end

	def fast_input_form(options = {})
		form_template(options.merge({:show_values => true}))
	end
end

class Boolean < QuestionCell

end
