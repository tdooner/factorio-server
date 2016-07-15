directory '/usr/factorio'
directory '/etc/factorio'

remote_file '/tmp/factorio' do
  source 'https://www.factorio.com/get-download/0.13.8/headless/linux64'
  notifies :run, 'execute[extract_factorio]', :immediately
end

execute 'extract_factorio' do
  command 'tar -C /usr/factorio --strip-components=1 -xvf /tmp/factorio'
  action :nothing
end

git '/opt/factorio-init' do
  repository 'https://github.com/Bisa/factorio-init.git'
  revision '29f53fc18b43316082d8551794a7fe28e3962d89'
end

cookbook_file '/lib/systemd/system/factorio.service' do
  notifies :run, 'execute[systemctl daemon-reload]'
end

cookbook_file '/etc/factorio/init-config' do
  path '/opt/factorio-init/config'
end
cookbook_file '/etc/factorio/server-settings.json'

execute 'systemctl daemon-reload' do
  action :nothing
end

execute '/usr/factorio/bin/x64/factorio --create /usr/factorio/saves/my_savegame' do
  creates '/usr/factorio/saves/my_savegame.zip'
end

# start the server once, so it outputs the default config.ini
execute 'timeout 5 /usr/factorio/bin/x64/factorio --start-server-load-latest || true' do
  creates '/usr/factorio/config/config.ini'
end

service 'factorio' do
  action [:enable, :start]
end
