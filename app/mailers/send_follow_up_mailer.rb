class SendFollowUpMailer < ActionMailer::Base
  	default from: "tester@cbcl-sdu.dk"

  	def send_follow_up_letter(letter, email, from)
  		mail( 	:to => email,
  				:from => from,
				:subject => "CBCL opfølgningsbrev",
				:body => letter,
				:content_type => "text/html")
  	end

  	def test(letter = "hello, testing", email = "stamppot@gmail.com", from = "stamppot@gmail.com")
  		mail( 	:to => email,
  				:from => from,
				:subject => "CBCL opfølgningsbrev test",
				:body => letter,
				:content_type => "text/html")
  	end
end
