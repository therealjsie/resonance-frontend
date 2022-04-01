<template>
  <div>
    <h1>{{ text }}</h1>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      text: "",
    };
  },
  methods: {
    fetchHelloWorld: async function () {
      let apiUrl = window.location.origin + "/api/v1/posts";
      let response = await fetch(apiUrl, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (!response.ok) {
        throw Error("Error: " + (await response.text()));
      } else {
        this.text = await response.text();
      }
    },
  },
  beforeMount() {
    this.fetchHelloWorld();
  },
};
</script>

<style scoped>
</style>
