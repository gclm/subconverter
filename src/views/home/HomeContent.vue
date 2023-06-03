<template>
  <section id="main" class="container medium">
    <home-header />
    <home-form />
  </section>
</template>

<script>
import HomeHeader from './HomeHeader.vue';
import HomeForm from './HomeForm.vue';
export default {
  name: 'HomeContent',
  components: {
    HomeHeader,
    HomeForm,
  },
};
</script>
