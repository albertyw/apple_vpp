require "core_ext/string"

Dir[File.join(File.dirname(__FILE__), "apple_vpp", "**", "*.rb")].each { |file| require file }
