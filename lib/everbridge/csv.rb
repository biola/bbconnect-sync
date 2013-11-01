module Everbridge
  class CSV
    require 'csv'

    # Actions
    ADD     = 'A'
    UPDATE  = 'U'
    REMOVE  = 'D'

    MANDATORY_FIELD_VALUES = { end: 'END' }

    COLUMNS = [
      "Action",                         # 0
      "First Name",                     # 1
      "Middle Init.",                   # 2
      "Last Name",                      # 3
      "Suffix",                         # 4
      "Organization",                   # 5
      "Address",                        # 6
      "Address 2",                      # 7
      "Address 3",                      # 8
      "City",                           # 9
      "State/Province",                 # 10
      "Postal Code",                    # 11
      "Country",                        # 12
      "Role",                           # 13
      "Language",                       # 14
      "External Id",                    # 15
      "Account Code",                   # 16
      "Member Pin Number",              # 17
      "Assistant Phone",                # 18
      "Assistant Phone Country",        # 19
      "Assistants Phone Ext",           # 20
      "Business Phone",                 # 21
      "Business Phone 2",               # 22
      "Business Phone 2 Country",       # 23
      "Business Phone 3",               # 24
      "Business Phone 3 Country",       # 25
      "Business Phone 4",               # 26
      "Business Phone 4 Country",       # 27
      "Business Phone Country",         # 28
      "Business Phone Ext",             # 29
      "Business Phone Ext 2",           # 30
      "Business Phone Ext 3",           # 31
      "Business Phone Ext 4",           # 32
      "E-mail Address",                 # 33
      "E-mail Address 2",               # 34
      "E-mail Address 3",               # 35
      "Fax 1",                          # 36
      "Fax 1 Country",                  # 37
      "Fax 2",                          # 38
      "Fax 2 Country",                  # 39
      "Fax 3",                          # 40
      "Fax 3 Country",                  # 41
      "Home Phone",                     # 42
      "Home Phone 2",                   # 43
      "Home Phone 2 Country",           # 44
      "Home Phone Country",             # 45
      "IM System",                      # 46
      "Instant Messaging",              # 47
      "International Phone 1",          # 48
      "International Phone 2",          # 49
      "International Phone 3",          # 50
      "International Phone 4",          # 51
      "International Phone 5",          # 52
      "Mobile Phone",                   # 53
      "Mobile Phone 2",                 # 54
      "Mobile Phone 2 Country",         # 55
      "Mobile Phone 2 Provider",        # 56
      "Mobile Phone 3",                 # 57
      "Mobile Phone 3 Country",         # 58
      "Mobile Phone 3 Provider",        # 59
      "Mobile Phone Country",           # 60
      "Mobile Phone Provider",          # 61
      "Numeric Pager",                  # 62
      "One Way Pager Limited",          # 63
      "One Way Pager Unlimited",        # 64
      "Oneway SMS Device",              # 65
      "Oneway SMS Device Country",      # 66
      "Other Phone",                    # 67
      "Other Phone Country",            # 68
      "Pager Pin #",                    # 69
      "SMS Device 1",                   # 70
      "SMS Device 1 Country",           # 71
      "SMS Device 2",                   # 72
      "SMS Device 2 Country",           # 73
      "Tap",                            # 74
      "Tap Country",                    # 75
      "Text Device Limited",            # 76
      "Text Device Unlimited",          # 77
      "TTY/TDD 1",                      # 78
      "TTY/TDD 1 Country Calling Code", # 79
      "TTY/TDD 2",                      # 80
      "TTY/TDD 2 Country Calling Code", # 81
      "TTY/TDD 3",                      # 82
      "TTY/TDD 3 Country Calling Code", # 83
      "Numeric Pager Country",          # 84
      "TAP Pager PIN",                  # 85
      "Escalate First Name 1",          # 86
      "Escalate Middle Init 1",         # 87
      "Escalate Last Name 1",           # 88
      "Escalate Suffix 1",              # 89
      "Escalate First Name 2",          # 90
      "Escalate Middle Init 2",         # 91
      "Escalate Last Name 2",           # 92
      "Escalate Suffix 2",              # 93
      "Escalate First Name 3",          # 94
      "Escalate Middle Init 3",         # 95
      "Escalate Last Name 3",           # 96
      "Escalate Suffix 3",              # 97
      "Member of Group 1",              # 98
      "Member of Group 2",              # 99
      "Member of Group 3",              # 100
      "Leader of Group 1",              # 101
      "Leader of Group 2",              # 102
      "Leader of Group 3",              # 103
      "Contract Number",                # 104
      "Contract Plan Name",             # 105
      "Groups",                         # 106
      "Leaders",                        # 107
      "Remove Groups",                  # 108
      "Remove Group Leaders",           # 109
      "User Attribute Field Name 1",    # 110
      "User Attribute Value 1",         # 111
      "User Attribute Field Name 2",    # 112
      "User Attribute Value 2",         # 113
      "User Attribute Field Name 3",    # 114
      "User Attribute Value 3",         # 115
      "User Attribute Field Name",      # 116
      "User Attribute Value",           # 117
      "User Attribute Field Name",      # 118
      "User Attribute Value",           # 119
      "User Attribute Field Name",      # 120
      "User Attribute Value",           # 121
      "User Attribute Field Name",      # 122
      "User Attribute Value",           # 123
      "User Attribute Field Name",      # 124
      "User Attribute Value",           # 125
      "User Attribute Field Name",      # 126
      "User Attribute Value",           # 127
      "User Attribute Field Name",      # 128
      "User Attribute Value",           # 129
      "END"                             # 130
    ]

    attr_reader :rows

    def initialize
      @rows = []
    end

    def <<(fields)
      fields.merge! Settings.csv.defaults
      fields.merge! MANDATORY_FIELD_VALUES

      row = COLUMNS.map do |column|
        field = fields.find { |field_name, value| field_names_match?(column, field_name) }
        value = (field.last unless field.nil?)

        value.respond_to?(:join) ? value.join('|') : value
      end

      @rows << row
    end

    def add(fields)
      self << fields.merge(action: ADD)
    end

    def update(fields)
      self << fields.merge(action: UPDATE)
    end

    def remove(fields)
      self << fields.merge(action: REMOVE)
    end

    def save!(file_path)
      ::CSV.open(file_path, 'w') do |csv|
        csv << COLUMNS

        @rows.each do |row|
          csv << row
        end
      end

      file_path
    end

    private

    def field_names_match?(name_a, name_b)
      a, b = [name_a, name_b].map { |n| n.to_s.downcase.gsub(/[^a-z0-9]/, '').strip }
      a == b
    end
  end
end