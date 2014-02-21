package net.justarchi.archidroid;

import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;

class ArchiDroidFragmentBackend extends ArchiDroidFragmentCore {

    boolean onResumeAutoRefresh = false;
    Switch switchHaveged;
    String switchHavegedStateON = "HAVEGED_ENABLED";
    String switchHavegedStateOFF = "HAVEGED_DISABLED";
    TextView textHavegedState;
    String ArchiDroidHaveged = "archidroid_haveged";
    TextView textEntropyState;
    String EntropyStateFile = "/proc/sys/kernel/random/entropy_avail";
    CheckBox checkBoxEntropyRefresh;
    boolean entropyAutoRefresh = false;
    Button buttonEntropyEmpty;

    Switch switchFrandom;
    String switchFrandomStateON = "FRANDOM_ENABLED";
    String switchFrandomStateOFF = "FRANDOM_DISABLED";
    Switch switchAdblock;
    String switchAdblockStateON = "ADBLOCK_ENABLED";
    String switchAdblockStateOFF = "ADBLOCK_DISABLED";
    Switch switchAdblockLocalDnses;
    String switchAdblockLocalDnsesStateON = "ADBLOCK_LOCAL_DNSES_ENABLED";
    String switchAdblockLocalDnsesStateOFF = "ADBLOCK_LOCAL_DNSES_DISABLED";
    Switch switchAdblockForceLocalDnses;
    String switchAdblockForceLocalDnsesStateON = "ADBLOCK_FORCE_LOCAL_DNSES";
    String switchAdblockForceLocalDnsesStateOFF = "ADBLOCK_DONT_FORCE_LOCAL_DNSES";
    Switch switchAdblockHosts;
    String switchAdblockHostsStateADAWAY = "ADBLOCK_USE_ADAWAY_HOSTS";
    String switchAdblockHostsStateMOAB = "ADBLOCK_USE_MOAB_HOSTS";
    Switch switchHosts;
    String HostsFile="/system/etc/hosts";

    TextView textDnsmasqState;
    String ArchiDroidDnsmasq = "archidroid_dnsmasq";
    TextView textDnsproxy2State;
    String ArchiDroidDnsproxy2 = "archidroid_dnsproxy2";
    TextView textPixelservState;
    String ArchiDroidPixelserv = "archidroid_pixelserv";

    TextView textFrandomState;
    TextView textUrandomState;
    TextView textRandomState;

    TextView textLocalDNS1IP;
    TextView textLocalDNS2IP;

    Button buttonReset;
    Button buttonRefresh;
    Button buttonReload;

