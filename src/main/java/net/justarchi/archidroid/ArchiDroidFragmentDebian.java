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

class ArchiDroidFragmentDebian extends ArchiDroidFragmentCore {

    private void ArchiDroidReloadChoice() {
        allowReload = false;

        allowReload = true;
    }

    @Override
    public void onResume() {
        super.onResume();
        ArchiDroidReloadChoice();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        ArchiDroidReloadChoice();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.archidroid_fragment_debian, container, false);
    }

    private boolean allowReload = true;
    public class CustomOnCheckedChangeListener implements CompoundButton.OnCheckedChangeListener {

        @Override
        public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
            // We definitely want to apply only one value at once and because this listener will also wake up due to childs doing the same, we need to lock it
            // This will make sure that we won't override user choice (dev), because ARCHIDROID_INIT should keep an eye on that, not we
            if (allowReload) {
                switch (buttonView.getId()) {
                }
                ArchiDroidReloadChoice();
            }
        }
    }
    public class CustomOnClickListener implements View.OnClickListener {

        @Override
        public void onClick(View v) {
            switch (v.getId()) {
            }
        }
    }
}