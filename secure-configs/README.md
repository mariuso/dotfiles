# Secure Config Sync

Securely sync sensitive configuration files across machines using 1Password as the backend storage.

## Overview

This system stores sensitive configuration files (SSH configs, cloud credentials, etc.) as encrypted documents in 1Password, allowing you to securely sync them across multiple machines without ever storing credentials in git.

## Quick Start

### First-time setup on a new machine:
```bash
./secure-configs/setup-machine.sh
```

### Backup configs to 1Password:
```bash
./secure-configs/sync-configs.sh backup
```

### Restore configs from 1Password:
```bash
./secure-configs/sync-configs.sh restore
```

## Managed Configuration Files

| Local Path | 1Password Item | Description |
|------------|----------------|-------------|
| `~/.ssh/config` | SSH Config - {hostname} | SSH client configuration |
| `~/.aws/credentials` | AWS Credentials | AWS access keys |
| `~/.aws/config` | AWS Config | AWS CLI configuration |
| `~/.config/gcloud/application_default_credentials.json` | GCloud ADC | Google Cloud credentials |
| `~/.kube/config` | Kubernetes Config | Kubernetes cluster access |
| `~/.docker/config.json` | Docker Config | Docker registry authentication |
| `~/.terraformrc` | Terraform Config | Terraform Cloud/Enterprise tokens |
| `~/.npmrc` | NPM Config | NPM registry authentication |

## Security Features

- ✅ **No credentials in git** - Only scripts and templates are version controlled
- ✅ **1Password encryption** - All sensitive data encrypted at rest
- ✅ **Machine-specific configs** - SSH configs tagged by hostname
- ✅ **Proper file permissions** - Automatically sets restrictive permissions (600/644)
- ✅ **Audit trail** - 1Password tracks access and modifications
- ✅ **Selective sync** - Choose which configs to sync per machine

## Commands

### sync-configs.sh

```bash
# Upload local configs to 1Password
./sync-configs.sh backup

# Download configs from 1Password
./sync-configs.sh restore

# List available configs in 1Password
./sync-configs.sh list

# Show help
./sync-configs.sh help
```

### setup-machine.sh

```bash
# Complete new machine setup
./setup-machine.sh
```

## Workflow

### Setting up a new machine:
1. Clone dotfiles repository
2. Run main dotfiles installation: `./install.sh`
3. Run secure config setup: `./secure-configs/setup-machine.sh`
4. Authenticate with cloud providers as needed
5. Backup any new configs: `./secure-configs/sync-configs.sh backup`

### Adding a new config file:
1. Edit `CONFIG_MAPPINGS` in `sync-configs.sh`
2. Add the file path and 1Password item title
3. Run `./sync-configs.sh backup` to upload

### Updating configs:
1. Modify config files locally
2. Run `./sync-configs.sh backup` to sync changes
3. On other machines, run `./sync-configs.sh restore`

## Prerequisites

- 1Password account with CLI access
- 1Password CLI installed (`brew install 1password-cli`)
- Authenticated 1Password session (`op signin`)

## Vault Structure

Configs are stored in a dedicated vault called "Development Configs" with:
- **Item titles**: Descriptive names (e.g., "SSH Config - MacBook-Pro")
- **Tags**: `dotfiles`, `config`, filename, `machine:hostname`
- **Document attachments**: The actual configuration files

## Best Practices

1. **Regular backups**: Run `sync-configs.sh backup` after making config changes
2. **Machine-specific SSH configs**: Use hostname-based SSH config items
3. **Environment separation**: Use different vaults for different environments (dev/staging/prod)
4. **Access review**: Regularly review 1Password access logs
5. **Key rotation**: Update configs when rotating credentials

## Troubleshooting

### "Not signed in to 1Password"
```bash
op signin
```

### "Config not found in 1Password"
The config hasn't been backed up yet. Create it locally first, then run:
```bash
./sync-configs.sh backup
```

### Permission denied errors
The script automatically sets proper permissions, but you can manually fix:
```bash
chmod 600 ~/.ssh/config ~/.aws/credentials
chmod 644 ~/.aws/config
```

### Vault not found
The script will automatically create the "Development Configs" vault on first backup.