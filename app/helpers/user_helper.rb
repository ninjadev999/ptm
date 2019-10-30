module UserHelper

  def industry_options
    YAML.safe_load(File.read(File.join(Rails.root, 'lib', 'tasks', 'industries.yml')), [Symbol])
  end
end
