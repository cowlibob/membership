module RenewalsHelper
	def s(tag, options = {})
		c = Content.where(tag: tag).first
		if current_admin_user.nil? && c.try(:content).nil?
			return tag
		elsif current_admin_user.nil?
			return c.content.html_safe
		else
			c ||= Content.create(tag: tag)
			return c.content.try(:html_safe) || "[[#{c.tag}]]" if options[:no_link]

			return link_to(c.content.try(:html_safe) || "[[#{c.tag}]]",
				"/admin/contents/#{c.id}/edit?modal=true",
				:class => 'editable_text',
				# 'data-reveal-id' => "textEditor",
				# 'data-reveal-ajax' => true,
				:target => '_blank')
		end
	end

	def mark_required(value)
		'data-required=true' if value
	end

end