    private void ArchiDroidReloadChoice() {
        allowReload = false;

        switchHaveged.setChecked(ArchiDroidBackendFileExists(switchHavegedStateON));
        switchFrandom.setChecked(ArchiDroidBackendFileExists(switchFrandomStateON));
        switchAdblock.setChecked(ArchiDroidBackendFileExists(switchAdblockStateON));
        switchAdblockLocalDnses.setChecked(ArchiDroidBackendFileExists(switchAdblockLocalDnsesStateON));
        switchAdblockForceLocalDnses.setChecked(ArchiDroidBackendFileExists(switchAdblockForceLocalDnsesStateON));
        switchAdblockHosts.setChecked(ArchiDroidBackendFileExists(switchAdblockHostsStateADAWAY));
        if (switchAdblock.isChecked()) {
            switchAdblockLocalDnses.setEnabled(true);
            if (switchAdblockLocalDnses.isChecked()) {
                switchAdblockForceLocalDnses.setEnabled(true);
            } else {
                switchAdblockForceLocalDnses.setEnabled(false);
            }
            switchAdblockHosts.setEnabled(true);
        } else {
            switchAdblockLocalDnses.setEnabled(false);
            switchAdblockForceLocalDnses.setEnabled(false);
            switchAdblockHosts.setEnabled(false);
        }
        switchHosts.setChecked(ArchiDroidIsFileImmutable(HostsFile));

        if (ArchiDroidProcessAlive(ArchiDroidDnsmasq)) {
            textDnsmasqState.setText("ON");
            textDnsmasqState.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textDnsmasqState.setText("OFF");
            textDnsmasqState.setTextColor(Color.parseColor(ColorRed));
        }
        if (ArchiDroidProcessAlive(ArchiDroidDnsproxy2)) {
            textDnsproxy2State.setText("ON");
            textDnsproxy2State.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textDnsproxy2State.setText("OFF");
            textDnsproxy2State.setTextColor(Color.parseColor(ColorRed));
        }
        if (ArchiDroidProcessAlive(ArchiDroidPixelserv)) {
            textPixelservState.setText("ON");
            textPixelservState.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textPixelservState.setText("OFF");
            textPixelservState.setTextColor(Color.parseColor(ColorRed));
        }

        if (ArchiDroidFileExists("/dev/frandom")) {
            textFrandomState.setText("YES");
            textFrandomState.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textFrandomState.setText("NO");
            textFrandomState.setTextColor(Color.parseColor(ColorRed));
        }
        if (ArchiDroidFileExists("/dev/random.ORIG")) {
            textRandomState.setText("frandom");
            textRandomState.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textRandomState.setText("random");
            textRandomState.setTextColor(Color.parseColor(ColorWhite));
        }
        if (ArchiDroidFileExists("/dev/urandom.ORIG")) {
            textUrandomState.setText("frandom");
            textUrandomState.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textUrandomState.setText("urandom");
            textUrandomState.setTextColor(Color.parseColor(ColorWhite));
        }

        if (!switchAdblockLocalDnses.isChecked() || !switchAdblock.isChecked()) {
            textLocalDNS1IP.setText("Disabled");
            textLocalDNS1IP.setTextColor(Color.parseColor(ColorRed));
            textLocalDNS2IP.setText("Disabled");
            textLocalDNS2IP.setTextColor(Color.parseColor(ColorRed));
        } else {
            textLocalDNS1IP.setText(ArchiDroidGetProperty("net.dns1", "?.?.?.?"));
            textLocalDNS1IP.setTextColor(Color.parseColor(ColorWhite));
            textLocalDNS2IP.setText(ArchiDroidGetProperty("net.dns2", "?.?.?.?"));
            textLocalDNS2IP.setTextColor(Color.parseColor(ColorWhite));
        }

        textEntropyState.setText(ArchiDroidRead(EntropyStateFile));
        if (ArchiDroidProcessAlive(ArchiDroidHaveged)) {
            textHavegedState.setText("ON");
            textHavegedState.setTextColor(Color.parseColor(ColorGreen));
        } else {
            textHavegedState.setText("OFF");
            textHavegedState.setTextColor(Color.parseColor(ColorRed));
        }

        allowReload = true;
    }

