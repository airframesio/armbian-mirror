#!/usr/bin/env python3

import argparse
import http
import json
import requests

def get_json(url):
  response = requests.get(url)
  response.raise_for_status()
  return response.json()

def image_mirrors():
  return get_json('http://redirect.armbian.com/mirrors')

def package_mirrors():
  return get_json('http://apt.armbian.com/mirrors')

def archives_mirrors():
  return get_json('http://archive.armbian.com/mirrors')

def beta_mirrors():
  return get_json('http://beta.armbian.com/mirrors')

def get_mirrors():
  return {
      'images': image_mirrors(),
      'packages': package_mirrors(),
      'archives': archives_mirrors(),
      'beta': beta_mirrors(),
  }

def save_mirrors(mirrors, path):
  with open(path, 'w') as f:
    json.dump(mirrors, f)

def main():
  parser = argparse.ArgumentParser(description='Fetch Armbian mirrors')
  parser.add_argument('--output', type=str, help='Output mirrors to file')
  args = parser.parse_args()

  mirrors_file = args.output or 'mirrors.json'
  save_mirrors(get_mirrors(), mirrors_file)

if __name__ == '__main__':
  main()
