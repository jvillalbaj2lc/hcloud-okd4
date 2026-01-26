# Install Templates

Use the templates in this folder to create your local configuration files. **Copy and rename** the templates, then fill in the values.

## 1) Create `install-config.yaml`

```bash
cp templates/install/install-config.yaml.template install-config.yaml
```

Edit `install-config.yaml` and fill in:

- `baseDomain`: must match `TF_VAR_dns_zone_name` (example: `example.com`).
- `metadata.name`: cluster name (e.g. `okd4`, resulting in `okd4.example.com`).
- `machineCIDR`: the private network CIDR for your Hetzner Cloud network (example: `10.0.0.0/16`).
- `pullSecret`: paste your full pull secret JSON for OCP (or use the OKD dummy auth if applicable).
- `sshKey`: paste your SSH public key.

## 2) Create `set_variables.sh`

```bash
cp templates/install/set_variables.sh.template set_variables.sh
```

Edit `set_variables.sh` and replace the placeholder values with your actual credentials and desired cluster settings.

## 3) Source your variables

```bash
source set_variables.sh
```

## 4) Follow the main workflow

Continue with the steps in the root `README.md` (build toolbox, generate manifests/ignitions, build image, and run Terraform).

## Notes on required Hetzner values

- `HCLOUD_TOKEN`: Hetzner Cloud API token.
- `TF_VAR_dns_zone_name`: your apex DNS zone (example: `example.com`).
- `TF_VAR_dns_domain`: your cluster domain (example: `okd4.example.com`).
- `machineCIDR`: should be the CIDR of the private network used by your Hetzner instances.
