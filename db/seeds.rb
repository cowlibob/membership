# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[
	{tag: 'duty comment', content: 'Preferred duty dates. The more you add, the more likely you get what you want.'},
	{tag: 'price - full membership', content: '140'},
	{tag: 'price - cadet membership', content: '58'},
	{tag: 'price - retained membership', content: '20'},
	{tag: 'price - honorary membership', content: '0'},
	{tag: 'tab - about you', content: 'About You'},
	{tag: 'tab - your address', content: 'Your Address'},
	{tag: 'tab - your family members', content: 'Your Family Members'},
	{tag: 'tab - your boats', content: 'Your Boats'},
	{tag: 'tab - your duties', content: 'Your Duties'},
	{tag: 'insurance', content: 'Dinghies sailed and/or berthed at SVSC must have at least £2M third-party insurance.'},
	{tag: 'insurance label', content: 'I confirm my boats will be insured while at the club (berthed or sailing)'},
	{tag: 'commission label', content: 'I insure my boat(s) with Noble Marine (Insurance Brokers) Ltd and I allow SVSC to share my name, address, boat type and sail number with Noble Marine (Insurance Brokers) Ltd so that SVSC can claim a commission payment.'},
	{tag: 'data protection', content: 'By applying for membership you consent to your personal data being processed for the purposes of organising dinghy sailing and associated activities as set out in the SVSC Data Protection Policy to be found on the SVSC website (<a href="http://www.sheffieldviking.org.uk/members" target="_blank">www.sheffieldviking.org.uk</a>) or supplied on request from the Membership Secretary. Members have a right to ask for a copy of their information and to correct any inaccuracies and to change any preferences.'},
	{tag: 'declaration label', content: 'The above information is accurate and I will contact the membership secretary (<a href="mailto://membership@sheffieldviking.org.uk">membership@sheffieldviking.org.uk</a>) if any details change.'},
	# {tag: '', content: ''},
].each do |data|
	c = Content.find_by_tag(data[:tag]) || Content.create(data)
	puts "#{c.tag}, #{c.id}, #{c.content}"
end