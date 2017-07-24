module.exports = {
  env: {
    atomtest: true,
    browser: true,
    commonjs: true,
    es6: true,
    jquery: true,
    mocha: true,
    node: true
  },
  extends: "eslint:recommended",
  globals: {
    atom: true,
    expect: true
  },
  parserOptions: {
    ecmaVersion: 8,
    sourceType: "script"
  },
  rules: {
    "linebreak-style": ["error", "unix"],
    quotes: ["error", "double"],
    semi: ["error", "always"],
    strict: ["error", "global"]
  }
};