    @Override
    public void onResume() {
        super.onResume();
        ArchiDroidReloadChoice();
        if (onResumeAutoRefresh) {
            checkBoxEntropyRefresh.setChecked(true);
            onResumeAutoRefresh = false;
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        if (checkBoxEntropyRefresh.isChecked()) {
            checkBoxEntropyRefresh.setChecked(false);
            onResumeAutoRefresh = true;
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        switchHaveged = (Switch) getView().findViewById(R.id.switchHaveged);
        switchFrandom = (Switch) getView().findViewById(R.id.switchFrandom);
        switchAdblock = (Switch) getView().findViewById(R.id.switchAdblock);
        switchAdblockLocalDnses = (Switch) getView().findViewById(R.id.switchAdblockLocalDnses);
        switchAdblockForceLocalDnses = (Switch) getView().findViewById(R.id.switchAdblockForceLocalDnses);
        switchAdblockHosts = (Switch) getView().findViewById(R.id.switchAdblockHosts);
        switchHosts = (Switch) getView().findViewById(R.id.switchHosts);

        textHavegedState = (TextView) getView().findViewById(R.id.textHavegedState);
        textDnsmasqState = (TextView) getView().findViewById(R.id.textDnsmasqState);
        textDnsproxy2State = (TextView) getView().findViewById(R.id.textDnsproxy2State);
        textPixelservState = (TextView) getView().findViewById(R.id.textPixelservState);

        textFrandomState = (TextView) getView().findViewById(R.id.textFrandomState);
        textUrandomState = (TextView) getView().findViewById(R.id.textUrandomState);
        textRandomState = (TextView) getView().findViewById(R.id.textRandomState);

        textLocalDNS1IP = (TextView) getView().findViewById(R.id.textLocalDNS1IP);
        textLocalDNS2IP = (TextView) getView().findViewById(R.id.textLocalDNS2IP);

        textEntropyState = (TextView) getView().findViewById(R.id.textEntropyState);
        checkBoxEntropyRefresh = (CheckBox) getView().findViewById(R.id.checkBoxEntropyRefresh);
        buttonEntropyEmpty = (Button) getView().findViewById(R.id.buttonEntropyEmpty);

        buttonReset = (Button) getView().findViewById(R.id.buttonReset);
        buttonRefresh = (Button) getView().findViewById(R.id.buttonRefresh);
        buttonReload = (Button) getView().findViewById(R.id.buttonReload);

        ArchiDroidReloadChoice();

        switchHaveged.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        switchFrandom.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        switchAdblock.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        switchAdblockLocalDnses.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        switchAdblockForceLocalDnses.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        switchAdblockHosts.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        switchHosts.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());

        checkBoxEntropyRefresh.setOnCheckedChangeListener(new CustomOnCheckedChangeListener());
        buttonEntropyEmpty.setOnClickListener(new CustomOnClickListener());

        buttonReset.setOnClickListener(new CustomOnClickListener());
        buttonRefresh.setOnClickListener(new CustomOnClickListener());
        buttonReload.setOnClickListener(new CustomOnClickListener());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.archidroid_fragment_backend, container, false);
    }

    private boolean allowReload = true;
    public class CustomOnCheckedChangeListener implements CompoundButton.OnCheckedChangeListener {

