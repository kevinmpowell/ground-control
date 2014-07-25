require 'rspec/core/formatters/base_text_formatter'
require 'huey'

class HueFormatter < RSpec::Core::Formatters::BaseTextFormatter
  def dump_summary(duration, example_count, failure_count, pending_count)
    super(duration, example_count, failure_count, pending_count)

    bulb = Huey::Bulb.find(3)

    if failure_count > 0
      bulb.rgb = '#ff0000'
    else
      bulb.rgb = '#00ff7f'
    end
    bulb.commit
  end
end