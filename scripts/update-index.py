#!/usr/bin/env python3

import datetime
import json
import os
from jinja2 import Environment, FileSystemLoader

configs_path = '/opt/armbian-mirror/configs'

def load_mirrors_from_json():
  mirrors_path = 'mirrors.json'
  with open(mirrors_path, 'r') as f:
    return json.load(f)

def load_config_from_json(configs_path, config):
  with open('%s/%s' % (configs_path, config), 'r') as f:
    return json.load(f)

def load_configs_from_json(configs_path):
  for config in os.listdir(configs_path):
    yield load_config_from_json(configs_path, config)

def load_last_sync():
  try:
    with open('/var/run/armbian-mirror.last-sync', 'r') as f:
      epoch = int(f.read().rstrip())
      return datetime.datetime.fromtimestamp(epoch)
  except FileNotFoundError as e:
    return None

def save_html_to_file(html, path):
  with open(path, 'w') as f:
    f.write(html)

def main():
  if not os.path.exists(configs_path) or os.listdir(configs_path) == []:
    print("You must create a config file in %s for this mirror, and any other mirrors you host." % configs_path)
    return

  if not os.path.exists('%s/me' % configs_path):
    print("You must make a symbolic link from configs/me to this mirror's config file.")
    return

  this_mirror = load_config_from_json(configs_path, 'me')
  for repository in this_mirror['repositories']:
    if os.path.exists(repository['path']):
      bytes = sum(entry.stat().st_size for entry in os.scandir(repository['path']))
      print(bytes)
      repository['size_in_megabytes'] = bytes / (1024 * 1024)

  our_mirrors = []
  for config in load_configs_from_json(configs_path):
    if config['name'] == this_mirror['name']:
      continue
    our_mirrors.append(config)
  last_sync = load_last_sync()

  env = Environment(loader=FileSystemLoader('%s/templates' % this_mirror['path']))
  template = env.get_template('index.html')
  context = {
    'this_mirror': this_mirror,
    'our_mirrors': our_mirrors,
    'last_sync': last_sync
  }
  save_html_to_file(template.render(context), '%s/www/index.html' % this_mirror['path'])
  print('Updated %s/www/index.html' % this_mirror['path'])

if __name__ == '__main__':
  main()