        @Override
        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
            // We definitely want to apply only one value at once and because this listener will also wake up due to childs doing the same, we need to lock it
            // This will make sure that we won't override user choice (dev), because ARCHIDROID_INIT should keep an eye on that, not we
            if (allowReload) {
                switch (buttonView.getId()) {
                    case R.id.switchHaveged:
                        if (isChecked)
                            ArchiDroidBackendChangeSwitch(switchHavegedStateOFF, switchHavegedStateON);
                        else
                            ArchiDroidBackendChangeSwitch(switchHavegedStateON, switchHavegedStateOFF);
                        ArchiDroidBackendReload("HAVEGED");
                        break;
                    case R.id.switchFrandom:
                        if (isChecked)
                            ArchiDroidBackendChangeSwitch(switchFrandomStateOFF, switchFrandomStateON);
                        else
                            ArchiDroidBackendChangeSwitch(switchFrandomStateON, switchFrandomStateOFF);
                        ArchiDroidBackendReload("FRANDOM");
                        break;
                    case R.id.switchAdblock:
                        if (isChecked)
                            ArchiDroidBackendChangeSwitch(switchAdblockStateOFF, switchAdblockStateON);
                        else
                            ArchiDroidBackendChangeSwitch(switchAdblockStateON, switchAdblockStateOFF);
                        ArchiDroidBackendReload("ADBLOCK");
                        break;
                    case R.id.switchAdblockLocalDnses:
                        if (isChecked)
                            ArchiDroidBackendChangeSwitch(switchAdblockLocalDnsesStateOFF, switchAdblockLocalDnsesStateON);
                        else
                            ArchiDroidBackendChangeSwitch(switchAdblockLocalDnsesStateON, switchAdblockLocalDnsesStateOFF);
                        ArchiDroidBackendReload("ADBLOCK");
                        break;
                    case R.id.switchAdblockForceLocalDnses:
                        if (isChecked)
                            ArchiDroidBackendChangeSwitch(switchAdblockForceLocalDnsesStateOFF, switchAdblockForceLocalDnsesStateON);
                        else
                            ArchiDroidBackendChangeSwitch(switchAdblockForceLocalDnsesStateON, switchAdblockForceLocalDnsesStateOFF);
                        ArchiDroidBackendReload("ADBLOCK");
                        break;
                    case R.id.switchAdblockHosts:
                        if (isChecked)
                            ArchiDroidBackendChangeSwitch(switchAdblockHostsStateMOAB, switchAdblockHostsStateADAWAY);
                        else
                            ArchiDroidBackendChangeSwitch(switchAdblockHostsStateADAWAY, switchAdblockHostsStateMOAB);
                        ArchiDroidBackendReload("ADBLOCK");
                        break;
                    case R.id.switchHosts:
                        ArchiDroidSystemRW();
                        if (isChecked)
                            ArchiDroidRootExecute("chattr +i " + HostsFile);
                        else
                            ArchiDroidRootExecute("chattr -i " + HostsFile);
                        ArchiDroidSystemRO();
                        break;
                    case R.id.checkBoxEntropyRefresh:
                        if (isChecked) {
                            entropyAutoRefresh = true;
                            Thread entropyAutoRefreshThread = new Thread(new Runnable() {
                                public void run() {
                                    while (entropyAutoRefresh) {
                                        getActivity().runOnUiThread(
                                                new Runnable() {
                                                    public void run() {
                                                        textEntropyState.setText(ArchiDroidRead(EntropyStateFile));
                                                    }
                                                }
                                        );
                                        try {
                                            Thread.sleep(200);
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            });
                            entropyAutoRefreshThread.start();
                        } else
                            entropyAutoRefresh = false;
                        break;
                }
                ArchiDroidReloadChoice();
            }
        }
    }
    public class CustomOnClickListener implements View.OnClickListener {

        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.buttonEntropyEmpty:
                    if (ArchiDroidFileExists("/dev/random.ORIG"))
                        ArchiDroidExecute("head -c " + Integer.parseInt(ArchiDroidRead(EntropyStateFile)) / 8 + " /dev/random.ORIG >/dev/null 2>&1");
                    else
                        ArchiDroidExecute("head -c " + Integer.parseInt(ArchiDroidRead(EntropyStateFile)) / 8 + " /dev/random >/dev/null 2>&1");

                    textEntropyState.setText(ArchiDroidRead(EntropyStateFile));
                    break;
                case R.id.buttonRefresh:
                    ArchiDroidReloadChoice();
                    break;
                case R.id.buttonReload:
                    ArchiDroidBackendReload("ALL");
                    break;
                case R.id.buttonReset:
                    ArchiDroidBackendChangeSwitch(switchHavegedStateOFF, switchHavegedStateON);
                    ArchiDroidBackendChangeSwitch(switchFrandomStateOFF, switchFrandomStateON);
                    ArchiDroidBackendChangeSwitch(switchAdblockStateOFF, switchAdblockStateON);
                    ArchiDroidBackendChangeSwitch(switchAdblockLocalDnsesStateOFF, switchAdblockLocalDnsesStateON);
                    ArchiDroidBackendChangeSwitch(switchAdblockForceLocalDnsesStateON, switchAdblockForceLocalDnsesStateOFF);
                    ArchiDroidBackendChangeSwitch(switchAdblockHostsStateMOAB, switchAdblockHostsStateADAWAY);
                    ArchiDroidBackendReload("ALL");
                    ArchiDroidReloadChoice();
                    break;
            }
        }
    }
}