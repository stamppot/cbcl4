class SendFollowUpMailer < ActionMailer::Base
  	default from: "tester@cbcl-sdu.dk"

  	def send_follow_up_letter(letter, email, from)
  		mail( 	:to => email,
  				:from => from,
				:subject => "CBCL opfølgningsbrev",
				:body => letter,
				:content_type => "text/html",
				:delivery_method_options => {
       					api_key: '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'
     				})
  	end

  	def test(letter = "hello, testing", email = "stamppot@gmail.com", from = "stamppot@gmail.com")
  		mail( 	:to => email,
  				:from => from,
				:subject => "CBCL opfølgningsbrev test",
				:body => letter,
				:content_type => "text/html",
				:delivery_method_options => {
       					api_key: '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'
     				})
  	end
end
