# frozen_string_literal: true

class EmailService
  def initialize(
    to_email:,
    to_name:,
    template_id:,
    dynamic_attributes:,
    from_email: ENV.fetch('DEFAULT_EMAIL_FROM'),
    from_name: ENV.fetch('DEFAULT_EMAIL_NAME')
  )
    @to_email = to_email
    @to_name = to_name
    @template_id = template_id
    @dynamic_attributes = dynamic_attributes
    @from_email = from_email
    @from_name = from_name
  end

  def send
    SEND_IN_BLUE.send_transac_email(
      email
    )
  end

  private

  attr_reader :to_email,
              :to_name,
              :template_id,
              :dynamic_attributes,
              :from_name,
              :from_email

  def email
    SibApiV3Sdk::SendSmtpEmail.new(
      sender: { email: from_email, name: from_name },
      to: [{ email: to_email, name: to_name }],
      templateId: template_id,
      params: dynamic_attributes
    )
  end
end
