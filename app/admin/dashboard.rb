ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
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
                    Renewal.recent.reverse.map do |renewal|
                        li link_to([renewal.primary_member.try(:full_name), "(#{renewal.created_at.strftime("%d/%m/%Y")})"].join(' '), admin_renewal_path(renewal))
                    end
                end
            end
        end
    end
  end # content
end
