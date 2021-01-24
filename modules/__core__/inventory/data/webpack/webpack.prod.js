const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = require("./webpack.common")({
  mode: "production",
  watchOptions: {
    poll: true,
    ignored: /node_modules/,
  },

  entry: [path.join(process.cwd(), "src/index.tsx")],

  plugins: [
    new HtmlWebpackPlugin({
      template: "src/index.html",
      minify: {
        removeComments: true,
        collapseWhitespace: true,
        removeRedundantAttributes: true,
        useShortDoctype: true,
        removeEmptyAttributes: true,
        removeStyleLinkTypeAttributes: true,
        keepClosingSlash: true,
        minifyJS: true,
        minifyCSS: true,
        minifyURLs: true,
      },
    }),
  ],

  performance: {
    assetFilter: (assetFilename) =>
      !/(\.map$)|(^(main\.|favicon\.))/.test(assetFilename),
  },
});
