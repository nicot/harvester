require '/home/jake/log_check/lib/sudomatcher'
# This file defines the global constant CONFIGS.
# CONFIGS is an array of configuration objects.
# files is an array of file paths

configs = []

# SUDO
sudo = Configuration.new
sudo.files.push('/home/jake/data/logs/sudo.log')
sudo.matchers.push(SudoMatcher)
configs.push(sudo)

CONFIGS = configs
