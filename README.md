# Rails + Vue.js - Webpacker

Webpacker being a problem? Can't get your favorite Javascript framework to play nice? Want your backend and frontend more separated, but still contained within the same Rails app and repo?

Why not avoid webpacker? Lets do it by building the Javascript app for production, and copying it to the Rails `assets` directories so that Sprockets will pick it up and things like `assets:precompile` will work nicely. Oh, and lets run Rails and the JS app on separate ports during development. Read on...

## I want to clone this and run it now.
1. Clone it to your localhost. Install yarn and ruby however you wish.
2. `cd rails-vue-no-webpacker`
3. `bundle install`
4. `cd frontend; yarn install; cd ..`
5. `foreman start`
6. Visit [localhost:8080](http://localhost:8080) in your browser.


## Howto

- For this example, I ran `rails new rails-vue-no-webpacker --skip-webpack-install --skip-javascript --skip-turbolinks -T` to create the rails app.
  
- Add back the bare minimum to get Javascript and Sprockets to play nice.
    - `mkdir -p app/assets/javascripts`
    - `echo '//= require_tree .' > app/assets/javascripts/application.js`
    - `echo '//= link_directory ../javascripts .js' >> app/assets/config/manifest.js`
    - Add `<%= javascript_include_tag 'application' %>` to `app/views/application.html.erb`. Either after the `stylesheet_link_tag` or at the bottom of the `<body>` tag.
  
- Add `rack-cors` gem to the Gemfile, `bundle install` and create `config/initializers/cors.rb` with the following config:
    ```
    # This adds CORS headers to the response. Useful for developing frontend code with 'yarn serve'
    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:8080'
        resource '*',
        headers: :any,
        methods: %i(get post put patch delete options head)
      end
    end
    ```

- Create a `Frontends` controller with a blank `index` action. Add `<div id="app"></div>` to its `index.html.erb` file.

- Add some routes. Set the `root` to `frontends#index`. Also add a catch-all that will redirect any unknown routes to the `frontends#index` endpoint so that Vue can take over.
    ```
    root 'frontends#index'

    # Any unknown path will redirect and let Vue take over.
    get '*path' => 'frontends#index'
    ```

- Create your Javascript frontend. Vue.js is used for this example.
  - `yarn global add @vue/cli`
  - `vue create frontend`

- `cd frontend` and edit `package.json` adding these new commands to the `scripts` section:
    ```
    "build-for-rails": "vue-cli-service build && yarn delete-old && yarn copy-js && yarn copy-css && yarn copy-img",
    "copy-js": "cp -f ./dist/js/app.js ../app/assets/javascripts/",
    "copy-css": "cp -f ./dist/css/app.css ../app/assets/stylesheets/",
    "copy-img": "mkdir -p ../public/assets/images && cp -f ./dist/assets/images/* ../public/assets/images/ 2>/dev/null || :",
    "delete-old-js": "cd ../app/assets/javascripts/; ls | grep -v application.js | xargs rm; cd -",
    "delete-old-css": "cd ../app/assets/stylesheets/; ls | grep -v application.css | xargs rm; cd -",
    "delete-old": "yarn delete-old-js && yarn delete-old-css"
    ```

- Change the ID of the top level `div` in `App.vue` to `container`. Be sure to change the `#app` to `#container` in the `<style>` section. I had to do this due to naming conflicts with the `div` in the Rails template. 
  
- Chunking and hashing are nice features, but we don't want them in our production build Vue app, so disable them. Create a file named `vue.config.js` containing this:
    ```
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
    ```
- Don't forget to add the built files from Vue in the Rails assets folder to `.gitignore`. Don't want to commit those (or maybe you do. I don't).
    ```
    # Ignore production builds from Vue.
    app/assets/javascripts/app.js
    app/assets/stylesheets/app.css
    ```

## Running things

- `rails s` to run the Rails backend. You can access it with `localhost:3000` as usual. Visiting this at this point should give you a blank page.
  
- `yarn serve` within the `frontend` directory. You can access it with `localhost:8080`. Visiting this at this point should give you the boilerplate Vue welcome page.
  
- `yarn build-for-rails` and then run `rails s` and visit `localhost:3000` again and now you should see the same Vue welcome page.
  
- Magic, right? But you don't want to run the `build-for-rails` command everytime you make a change do you? Didn't think so.
  
- Let's add the `foreman` gem, `bundle install`, and create a `Procfile` with the following:
    ```
    backend: rails server -p 3000
    frontend: yarn --cwd ./frontend serve --port 8080
    ```

- Now all you have to run is `foreman start` in one terminal for development purposes. You only need to visit `localhost:8080` while developing. And you get the hot reload of Vue built right in. Neat? You bet.

## A less boring example

- Add an `Examples` controller with an `index` action. Just generate some random values with the `faker` gem and `render json` right there. Don't forget to add a route in `routes.rb`. See `app/controllers/examples_controller.rb` for the code.
  
- In the Vue app, `yarn add axios`.

- Create a directory named `services` and a file in that directory named `backend.js`. We need to toggle our URL based on dev vs prod environment. Add this to it: 
    ```
    import axios from 'axios'

    export default() => {
        // When running 'yarn serve', point our baseURL to the rails backend, hopefully running on 3000
        let url = ''
        if (process.env.NODE_ENV !== 'production') {
            url = 'http://localhost:3000'
        }

        return axios.create({
            baseURL: `${url}/`,
            withCredentials: false,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
    }
    ```

- Create a new component named Example as `components/Example.vue`. Import our `services/backend` from above. As part of the `mounted` function, get data from the Rails backend with `backend().get('examples')` and display the data in a table. See the included Examples.vue file for more details.

- This is a very simplified example (no Vuex, simple axios `get`), but the basic concepts remain. The `backend.js` URL toggle is the magic that allows development and production work within Vue and Rails.

## Finish

- Clear as mud? There are probably better ways, but this system has worked well for a handful of apps I've authored. I like that I can run Vue as a standalone app and all the documentation lines up with what I'm doing. I like that Rails can stay simple and not worry about assets and JS frontends aside from using Sprockets to hash a filename and copy files to the right location. I can host both my Rails backend and Vue frontend from one host. Deploying to production involves running `yarn build-for-rails` before running `rails assets:precompile`. 