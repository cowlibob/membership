class ChargeSucceededProcessor
  def call(event)
    pay_charge = Pay::Stripe::Charge.sync(event.data.object.id, stripe_account: event.try(:account))
    renewal = Renewal.find_by(reference: pay_charge.metadata[:renewal_reference])
    if renewal.present?
      Rails.logger.info("Charge Succeeded Webhook: #{renewal.id} #{renewal.primary_member.email}")
      renewal.mark_as_paid!
      RenewalNotificationMailer.renewal_payment_confirmation(renewal).deliver
    else
      Rails.logger.error("Charge Succeeded Webhook: Renewal not found for #{pay_charge.metadata[:renewal_reference]}")
    end
  end
end
