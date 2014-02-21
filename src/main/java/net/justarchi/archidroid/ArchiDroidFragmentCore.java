package net.justarchi.archidroid;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import android.support.v4.app.Fragment;
import com.stericson.RootTools.RootTools;
import com.stericson.RootTools.execution.Command;
import com.stericson.RootTools.execution.CommandCapture;

class ArchiDroidFragmentCore extends Fragment {

    final protected String AD = "/system/archidroid";
    final protected String ADDEV = AD + "/dev";

    final protected String ColorRed = "#FF0000";
    final protected String ColorYellow = "#FFFF00";
    final protected String ColorGreen = "#00FF00";
    final protected String ColorWhite = "#FFFFFF";

    final protected int Timeout = 10 * 1000;

    final protected void ArchiDroidBackendChangeSwitch(String path1, String path2) {
        boolean path1Exists = ArchiDroidFileExists(ADDEV + "/" + path1);
        boolean path2Exists = ArchiDroidFileExists(ADDEV + "/" + path2);
        ArchiDroidSystemRW();
        if (path1Exists && !path2Exists) {
            ArchiDroidRootMove(ADDEV + "/" + path1, ADDEV + "/" + path2);
        } else {
            ArchiDroidRootRemove(ADDEV + "/" + path1);
            ArchiDroidRootTouch(ADDEV + "/" + path2);
        }
        ArchiDroidSystemRO();
    }

    final protected void ArchiDroidBackendReload(String in) {
        ArchiDroidRootExecute("ARCHIDROID_INIT RELOAD " + in);
    }

    final protected boolean ArchiDroidBackendFileExists(String in) {
        return new File(ADDEV + "/" + in).exists();
    }

    final protected boolean ArchiDroidFileExists(String in) {
        return new File(in).exists();
    }

    final protected void ArchiDroidExecute(String in) {
        try {
            Runtime.getRuntime().exec(in);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    final protected String ArchiDroidExecuteWithOutput(String in) {
        StringBuilder log = new StringBuilder();
        try {
            Process process = Runtime.getRuntime().exec(in);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line = bufferedReader.readLine();
            log.append(line);
            while ((line = bufferedReader.readLine()) != null)
                log.append("\n").append(line);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return log.toString();
    }

    final protected String ArchiDroidGetProperty(String in) {
        return ArchiDroidExecuteWithOutput("getprop " + in);
    }

    final protected String ArchiDroidGetProperty(String in, String in2) {
        String result = ArchiDroidGetProperty(in);
        if (result.length() == 0)
            return in2;
        else
            return result;
    }

    final protected String ArchiDroidGetSymlinkTarget(String in) {
        return ArchiDroidExecuteWithOutput("readlink " + in);
    }

    final protected boolean ArchiDroidIsFileImmutable(String in) {
        if (ArchiDroidExecuteWithOutput("lsattr /system/etc/hosts").charAt(5) == 'i') {
            return true;
        } else {
            return false;
        }
    }

    final protected void ArchiDroidSystemRO() {
        ArchiDroidRootExecute("sysro");
    }

    final protected void ArchiDroidSystemRW() {
        ArchiDroidRootExecute("sysrw");
    }

    final protected boolean ArchiDroidProcessAlive(String in) {
        return RootTools.isProcessRunning(in);
    }

    final protected String ArchiDroidRead(String in) {
        return ArchiDroidExecuteWithOutput("cat " + in);
    }

    final protected void ArchiDroidRootExecute(String in) {
        CommandCapture cmd = new CommandCapture(0, false, in);
        try {
            RootTools.getShell(true).add(cmd);
        } catch (Exception e) {
            e.printStackTrace();
        }
        synchronized (cmd) {
            try {
                if (!cmd.isFinished()) {
                    cmd.wait(Timeout);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    final protected String ArchiDroidRootExecuteWithOutput(String in) {
        final StringBuilder log = new StringBuilder();
        Command cmd = new Command(0, false, in) {
            boolean firstLine = true;
            @Override
            public void commandOutput(int i, String s) {
                if (firstLine) {
                    firstLine = false;
                    log.append(s);
                } else {
                    log.append("\n").append(s);
                }
            }
            @Override
            public void commandTerminated(int i, String s) {
            }
            @Override
            public void commandCompleted(int i, int i2) {
            }
        };
        try {
            RootTools.getShell(true).add(cmd);
        } catch (Exception e) {
            e.printStackTrace();
        }
        synchronized (cmd) {
            try {
                if (!cmd.isFinished()) {
                    cmd.wait(Timeout);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return log.toString();
    }

    final protected void ArchiDroidRootMove(String in, String in2) {
        ArchiDroidRootExecute("mv " + in + " " + in2);
    }

    final protected void ArchiDroidRootRemove(String in) {
        ArchiDroidRootExecute("rm -f " + in);
    }

    final protected void ArchiDroidRootTouch(String in) {
        ArchiDroidRootExecute("touch " + in);
    }

}