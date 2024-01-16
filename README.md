# MacLoggerDX Backup Script

Script to make backups of the [MacLoggerDX](https://dogparksoftware.com/MacLoggerDX.html) Documents/MLDX_Logs folder.

- Gracefully closes MLDX
- Creates a tgz archive (gzipped tar file)
- Excludes .DS_Store, debug files, and QSL card images
- Deletes the oldest backup if max_backups number has been reached
- Starts MLDX

Create the backup folder where you want it, e.g. Documents/MLDX_Backup.

The number of backups to keep can be set, with the oldest deleted when a new backup is created.

Run the script from with-in the backup folder, or the path can be set if the script is being run from a different location, see the comments in the script.

## iCloud Drive

This script may also be useful when iCloud Drive Documents & Desktop syncing is enabled.

The [MacLoggerDX manual FAQ section](https://www.dogparksoftware.com/MacLoggerDX%20Help/mldxfc_faq.html) recommends disabling iCloud Drive Documents & Desktop syncing..

If (like me) you use iCloud to sync the Documents and Desktop folders between several machines, MLDX places locks on some files which can cause problems with iCloud Drive syncing.

The work around I found was to rename MLDX_Logs to MLDX_Logs.nosync then create a symbolic link to it with the original folder name.

With MLDX closed, open terminal and run:

```bash
cd ~/Documents
mv MLDX_Logs MLDX_Logs.nosync
ln -s MLDX_Logs.nosync MLDX_Logs
```

iCloud Drive will ignore folder names ending in .nosync, while it will sync the symbolic link it self, it doesn't sync the files/folders the link points to. Since MLDX_Logs would no longer be synced in this situation, the script can be run from a folder under Documents (e.g. MLDX_Backup) to create a backup that will get synced to iCloud Drive.

### Restarting iCloud Sync Service

If iCloud drive gets stuck on syncing files (when it should not) I found the iCloud drive syncing service can be restarted simply with:

```bash
killall bird
```

The service will automatically restart, and with-in a few momnets the files should sync.
