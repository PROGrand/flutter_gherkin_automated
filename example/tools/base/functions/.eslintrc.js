module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "quotes": ["error", "double"],
    "max-len": "off",
    "require-jsdoc": "off",
  },
  parserOptions: {
    "ecmaVersion": 2020,
  },
  globals: {
    "describe": "readonly",
    "it": "readonly",
    "before": "readonly",
    "beforeEach": "readonly",
    "beforeAll": "readonly",
    "after": "readonly",
    "afterEach": "readonly",
    "afterAll": "readonly",
  },
};
