<template>
  <div id="example">
    <table class="styled-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Favorite Restaurant</th>
          <th>Favorite Movie</th>
          <th>Favorite Band</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="row in example_data" :key="row.name">
          <td>{{ row.name }}</td>
          <td>{{ row.favorite_restaurant }}</td>
          <td>{{ row.favorite_movie }}</td>
          <td>{{ row.favorite_band }}</td>
        </tr>
      </tbody>
    </table>
    <p>Credit to <a href="https://dev.to/dcodeyt/creating-beautiful-html-tables-with-css-428l">https://dev.to/dcodeyt/creating-beautiful-html-tables-with-css-428l</a> for the table styling.</p>
  </div>
</template>

<script>
import backend from '@/services/backend'

export default {
  name: 'Example',
  data() {
    return {
      example_data: []
    }
  },
  mounted () {
    backend().get('examples')
      .then(r => {
        this.example_data = r.data
      })
      .catch(e => {
        console.log(e)
      })
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  .styled-table {
    border-collapse: collapse;
    margin: 25px 0;
    font-size: 0.9em;
    font-family: sans-serif;
    min-width: 400px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
  }

  .styled-table thead tr {
    background-color: #009879;
    color: #ffffff;
    text-align: left;
  }

  .styled-table th,
  .styled-table td {
    padding: 12px 15px;
  }

  .styled-table tbody tr {
    border-bottom: 1px solid #dddddd;
  }

  .styled-table tbody tr:nth-of-type(even) {
    background-color: #f3f3f3;
  }

  .styled-table tbody tr:last-of-type {
    border-bottom: 2px solid #009879;
  }

  .styled-table tbody tr.active-row {
    font-weight: bold;
    color: #009879;
  }
</style>
