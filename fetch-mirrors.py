#!/usr/bin/env python3

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

def save_mirrors(mirrors):
  with open('mirrors.json', 'w') as f:
    json.dump(mirrors, f)

def main():
  save_mirrors(get_mirrors())

if __name__ == '__main__':
  main()
