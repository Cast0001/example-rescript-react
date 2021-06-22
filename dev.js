import path from 'path'
import express from 'express'
import webpack from 'webpack'
import HtmlWebpackPlugin from 'html-webpack-plugin'
import webpackDevMiddleware from 'webpack-dev-middleware'
import MiniCssExtractPlugin from 'mini-css-extract-plugin'


const app = express()

const compiler = webpack({
  mode: 'development',
  cache: false,
  devtool: 'source-map',
  optimization: {
    minimize: false,
  },
  target: 'web',
  entry: path.resolve(__dirname, './src/index.js'),
  output: {
    publicPath: 'auto',
  },
  resolve: {
    extensions: ['.js'],
  },
  module: {
    rules: [
      {
        test: /\.scss$/i,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              esModule: true,
              publicPath: 'auto',
              modules: {
                namedExport: true,
              },
            },
          },
          {
            loader: 'css-loader',
            options: {
              modules: {
                namedExport: true,
                localIdentName: '[hash:base64:6]',
              },
              importLoaders: 2,
              sourceMap: true,
              esModule: true,
            },
          },
          {
            loader: 'postcss-loader',
            options: {
              sourceMap: true,
            },
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true,
            },
          }
        ],
      },
    ],
  },
  plugins: [
    new webpack.DefinePlugin({
      API_URL: JSON.stringify(process.env.DEPLOY_LIST_API_URL),
    }),
    new MiniCssExtractPlugin({
      filename: "[name].css",
    }),
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, "./index.html"),
    })
  ],
  devServer: {
    contentBase: path.join(__dirname, 'build'),
    compress: true,
    hot: true,
  }
})

app.use(webpackDevMiddleware(compiler))

app.listen(5000, () => {
  console.log(`Starting build on 5000 port`)
});
