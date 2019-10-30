
# Remove this file and all conditionals referencing DEMO_MODE once
#  we are ready to remove the initial X number of freebies. Also move cost
#  constants back into Interview or we can make them dynamic via an admin console.

enable_demo_mode = ENV.fetch('ENABLE_DEMO_MODE') { false }
enable_demo_mode = ActiveModel::Type::Boolean.new.cast(enable_demo_mode)

NUM_FREE_INTERVIEWS = 3
ADDON_SEAT_PRICE = 250 # in cents
TRANSCRIPTION_PRICE = 499 # in cents
HARDWARE_ADDON_PRICE = 2499 # in cents
POSTING_PRICE = 799

if Rails.env.production? || enable_demo_mode
  DEMO_MODE = true
  REGULAR_COST = 1000
  WITH_HARDWARE_COST = 2500
else
	# NUM_FREE_INTERVIEWS = 0
  DEMO_MODE = false
  REGULAR_COST = 50 # this is the value in CENTS
  WITH_HARDWARE_COST = 50 # value in CENTS
end

EXPERTISES = YAML.safe_load(File.read(File.join(Rails.root, 'lib', 'tasks', 'expertises.yml')), [Symbol])
PROMOTIONS = YAML.safe_load(File.read(File.join(Rails.root, 'lib', 'tasks', 'promotions.yml')), [Symbol])
CATEGORIES = YAML.safe_load(File.read(File.join(Rails.root, 'lib', 'tasks', 'categories.yml')), [Symbol])
