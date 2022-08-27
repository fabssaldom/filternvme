# Translate NVMe mounts to UUIDs in /etc/fstab

## Introduction

This script will translate NVMe mounts defined by device name (like /dev/nvmen1...) to UUID, helping with P2V and cloud migrations.

It will backup the original fstab file, it should be tested before fully deployed.

If output file looks file, then it can replace the main /etc/fstab file.

## Author

(C) 2022 Google, fsalaman@google.com

