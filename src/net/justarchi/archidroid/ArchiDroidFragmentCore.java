package net.justarchi.archidroid;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import android.support.v4.app.Fragment;
import android.util.Log;
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

    final protected boolean ArchiDroidProcessAlive(String in) {
        return RootTools.isProcessRunning(in);
    }

    final protected void ArchiDroidExecute(String in) {
        Log.v("", "ArchiDroidExecute: " + in);
        try {
            Runtime.getRuntime().exec(in);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    final protected String ArchiDroidGetSymlinkTarget(String in) {
        Log.v("", "ArchiDroidGetSymlinkTarget: " + in);
        String result = null;
        try {
            Process process = Runtime.getRuntime().exec("readlink " + in);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            result = bufferedReader.readLine();
        } catch (Exception e) {
            e.printStackTrace();
        }
        Log.v("", "ArchiDroidGetSymlinkTarget: Got: "  + result);
        return result;
    }

    final protected String ArchiDroidReadOneLineNotSure(String in) {
        Log.v("", "ArchiDroidReadOneLine: " + in);
        StringBuilder log = new StringBuilder();
        try {
            Process process = Runtime.getRuntime().exec("cat " + in + " | head -n 1");
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = bufferedReader.readLine()) != null)
                log.append(line);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Log.v("", "ArchiDroidReadOneLine: Got: "  + log.toString());
        return log.toString();
    }

    final protected String ArchiDroidReadOneLine(String in) {
        Log.v("", "ArchiDroidReadOneLine: " + in);
        String result = null;
        try {
            Process process = Runtime.getRuntime().exec("cat " + in);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            result = bufferedReader.readLine();
        } catch (Exception e) {
            e.printStackTrace();
        }
        Log.v("", "ArchiDroidReadOneLine: Got: "  + result);
        return result;
    }

    final protected String ArchiDroidRead(String in) {
        Log.v("", "ArchiDroidRead: " + in);
        StringBuilder log = new StringBuilder();
        try {
            Process process = Runtime.getRuntime().exec("cat " + in);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = bufferedReader.readLine()) != null)
                log.append(line).append("\n");
        } catch (Exception e) {
            e.printStackTrace();
        }
        Log.v("", "ArchiDroidRead: Got: "  + log.toString());
        return log.toString();
    }

    final protected String ArchiDroidGetProperty(String in) {
        Log.v("", "ArchiDroidGetProperty: " + in);
        String result = null;
        try {
            Process process = Runtime.getRuntime().exec("getprop " + in);
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            result = bufferedReader.readLine();
        } catch (Exception e) {
            e.printStackTrace();
        }
        Log.v("", "ArchiDroidGetProperty: Got: "  + result);
        return result;
    }

    final protected String ArchiDroidGetProperty(String in, String in2) {
        String result = ArchiDroidGetProperty(in);
        if (result.length() == 0)
            result = in2;
        Log.v("", "ArchiDroidGetProperty: FinallyGot: "  + result);
        return result;
    }

    final protected void ArchiDroidRootExecute(String in) {
        Log.v("", "ArchiDroidRootExecute: "  + in);
        CommandCapture cmd = new CommandCapture(0, in);
        try {
            RootTools.getShell(true).add(cmd);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // TODO: Doesn't work
    private String out;
    final protected String ArchiDroidRootExecuteWithOutput(String in) {
        Log.v("", "ArchiDroidRootExecuteWithOutput: "  + in);
        Command cmd = new Command(0, in) {
            @Override
            public void commandOutput(int i, String s) {
                out = out + s + " ";
            }
            @Override
            public void commandTerminated(int i, String s) {
            }
            @Override
            public void commandCompleted(int i, int i2) {
            }
        };
        try {
            out = "";
            RootTools.getShell(true).add(cmd);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return out;
    }

    /* TODO
    For some reason  RootTools.remount() doesn't work, calling sysrw/mount/busybox mount neither
    It would be nice if we could find a better way for renaming file in /system ro directory
    As for now we trust RootTools and auto remount rw feature
    Additionally, it lacks rename feature so we're forced to copy and delete... */
    final protected void ArchiDroidBackendChangeSwitch(String path1, String path2) {
        Log.v("", "ArchiDroidBackendChangeSwitch: "  + path1 + " " + path2);
            boolean path1Exists = RootTools.exists(ADDEV + "/" + path1);
            boolean path2Exists = RootTools.exists(ADDEV + "/" + path2);
        if (path1Exists && !path2Exists) {
            RootTools.copyFile(ADDEV + "/" + path1, ADDEV + "/" + path2, true, true);
            RootTools.deleteFileOrDirectory(ADDEV + "/" + path1, true);
            Log.v("", "ArchiDroidBackendChangeSwitch: Done!");
        } else if (path2Exists && !path1Exists) {
            Log.v("", "ArchiDroidBackendChangeSwitch: Already changed!");
        } else {
            Log.v("", "ArchiDroidBackendChangeSwitch: Error, " + path1Exists + " " + path2Exists + ", fixing...");
            RootTools.deleteFileOrDirectory(ADDEV + "/" + path1, true);
            RootTools.deleteFileOrDirectory(ADDEV + "/" + path2, true);
            ArchiDroidRootExecute("touch /dev/ArchiDroidNullFile");
            RootTools.copyFile("/dev/ArchiDroidNullFile", ADDEV + "/" + path2, true, true);
            RootTools.deleteFileOrDirectory("/dev/ArchiDroidNullFile", true);
        }
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

}