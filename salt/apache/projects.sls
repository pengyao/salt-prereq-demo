include:
  - apache

{% if 'projects' in pillar %}
stop-apache:
  service.dead:
    - name: httpd

{% for eachproject in pillar['projects'] %}
{% set project_id = 'web-project-' + eachproject.name %}
{% set project_rev = grains.get(project_id) %}
{{ project_id }}:
  git.latest:
    - name: {{ eachproject['remote'] }}
    - target: {{ eachproject['target'] }}
    - rev: {{ eachproject['rev'] }}
    - onlyif: test {{ eachproject['rev'] }} != {{ project_rev }}
    - prereq_in:
      - service: stop-apache
    - require_in:
      - service: apache
  grains.present:
    - value: {{eachproject['rev'] }}
    - require:
      - git: {{ project_id }}

{% endfor %}
{% endif %}
