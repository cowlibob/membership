module RenewalsHelper
	def duties_calendar_enabled?
		false
	end

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

	def sidebar_link(key:, url:)
		is_link = @renewal&.persisted?
		is_current_step = key == @renewal_step_with_override
		link_class = if is_current_step
			"flex flex-nowrap items-center p-2 text-gray-100 rounded-lg dark:text-white bg-gray-600 dark:bg-gray-300 group"
		else
			"flex flex-nowrap items-center p-2 text-gray-900 rounded-lg dark:text-white hover:bg-gray-200 dark:hover:bg-gray-700 group"
		end

		ERB.new(<<-HTML).result(binding).html_safe
			<li class="<%= link_class %> <%= 'active' if request.path == '#{url}' %>"
				  data-action="click->sidebar#toggle"
			>
				<%= link_to_if(is_link, I18n.t(key, scope: :sidebar, default: key), url) %>
			</li>
		HTML
	end

	def renewal_step_title
		path_stem = caller.first.match(/\/_(\w+).html.erb:/)[1]
		# path_stem = File.basename(__FILE__, '.html.erb').gsub(/\A_/, '').to_s
		I18n.t(path_stem, scope: :sidebar)
	end
end
