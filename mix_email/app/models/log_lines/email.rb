module LogLines
  class Email < LogLine
    json_attribute(
      mailer: :string,
      from: :string,
      to: :string,
      cc: :string,
      bcc: :string,
      subject: :string,
      sent: :boolean,
    )

    def self.push(log, message, sent: nil)
      json_data = { mailer: mailer(message), **header(message), sent: sent }
      text = json_data[:subject]
      label = { text_hash: text, text_tiny: text, text: text, level: :info }
      super(log, label: label, json_data: json_data)
    end

    def self.mailer(message)
      message.delivery_handler.name
    end

    def self.header(message)
      fields = message.header_fields.map{ |f| [f.name.underscore, f.field.to_s] }.to_h
      fields.slice('from', 'to', 'cc', 'bcc', 'subject').reject{ |_,v| v.blank? }.with_keyword_access
    end
  end
end