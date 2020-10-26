module MixCredential
  has_config do
    attr_writer :available_types

    def available_types
      @available_types ||= {
        'Credentials::LetsEncrypt' => 10,
      }
    end
  end
end