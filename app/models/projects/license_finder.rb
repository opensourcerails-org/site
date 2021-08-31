# frozen_string_literal: true

module Projects
  class LicenseFinder
    def self.from(text)
      return nil if text.nil?

      [text]
    end
  end
end
