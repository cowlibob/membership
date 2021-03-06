module Admin
  class RenewalsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Renewal.ordered_by_year.
    #     page(params[:page]).
    #     per(50)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    def find_resource(param)
      Renewal.find_by!(reference: param)
    end

    def scoped_resource
      Renewal.ordered_by_year
    end        

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
