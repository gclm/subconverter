import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import * as path from "path";

export default defineConfig({
  plugins: [
    vue()
  ],
  server: {
    port: 8080
  },
  resolve: {
    extensions: [".mjs", ".js", ".ts", ".jsx", ".tsx", ".json", ".vue"],
    alias: [
      {
        find: "@",
        replacement: path.resolve(__dirname, "src")
      },
      {
        find: "assets",
        replacement: path.resolve(__dirname, "src/assets")
      },
      {
        find: "components",
        replacement: path.resolve(__dirname, "src/components")
      },
      {
        find: "views",
        replacement: path.resolve(__dirname, "src/views")
      },
      {
        find: "network",
        replacement: path.resolve(__dirname, "src/network")
      }
    ]
  }
});
