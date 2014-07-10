module BBConnect
  class CSV
    require 'csv'

    # Actions
    REMOVE  = '0'

    COLUMNS = [
      'ContactType',    # 0
      'ReferenceCode',  # 1
      'FirstName',      # 2
      'LastName',       # 3
      'EmailAddress',   # 4
      'Terminate',      # 5
      'Group',          # 6
      'DelGrp'        # 7
    ]

    # NOTE: DelGrp may not allow multiple columns, which would be a pain.
    # Needs to be tested further.
    DUPLICABLE_COLUMNS = ['Group', 'DelGrp']

    SINGLETON_COLUMNS = COLUMNS - DUPLICABLE_COLUMNS

    attr_reader :rows

    def initialize(file_paths)
      @file_paths = Array(file_paths)
      @rows = []
      @headers_written = false
    end

    def flattened_columns
      cols = SINGLETON_COLUMNS

      DUPLICABLE_COLUMNS.each do |col|
        cols += ([col] * max_length(col))
      end

      cols
    end

    def flattened_rows
      rows.map do |row|
        cells = []

        SINGLETON_COLUMNS.each do |col|
          cells << row[col]
        end

        DUPLICABLE_COLUMNS.each do |col|
          values = Array(row[col])
          empty_cells = (max_length(col) - values.length)
          empty_cells = 0 if empty_cells < 0
          cells += values

          cells += ([nil] * empty_cells)
        end

        cells
      end
    end

    def <<(fields)
      fields.merge! Settings.csv.defaults

      @rows << Row.new(fields)
    end

    def update(fields)
      self << fields
    end
    alias :add :update

    def remove(fields)
      self << fields.merge(terminate: REMOVE)
    end

    def save!
      flat_rows = flattened_rows

      file_paths.each do |file_path|
        ::CSV.open(file_path, 'w') do |csv|
          csv << flattened_columns

          flat_rows.each do |row|
            csv << row
          end
        end
      end
    end

    private

    attr_reader :file_paths

    def max_length(column)
      @lengths ||= DUPLICABLE_COLUMNS.each_with_object({}) do |col, hash|
        hash[col] = rows.map { |r| r[col].length }.max
      end

      @lengths[column].to_i
    end

    class Row
      COLUMN_ATTRIBUTE_MAP = {
        'ContactType' => :contact_type,
        'ReferenceCode' => :reference_code,
        'FirstName' => :first_name,
        'LastName' => :last_name,
        'EmailAddress' => :email_address,
        'Terminate' => :terminate,
        'Group' => :group,
        'DelGrp' => :del_group
      }

      def initialize(fields)
        @fields = COLUMNS.each_with_object({}) do |col, hash|
          value = fields[COLUMN_ATTRIBUTE_MAP[col]]

          hash[col] = if DUPLICABLE_COLUMNS.include? col
            Array(value)
          else
            value
          end
        end
      end

      def [](key)
        if key.is_a? Integer
          fields.values[key]
        else
          fields[key]
        end
      end

      private

      attr_reader :fields
    end
  end
end
