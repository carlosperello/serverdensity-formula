{% if ((grains['os_family'] == 'Debian') or
       (grains['os_family'] == 'RedHat' and
        grains['osmajorrelease'][0] in ['5', '6'])) %}
sd-agent:
{% if grains['os_family'] == 'Debian' %}
  pkgrepo.managed:
    - humanname: Server Density PPA
    - name: deb http://www.serverdensity.com/downloads/linux/deb all main
    - file: /etc/apt/sources.list.d/sd-agent.list
    - key_url: https://www.serverdensity.com/downloads/boxedice-public.key
    - require_in:
      - pkg: sd-agent
{% elif grains['os_family'] == 'RedHat' %}
  file.managed:
    - name: /etc/yum.repos.d/serverdensity.repo
    - source: salt://serverdensity/files/yum.repo
    - require_in:
      - pkg: sd-agent
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-serverdensity
    - source: https://www.serverdensity.com/downloads/boxedice-public.key
    - require_in:
      - pkg: sd-agent
{% endif %}
  pkg:
    - installed
  file.managed:
    - name: /etc/sd-agent/config.cfg
    - source: salt://serverdensity/files/sd-agent.cfg
    - template: jinja
    - mode: 660
    - user: sd-agent
    - group: sd-agent
    - require:
      - pkg: sd-agent
  service.running:
    - enable: True
    - watch:
      - pkg: sd-agent
      - file: /etc/sd-agent/config.cfg
{% endif %}
