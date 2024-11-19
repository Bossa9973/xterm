#!/bin/bash

# Exit on error
set -e

# Navigate to the application directory
cd /opt/xterm-app

# Install dependencies
npm install

# Build and start the server
npm run build || true
