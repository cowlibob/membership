class RenewalPaymentsController < ApplicationController
  def create
    @renewal = Renewal.find_by(reference: params[:renewal_id])

    setup_intent = @renewal.payment_processor
                           .create_setup_intent({
                                                  payment_method_types: ['card']
                                                })

    render json: { client_secret: setup_intent.client_secret }
  end

  def process_payment
    @renewal = Renewal.find(params[:renewal_id])
    payment_method = params[:payment_method_id]

    begin
      @renewal.payment_processor.charge(
        @renewal.total_cost * 100,
        currency: 'gbp',
        payment_method: payment_method
      )

      # @renewal.mark_as_paid!
      # RenewalNotificationMailer.renewal_payment_confirmation(@renewal).deliver

      render json: { success: true }
    rescue Pay::Error => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
