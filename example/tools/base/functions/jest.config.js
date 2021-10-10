module.exports = {
  testRegex: "(./test/.*|(\\.|/)(test|spec))\\.[jt]sx?$",
  testPathIgnorePatterns: ["lib/", "node_modules/", "helpers/"],
  moduleFileExtensions: ["js", "ts", "tsx", "jsx", "json", "node"],
  testEnvironment: "node",
  rootDir: ".",
};
