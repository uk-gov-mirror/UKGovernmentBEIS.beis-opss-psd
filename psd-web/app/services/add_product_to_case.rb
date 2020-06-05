class AddProductToCase
  include Interactor

  delegate :product, :investigation, :user, to: :context

  def call
    context.fail!(error: "No product supplied") unless product.is_a?(Product)
    context.fail!(error: "No investigation supplied") unless investigation.is_a?(Investigation)
    context.fail!(error: "No user supplied") unless user.is_a?(User)

    investigation.products << product

    context.activity = create_audit_activity_for_product_added

    send_notification_email
  end

private

  def create_audit_activity_for_product_added
    AuditActivity::Product::Add.create!(
      source: UserSource.new(user: user),
      investigation: investigation,
      title: product.name,
      product: product
    )
  end

  def send_notification_email
    context.activity.entities_to_notify.each do |recipient|
      email = recipient.is_a?(Team) ? recipient.team_recipient_email : recipient.email

      NotifyMailer.investigation_updated(
        investigation.pretty_id,
        recipient.name,
        email,
        "Product was added to the #{investigation.case_type} by #{context.activity.source.show(recipient)}.",
        "#{investigation.case_type.upcase_first} updated"
      ).deliver_later
    end
  end
end