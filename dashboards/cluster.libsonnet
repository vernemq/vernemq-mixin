local g = import 'grafana-builder/grafana.libsonnet';

{
  grafanaDashboards+:: {
    'vmq-node.json':
        local overviewRow = g.row('Overview')
            .addPanel(
              g.panel('Clients') +
              g.queryPanel([
                'sum(socket_open{node="$node"} - socket_close{node="$node"})',
                'sum(queue_processes{node="$node"}) - sum(socket_open{node="$node"} - socket_close{node="$node"})'
              ], ['Online', 'Offline']))
            .addPanel(
              g.panel('MQTT Connect Ops') +
              g.queryPanel([
                'sum(rate(socket_open{node="$node"}[1m]))',
                'sum(rate(socket_close{node="$node"}[1m]))',
                'sum(rate(mqtt_connect_received{node="$node"}[1m]))',
                'sum(rate(mqtt_connack_sent{node="$node"}[1m]))'
              ], ['Socket Open', 'Socket Close', 'Connect', 'Connack']))
            .addPanel(
              g.panel('MQTT Publish Ops') +
              g.queryPanel([
                'sum(rate(mqtt_publish_received{node="$node"}[1m]))',
                'sum(rate(mqtt_publish_sent{node="$node"}[1m]))',
              ], ['Incoming', 'Outgoing']))
            .addPanel(
              g.panel('Queue Ops') +
              g.queryPanel([
                'sum(rate(queue_message_in{node="$node"}[1m]))',
                'sum(rate(queue_message_out{node="$node"}[1m]))',
                'sum(rate(queue_message_drop{node="$node"}[1m]))',
                'sum(rate(queue_message_expired{node="$node"}[1m]))',
                'sum(rate(queue_message_unhandled{node="$node"}[1m]))',
              ], ['Enqueue', 'Dequeue', 'Drop', 'Expire', 'Unhandled']));
        g.dashboard(
          '%(dashboardNamePrefix)sNode' % $._config.vernemqK8s,
          uid=std.md5('vmq-node.json'),
        ).addTemplate('node', 'socket_open{}', 'node')
         .addRow(overviewRow) + { tags: $._config.vernemqK8s.dashboardTags },
        
    'vmq-cluster.json':
        local overviewRow = g.row('Overview')
            .addPanel(
              g.panel('Clients') +
              g.queryPanel([
                'sum(socket_open - socket_close)',
                'sum(queue_processes) - sum(socket_open - socket_close)'
              ], ['Online', 'Offline']))
            .addPanel(
              g.panel('MQTT Connect Ops') +
              g.queryPanel([
                'sum(rate(socket_open[1m]))',
                'sum(rate(socket_close[1m]))',
                'sum(rate(mqtt_connect_received[1m]))',
                'sum(rate(mqtt_connack_sent[1m]))'
              ], ['Socket Open', 'Socket Close', 'Connect', 'Connack']))
            .addPanel(
              g.panel('MQTT Publish Ops') +
              g.queryPanel([
                'sum(rate(mqtt_publish_received[1m]))',
                'sum(rate(mqtt_publish_sent[1m]))',
              ], ['Incoming', 'Outgoing']))
            .addPanel(
              g.panel('Queue Ops') +
              g.queryPanel([
                'sum(rate(queue_message_in[1m]))',
                'sum(rate(queue_message_out[1m]))',
                'sum(rate(queue_message_drop[1m]))',
                'sum(rate(queue_message_expired[1m]))',
                'sum(rate(queue_message_unhandled[1m]))',
              ], ['Enqueue', 'Dequeue', 'Drop', 'Expire', 'Unhandled']));

        local tableStyles = {
          node: {
            alias: 'Node',
            pattern: 'node',
            type: 'string',
            link: '%(prefix)s/d/%(uid)s/vernemq-node?var-datasource=$datasource&var-node=$__cell_1' % { prefix: $._config.vernemqK8s.linkPrefix, uid: std.md5('vmq-node.json') },
            linkTooltip: 'Drill down to node',
          },
          time: {
            alias: 'Time',
            pattern: 'Time',
            type: 'hidden',
          }
        };

        local breakdownRow = g.row('Node Breakdown')
            .addPanel(
              g.panel('Node Breakdown') +
              g.tablePanel([
                'sum(socket_open - socket_close) by (node)',
                'sum(queue_processes) by (node) - sum(socket_open - socket_close) by (node)',
                'sum(rate(mqtt_publish_received[1m])) by (node)',
                'sum(rate(mqtt_publish_sent[1m])) by (node)',
                'sum(rate(queue_message_in[1m])) by (node)',
                'sum(rate(queue_message_out[1m])) by (node)',
                'sum(rate(queue_message_drop[1m])) by (node)',
                'sum(rate(queue_message_expired[1m])) by (node)',
                'sum(rate(queue_message_unhandled[1m])) by (node)',
              ], tableStyles {
                'Value #A': {alias: 'Online'},
                'Value #B': {alias: 'Offline'},
                'Value #C': {alias: 'Publish In'},
                'Value #D': {alias: 'Publish Out'},
                'Value #E': {alias: 'Q Enqueue'},
                'Value #F': {alias: 'Q Dequeue'},
                'Value #G': {alias: 'Q Drop'},
                'Value #H': {alias: 'Q Expired'},
                'Value #I': {alias: 'Q Unhandled'},
              }));


        g.dashboard(
          '%(dashboardNamePrefix)sCluster' % $._config.vernemqK8s,
          uid=std.md5('vmq-cluster.json'),
        ).addRow(overviewRow)
         .addRow(breakdownRow) + { tags: $._config.vernemqK8s.dashboardTags },

    },
}
                
