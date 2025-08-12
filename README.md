# About
Recently I have been trying to get libsmb2 to work on the Wii U to no avail. This repo builds a Wii U binary that attempts to access a share with libsmb2. 

# Problem

My goal is to be able to use libsmb2 on the Wii U to make it connect to a samba share.

The problem is that the Wii U version of libsmb2 uniquely seems to not be able to connect to any smb shares (for me). I get an error that it is not able to connect, which looks like this:

<img width="418" height="204" alt="image" src="https://github.com/user-attachments/assets/29a1e3ac-68af-46bf-a2ac-a5263b85bfa5" />

# Testing
## Test Server Bringup
I have been using the simple samba server from https://github.com/dockur/samba with the default command `docker compose up -d` which brings up a server with the following:

smb address: `//192.168.1.101/Data` (change to your machine's IP)

username:`samba`

password:`secret`

The server's functionality can be quickly tested with `smbclient //192.168.1.101/Data -U samba%secret -c "ls"`.

For me it looks like this:
```
$ smbclient //192.168.1.101/Data -U samba%secret -c "ls"
  .                                   D        0  Tue Aug 12 11:42:25 2025
  ..                                  D        0  Tue Aug 12 11:42:25 2025
```

## Wii U Testing

To test the Wii U's connectivity, check out the repository and edit lines 26-28 in `main.cpp`:
```
std::string cmd = "smb://192.168.1.101/Data";
std::string username = "samba";
std::string password = "secret";
```

Then compile with docker with `./run.sh` and run the outputted `build/wiiu_smb_test.rpx` in Cemu or a Wii U console.
