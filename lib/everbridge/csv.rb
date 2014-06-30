module Everbridge
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
      'DelGroup'        # 7
    ]

    # NOTE: DelGroup may not allow multiple columns, which would be a pain.
    # Needs to be tested further.
    DUPLICABLE_COLUMNS = ['Group', 'DelGroup']

    SINGLETON_COLUMNS = COLUMNS - DUPLICABLE_COLUMNS

    attr_reader :rows

    def initialize(file_paths)
      @file_paths = Array(file_paths)
      @rows = []
      @headers_written = false
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

    def flattened_columns
      cols = SINGLETON_COLUMNS

      DUPLICABLE_COLUMNS.each do |col|
        cols += ([col] * max_length(col))
      end

      cols
    end

    def max_length(field)
      @lengths ||= DUPLICABLE_COLUMNS.each_with_object({}) do |col, hash|
        hash[field] = rows.map{ |r| Array(r[col]).length }.max
      end

      @lengths[field].to_i
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
          cells += values

          cells += ([nil] * empty_cells)
        end

        cells
      end
    end
  end

  class Row
    def initialize(fields)
      @fields = fields
    end

    def [](key)
      col, val = fields.first { |k, _| match?(key, k) }

      val
    end

    private

    attr_reader :fields

    def match?(name_a, name_b)
      a, b = [name_a, name_b].map { |n| n.to_s.downcase.gsub(/[^a-z0-9]/, '').strip }
      a == b
    end
  end
end
