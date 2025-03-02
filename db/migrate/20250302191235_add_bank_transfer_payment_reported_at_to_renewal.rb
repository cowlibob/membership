class AddBankTransferPaymentReportedAtToRenewal < ActiveRecord::Migration[8.0]
  def change
    add_column :renewals, :bank_transfer_payment_reported_at, :timestamp
  end
end
