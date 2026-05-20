/** @type {import('next').NextConfig} */
const nextConfig = {
  // Erlaubt dem iPad und anderen Computern im Netzwerk das Laden von JavaScript
  experimental: {
    allowedDevOrigins: [
      "192.168.1.231", 
      "147.87.94.3",
      "localhost"
    ]
  }
};

export default nextConfig;

module.exports = nextConfig;