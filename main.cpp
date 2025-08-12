#include <string>
#include <thread>

#include <coreinit/thread.h>

#include <nn/ac.h>

#include <whb/log.h>
#include <whb/log_console.h>
#include <whb/proc.h>

#include <string>
#include <thread>

#include <coreinit/thread.h>

#include <nn/ac.h>

#include <whb/log.h>
#include <whb/log_console.h>
#include <whb/proc.h>

#include <smb2/smb2.h>
#include <smb2/libsmb2.h>

std::string cmd = "smb://192.168.1.101/Data";
std::string username = "samba";
std::string password = "secret";

int smb_cmd(std::string cmd, std::string username, std::string password) {
    struct smb2_context *smb2;
    struct smb2_url *url;
    struct smb2dir *dir;
    struct smb2dirent *ent;
    char *link;
    int rc = 1;

    smb2 = smb2_init_context();
    if (smb2 == NULL)
    {
        WHBLogPrintf("Failed to init context");
        return 1;
    }

    url = smb2_parse_url(smb2, cmd.c_str());
    if (url == NULL)
    {
        WHBLogPrintf("Failed to parse url: %s", smb2_get_error(smb2));
        return 1;
    }

    smb2_set_user(smb2, username.c_str());
    smb2_set_password(smb2, password.c_str());
    auto connect_err = smb2_connect_share(smb2, url->server, url->share, NULL);
    if (connect_err < 0) {
        WHBLogPrintf("connect error: %d", connect_err);
        WHBLogPrintf("\t\tserver:    %s", url->server);
        WHBLogPrintf("\t\tshare:     %s", url->share);
        WHBLogPrintf("\t\tusername:  %s", username.c_str());
        WHBLogPrintf("\t\tpassword:  %s", password.c_str());
    } else {
        WHBLogPrintf("connect success");
    }

    return rc;
}

int main(int argc, char **argv) {
    nn::ac::ConfigIdNum configId;
    nn::ac::Status status;
    uint32_t ip=-1;

    nn::ac::Initialize();
    nn::ac::GetStartupId(&configId);
    nn::ac::Connect(configId);

    WHBProcInit();
    WHBLogConsoleInit();
    WHBLogPrintf("Compiled at %s %s", __DATE__, __TIME__);
    auto r = nn::ac::BeginLocalConnection(true);
    nn::ac::GetConnectStatus(&status);
    WHBLogPrintf("connect status: %s", (0==status)?"connected":"not connected");
    auto s = nn::ac::GetAssignedAddress(&ip);
    WHBLogPrintf("ip addr assigned? %s %8X", (1==s.IsSuccess())?"yes":"no", ip);
    nn::Result cr = nn::ac::GetConnectResult(&cr);
    WHBLogPrintf("internet connected: %s", (1==cr.IsSuccess())?"yes":"no");

    WHBLogPrintf("Trying samba connect");
    smb_cmd(cmd, username, password);

    while (WHBProcIsRunning()) {
        WHBLogConsoleDraw();
        OSSleepTicks(OSMillisecondsToTicks(1000));
    }

    WHBLogConsoleFree();
    WHBProcShutdown();

    nn::ac::Finalize();

    return 0;
}
