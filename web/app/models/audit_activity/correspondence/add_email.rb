class AuditActivity::Correspondence::AddEmail < AuditActivity::Correspondence::Base
  has_one_attached :email_file
  has_one_attached :email_attachment

  def self.from(correspondence, investigation)
    activity = super(correspondence, investigation, self.build_body(correspondence))
    self.attachments(correspondence).each do |category, file|
      file.blob.metadata[:attachment_category] = category
      activity.send(category).attach file.blob
    end
  end

  def self.attachments correspondence
    {
        email_file: correspondence.find_attachment_by_category("email_file"),
        email_attachment: correspondence.find_attachment_by_category("email_attachment")
    }
    .reject { |_, value| value.nil? }
  end

  def attachments
    {
        email_file: email_file.attached? ? "email file" : nil,
        email_attachment: email_attachment.attached? ? "email attachment" : nil
    }
    .reject { |_, v| v.nil? }
  end

  def subtitle_slug
    "Email recorded"
  end

  def self.build_body correspondence
    body = ""
    body += self.build_correspondent_details correspondence
    body += "Subject: **#{correspondence.email_subject}**<br>" if correspondence.email_subject.present?
    body += "Date sent: **#{correspondence.correspondence_date}**<br>" if correspondence.correspondence_date.present?
    body += self.build_email_file_body correspondence
    body += self.build_attachment_body correspondence
    body += "<br>#{correspondence.details}" if correspondence.details.present?
    body
  end

  def self.build_correspondent_details correspondence
    return "" unless correspondence.correspondent_name || correspondence.email_address

    output = ""
    output += "#{correspondence.email_direction}: " if correspondence.email_direction.present?
    output += "**#{correspondence.correspondent_name}** " if correspondence.correspondent_name.present?
    output += self.build_email_address correspondence if correspondence.email_address.present?
    output
  end

  def self.build_email_file_body correspondence
    file = correspondence.find_attachment_by_category "email_file"
    file ? "Email: #{file.filename}<br>" : ""
  end

  def self.build_attachment_body correspondence
    file = correspondence.find_attachment_by_category "email_attachment"
    file ? "Attached: #{file.filename}<br>" : ""
  end

  def self.build_email_address correspondence
    output = ""
    output += '(' if correspondence.correspondent_name.present?
    output += correspondence.email_address
    output += ')' if correspondence.correspondent_name.present?
    output + "<br>"
  end
end
