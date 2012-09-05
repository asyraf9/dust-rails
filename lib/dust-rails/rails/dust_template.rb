require 'tilt'
require 'execjs'

module Dust
  module Rails

    module Source
      def self.path
        @path ||= File.expand_path('../../../../vendor/assets/javascripts/dust-full-for-compile.js', __FILE__)
      end

      def self.contents
        @contents ||= File.read(path)
      end

      def self.context
        @context ||= ExecJS.compile(contents)
      end

    end

    class DustTemplate < ::Tilt::Template

      def self.default_mime_type
        'application/javascript'
      end

      def prepare
      end

      def evaluate(scope, locals, &block)
        case Dust.config.naming_convention
        when 'file_name'
          template_name = scope.split('/').last.split('.').first
        when 'logical_path'
          template_name = scope.logical_path.to_s.gsub('"', "")
        else
          template_root = Dust.config.template_root
          template_name = file.split(template_root).last.split('.',2).first
        end
        
        Source.context.call("dust.compile", data, template_name)
      end
    end
  end
end


