module.exports = {
    filenameHashing: false,
    configureWebpack: {
        optimization: {
            splitChunks: false
        },
        performance: {
            hints: false,
            // These are set higher than recommended to suppress warnings during the build.
            // Yeah, it's better to try and keep things small, but I feel it's still small enough right now, so increase the limit.
            maxEntrypointSize: 512000,
            maxAssetSize: 512000
        }
    }
}