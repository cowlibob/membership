# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Content.create_or_update([
	{tag: 'duty comment', content: 'Preferred duty dates. The more you add, the more likely you get what you want.'},
	{tag: 'price - full membership', content: '140'},
	{tag: 'price - cadet membership', content: '58'},
	{tag: 'price - retained membership', content: '20'},
	{tag: 'price - honorary membership', content: '0'},
	{tag: 'tab - about you', content: 'About You'},
	{tag: 'tab - your address', content: 'Your Address'},
	{tag: 'tab - your family members', content: 'Your Family Members'},
	{tag: 'tab - your boats', content: 'Your Boats'},
	{tag: 'tab - your duties', content: 'Your Duties'}
	# {tag: '', content: ''},
]) rescue nil