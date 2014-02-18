package net.justarchi.archidroid;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;

public class Fragment_Main extends ArchiDroidFragmentCore {

    Button b;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        b = (Button) getView().findViewById(R.id.buttonTest);
        b.setOnClickListener(new CustomOnClickListener());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View myFragmentView = inflater.inflate(R.layout.archidroid_fragment_main, container, false);
        return myFragmentView;
    }

    public class CustomOnClickListener implements OnClickListener {

        @Override
        public void onClick(View view) {
            Log.v("", "ArchiDroidRootExecuteWithOutput: "  + ArchiDroidRootExecuteWithOutput("pwd"));
        }
    }
}