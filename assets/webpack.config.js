var path = require('path')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var CopyWebpackPlugin = require('copy-webpack-plugin')
var webpack = require('webpack')
var env = process.env.MIX_ENV || 'dev'
var isProduction = (env === 'prod')

module.exports = {
  entry: {
    'app': ['./js/index.js', './css/app.scss']
  },
  output: {
    path: path.resolve(__dirname, '../priv/static/'),
    filename: 'js/[name].js'
  },
  devtool: 'source-map',
  resolve: {
    extensions: ['.js', '.jsx'],
    alias: {
      phoenix: path.resolve(
        __dirname,
        "../deps/phoenix/assets/js/phoenix.js"
      )
    }
  },
  module: {
    rules: [{
      test: /\.(sass|scss)$/,
      include: /css/,
      use: ExtractTextPlugin.extract({
        fallback: 'style-loader',
        use: [
          {loader: 'css-loader'},
          {
            loader: 'sass-loader',
            options: {
              includePaths: [
                // add SASS dependencies here
              ],
              sourceComments: !isProduction
            }
          }
        ]
      })
    }, {
      test: /\.(js|jsx)$/,
      include: /js/,
      exclude: /(deps|node_modules)/,
      use: [
        {
          loader: 'babel-loader',
        }
      ]
    }, {
      test: /.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
      use: [{
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          outputPath: 'fonts/',
          publicPath: '../fonts/'
        }
      }]
    }, {
      test: /\.(jpe?g|png|gif|svg)$/,
      use: [
        {
          loader: 'url-loader',
          options: { limit: 40000 }
        },
        'image-webpack-loader'
      ]
    }]
  },
  plugins: [
    new CopyWebpackPlugin([{ from: './static' }]),
    new ExtractTextPlugin('css/app.css'),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery",
      Popper: ['popper.js', 'default']
    })
  ]
}