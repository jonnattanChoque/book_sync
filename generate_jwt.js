const fs = require("fs");
const jwt = require("jsonwebtoken");

// Sustituye con la ruta exacta a tu archivo .p8 descargado
const privateKey = fs.readFileSync(
  "/Users/jonnattanchoque/Downloads/AuthKey_A923RT7F4U.p8",
);

const teamId = "8H49FPJANP"; // Tu Team ID de Apple (10 caracteres)
const keyId = "A923RT7F4U"; // Tu Key ID de Apple (10 caracteres)
const clientId = "com.twon.bookSync"; // Tu Services ID / Bundle ID

const token = jwt.sign({}, privateKey, {
  algorithm: "ES256",
  expiresIn: "180d", // Validez máxima permitida por Apple (6 meses)
  audience: "https://appleid.apple.com",
  issuer: teamId,
  subject: clientId,
  keyid: keyId,
});

console.log("\n================ TU JWT SECRET KEY ================");
console.log(token);
console.log("===================================================\n");
