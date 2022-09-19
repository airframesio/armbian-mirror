#!/usr/bin/env python3

import json
import os
from jinja2 import Environment, FileSystemLoader

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

def main():
  this_mirror = load_config_from_json('configs', 'me')
  our_mirrors = []
  for config in load_configs_from_json('configs'):
    if config['name'] == this_mirror['name']:
      continue
    our_mirrors.append(config)
  print(our_mirrors)

  env = Environment(loader=FileSystemLoader('templates'))
  template = env.get_template('index.html')
  context = {
    'this_mirror': this_mirror,
    'our_mirrors': our_mirrors,
  }
  print(template.render(context))

if __name__ == '__main__':
  main()
