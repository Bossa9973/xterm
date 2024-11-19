#!/bin/bash

# Exit on error
set -e

# Update package list and install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Create project directory
echo "Setting up xterm.js project..."
mkdir -p /opt/xterm-app
cd /opt/xterm-app

# Initialize npm project
npm init -y

# Install xterm.js and express
npm install xterm express

# Create basic server
cat > server.js << 'EOF'
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve xterm.js assets
app.use('/xterm', express.static(path.join(__dirname, 'node_modules/xterm/dist')));

// Serve static HTML
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
EOF

# Create basic HTML file
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>xterm.js Example</title>
  <link rel="stylesheet" href="/xterm/xterm.css">
</head>
<body>
  <div id="terminal" style="width: 100%; height: 100vh;"></div>
  <script src="/xterm/xterm.js"></script>
  <script>
    const term = new Terminal();
    term.open(document.getElementById('terminal'));
    term.write('Welcome to xterm.js!\r\n');
  </script>
</body>
</html>
EOF

# Expose port for Render
echo "PORT=3000" > .env

echo "Setup complete. You can now run 'node server.js' to start the server."
