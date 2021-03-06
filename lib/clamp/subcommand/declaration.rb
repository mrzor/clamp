require 'clamp/subcommand'

module Clamp
  class Subcommand

    module Declaration

      def recognised_subcommands
        @recognised_subcommands ||= []
      end

      def subcommand(name, description, subcommand_class = self, &block)
        has_subcommands!
        declare_subcommand(name, description, subcommand_class, &block)
      end

      def default_subcommand(name, description, subcommand_class = self, &block)
        subcommand(name, description, subcommand_class, &block)
        define_default_subcommand(name)
      end

      def has_subcommands?
        @has_subcommands
      end

      def find_subcommand(name)
        recognised_subcommands.find { |sc| sc.is_called?(name) }
      end

      def has_subcommands!(default = nil)
        @has_subcommands = true
        include Clamp::Subcommand::Execution
      end

      private

      def declare_subcommand(name, description, subcommand_class = self, &block)
        if block
          # generate a anonymous sub-class
          subcommand_class = Class.new(subcommand_class, &block)
        end
        recognised_subcommands << Subcommand.new(name, description, subcommand_class)
      end

      def define_default_subcommand(name)
        define_method("default_subcommand") do
          name
        end
      end

    end

  end
end
