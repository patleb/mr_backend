module ExtRake
  TASK =      '[TASK]'.freeze
  STEP =      '[STEP]'.freeze
  STARTED =   '[STARTED]'.freeze
  COMPLETED = '[COMPLETED]'.freeze
  FAILED =    '[FAILED]'.freeze
  DONE =      '[DONE]'.freeze
  CANCEL =    '[CANCEL]'.freeze

  class Engine < Rails::Engine
    require 'mix_rescue'
    require 'ext_rake/rake/dsl'
    require 'ext_rake/rake/task'
  end
end
