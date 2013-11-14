ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end

    columns do
        column do
            panel "Members" do
                ul do
                    Member.all.map do |member|
                        li link_to(member.full_name, admin_member_path(member))
                    end
                end
            end
        end

        column do
            panel "Recent Renewals" do
                ul do
                    Renewal.recent.map do |renewal|
                        li link_to(renewal.primary_member.full_name, admin_renewal_path(renewal))
                    end
                end
            end
        end
    end
  end # content
end
