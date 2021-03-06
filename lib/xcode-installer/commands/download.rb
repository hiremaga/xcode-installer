require 'xcode-installer/download'

command :'download' do |c|
  c.syntax = 'xcode-installer download [options] [gui|cli]'
  c.option '--dry-run', 'Enables a HEAD request instead of downloading the file'
  c.option '--release STRING', 'Used to specify an old or pre-release version of Xcode. Otherwise, latest GA release of Xcode is downloaded.'
  c.option '--pre-release', 'Specifies to download the latest pre-release version of Xcode.'
  c.option '--show-progress', '(buggy) Displays a progress bar during the download. Only enabled if you specify this flag.'
  c.summary = 'Initiates the download of the Xcode .dmg file.'
  c.description = 'Specify "cli" to download command-line tools (gui is the default)'

  c.action XcodeInstaller::Download, :action
end
