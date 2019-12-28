require('dotenv-safe').config()

const { join } = require('path')
// const brotliPlugin = require('brotli-gzip-webpack-plugin')
const webpack = require('webpack')
const htmlPlugin = require('html-webpack-plugin')

module.exports = {
  mode: process.env.NODE_ENV,
  entry: [
    '@babel/polyfill',
    join(__dirname, 'src', 'App.js')
  ],
  output: {
    path: join(__dirname, 'dist'),
    filename: 'build.js'
  },
  module: {
    rules: [{
      loader: 'babel-loader',
      test: /\.jsx?$/,
      exclude: /node_modules/,
      query: {
        presets: ['@babel/preset-env', '@babel/preset-react']
      }
    }, {
      test: /\.styl$/,
      exclude: /node_modules/,
      use: ['style-loader', {
        loader: 'css-loader',
        options: {
          importLoaders: 2
        }
      }, 'stylus-loader'],
    }, {
      test: /\.css$/,
      use: ['style-loader', 'css-loader'],
    }]
  },
  plugins: [
    new htmlPlugin({
        title: "Roshambo",
        template: './src/index.ejs',
        hash: true,
    }),
    // new brotliPlugin({
    //   asset: '[file].br[query]',
    //   algorithm: 'brotli',
    //   test: /\.(js|css|html|svg)$/,
    //   threshold: 10240,
    //   minRatio: 0.8,
    //   quality: process.env.NODE_ENV != 'production' ? 0 : 11,
    // }),
    // new brotliPlugin({
    //   asset: '[file].gz[query]',
    //   algorithm: 'gzip',
    //   test: /\.(js|css|html|svg)$/,
    //   threshold: 10240,
    //   minRatio: 0.8,
    //   quality: process.env.NODE_ENV != 'production' ? 0 : 11,
    // }),
    new webpack.DefinePlugin({
      PRIVATE_KEY_SHASTA: JSON.stringify(process.env.PRIVATE_KEY_SHASTA)
    })
  ]
}
