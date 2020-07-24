<template>
  <div id="container">
    <h3>A Ruby on Rails project that uses Vue.js as its frontend. Avoids webpacker at all costs.</h3>
    <Example/>
  </div>
</template>

<script>
import Example from './components/Example.vue'

export default {
  name: 'App',
  components: {
    Example
  }
}
</script>

<style>
#container {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: left;
  color: #2c3e50;
}
</style>
