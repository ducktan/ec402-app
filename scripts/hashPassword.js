const bcrypt = require('bcrypt');

async function createHashedPassword() {
  const password = 'admin'; // Mật khẩu gốc
  const hashedPassword = await bcrypt.hash(password, 10);
  console.log('Mật khẩu đã hash:');
  console.log(hashedPassword);
}

createHashedPassword().catch(console.error);
