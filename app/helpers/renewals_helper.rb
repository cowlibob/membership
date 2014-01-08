module RenewalsHelper
	def s(tag)
		c = Content.first(:conditions => {:tag => tag})
		if current_admin_user.nil? && c.nil?
			return tag
		elsif current_admin_user.nil?
			return c.content.html_safe
		else
			c ||= Content.create(:tag => tag)
			return link_to(c.content.try(:html_safe) || "[[#{c.tag}]]",
				"/admin/contents/#{c.id}/edit?modal=true",
				:class => 'editable_text',
				# 'data-reveal-id' => "textEditor",
				# 'data-reveal-ajax' => true,
				:target => '_blank')
		end
	end
end
