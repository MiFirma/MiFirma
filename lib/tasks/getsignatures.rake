task :getsignatures => :environment do
	Signature.get_all_signatures
	puts "Done!"
end