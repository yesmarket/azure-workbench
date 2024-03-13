#!/bin/bash
sudo tailscale up --authkey=${auth_key} --advertise-connector --advertise-tags=${advertised_tags}
