
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = require("./webpack.common")({
  mode: "production",

  // In production, we skip all hot-reloading stuff
  entry: [path.join(process.cwd(), "src/index.tsx")],

  plugins: [
    new HtmlWebpackPlugin({
      template: "public/index.html",
      minify: {
        minifyJS: true,
        minifyCSS: true,
        minifyURLs: true,
        removeRedundantAttributes: true,
        removeEmptyAttributes: true,
        collapseWhitespace: true
      },
      inject: "body",
    }),
  ],

  performance: {
    assetFilter: (assetFilename) =>
      !/(\.map$)|(^(main\.|favicon\.))/.test(assetFilename),
  },
});
