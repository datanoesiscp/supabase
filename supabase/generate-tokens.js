const jwt = require('jsonwebtoken');

const JWT_SECRET = 'super-secret-jwt-key-for-development-only-32-chars';

// Generate ANON key
const anonToken = jwt.sign({
  role: 'anon',
  iss: 'supabase',
  iat: Math.floor(Date.now() / 1000),
  exp: Math.floor(Date.now() / 1000) + (10 * 365 * 24 * 60 * 60) // 10 years
}, JWT_SECRET);

// Generate SERVICE_ROLE key
const serviceToken = jwt.sign({
  role: 'service_role',
  iss: 'supabase',
  iat: Math.floor(Date.now() / 1000),
  exp: Math.floor(Date.now() / 1000) + (10 * 365 * 24 * 60 * 60) // 10 years
}, JWT_SECRET);

console.log('=== CORRECTED TOKENS ===');
console.log('ANON_KEY=' + anonToken);
console.log('');
console.log('SERVICE_ROLE_KEY=' + serviceToken);
console.log('========================');