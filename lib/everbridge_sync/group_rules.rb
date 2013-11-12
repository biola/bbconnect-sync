module EverbridgeSync
  class GroupRules
    def initialize(attributes, options = {})
      @file = options[:file] || 'config/group_rules.rb'

      @conditions = []
      @groups = []

      attributes.each do |attribute, values|
        values = Array(values)

        match_condition = ->(*compare_to) {
          @conditions << Array(compare_to).flatten.any? do |cmp|
            values.any?{ |value| value.to_s =~ /^#{cmp}/i }
          end
        }

        empty_condition = -> {
          @conditions << (values.join.strip == '')
        }

        define_singleton_method("if_#{attribute}_matches", match_condition)
        define_singleton_method("and_#{attribute}_matches", match_condition)
        define_singleton_method("if_#{attribute}_is_empty", empty_condition)
        define_singleton_method("and_#{attribute}_is_empty", empty_condition)
      end
    end

    def results
      instance_eval File.read(@file)

      @groups
    end

    private

    def add_to_group(group, &block)
      @conditions = []

      block.call

      @groups << group if @conditions.all?
    end
  end
end