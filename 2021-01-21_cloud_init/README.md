# Cloud Init

```
cat /var/log/cloud-init-output.log
```

```
tail -f /var/log/cloud-init-output.log
```

```
cat /run/cloud-init/instance-data.json
```

```
cat /var/lib/cloud/instance/user-data.txt
```

```
cloud-init query  v1.availability_zone
```

Examples:

- http://cloud-init-script.sikademo.com/
- http://cloud-init-simple.sikademo.com/
- http://cloud-init-cowsay.sikademo.com/

Resources:

- Metadata - https://cloudinit.readthedocs.io/en/latest/topics/instancedata.html
- Datasources (DigitalOcean) - https://cloudinit.readthedocs.io/en/latest/topics/datasources/digitalocean.html
- Proxmox - https://pve.proxmox.com/wiki/Cloud-Init_Support#_custom_cloud_init_configuration
