module.exports = {
  devServer: {
    // Railsにアクセスするためのポートを指定する
    proxy: "http://localhost:3000",
  },
};
