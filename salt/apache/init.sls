apache:
  pkg.installed:
    - name: httpd
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - require:
      - pkg: apache
  service.running:
    - name: httpd
    - enable: True
    - watch:
      - pkg: apache
      - file: apache 
    
