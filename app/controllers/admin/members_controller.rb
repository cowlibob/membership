module Admin
  class MembersController < Admin::ApplicationController
    include ActionView::Helpers::UrlHelper
    def index
      params[:year] ||= Time.zone.now.year
      @year = if params[:year] == 'all'
                nil
              else
                params[:year].to_i
              end
      @years_collection = ((Date.today.year - 10..Date.today.year).map do |year|
        [year, year]
      end).reverse.unshift(['All', :all])

      respond_to do |format|
        format.html do
          find_members
        end
        format.csv do
          find_members(paginate: false)
          send_data @members.to_csv, filename: "members-#{Date.today}.csv"
        end
      end
    end

    def show
      @member = Member.find(params[:id])
    end

    def update
      @member = Member.find(params[:id])
      
      if @member.update(member_params)
        redirect_to admin_member_path(@member), notice: 'Member was successfully updated.'
      else
        render :show, status: :unprocessable_entity
      end
    end

    def soft_delete
      notice = error = nil
      member = Member.find(params[:id])
      if member.primary?
        error = "Primary member #{member} cannot be deleted. Please delete the renewal instead."
      elsif member&.update_attribute(:deleted, true)
        link = undelete_admin_member_path(member.id, request.query_parameters)
        notice = "Member for #{member} was successfully deleted. #{button_to('Undo', link, method: :patch,
                                                                                           class: 'text-red-500')}".html_safe
      elsif member.present?
        error = "Member for #{member} could not be deleted: #{member.errors.full_messages.to_sentence}"
      else
        error = 'Member could not be found.'
      end

      redirect_to admin_members_path(request.query_parameters), notice: notice, error: error
    end

    def undelete
      notice = error = nil
      member = Member.find(params[:id])
      if member&.update_attribute(:deleted, false)
        notice = "Member for #{member} was successfully restored."
      elsif member.present?
        error = "Member for #{member} could not be restored: #{member.errors.full_messages.to_sentence}"
      else
        error = 'Member could not be found.'
      end

      redirect_to admin_members_path(request.query_parameters), notice: notice, error: error
    end

    private

    def member_params
      params.require(:member).permit(:first_name, :last_name, :email, :phone)
    end

    def find_members(paginate: true)
      scope = Member.not_deleted
      scope = scope.joins(:renewal).where(renewals: { deleted: false })
      scope = scope.where("date_part('year', members.created_at) = ?", @year) if @year.present?
      scope = scope.order('members.renewal_id DESC, members.primary DESC')

      @members = if paginate
                   scope.paginate(page: params[:page], per_page: 10)
                 else
                   scope
                 end
    end
  end
end
