{
  _config+:: {
    vernemqK8s: {
      dashboardNamePrefix: 'VerneMQ / ',
      dashboardTags: ['vernemq-mixin'],

      // For links between grafana dashboards, you need to tell us if your grafana
      // servers under some non-root path.
      linkPrefix: '',
    },

  }
}
