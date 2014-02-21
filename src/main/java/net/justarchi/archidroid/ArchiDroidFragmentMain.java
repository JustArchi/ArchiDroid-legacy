package net.justarchi.archidroid;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;

public class ArchiDroidFragmentMain extends ArchiDroidFragmentCore {

    ImageButton buttonPaypal;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        buttonPaypal = (ImageButton) getView().findViewById(R.id.buttonPaypal);
        buttonPaypal.setOnClickListener(new CustomOnClickListener());
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
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.buttonPaypal:
                    Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=archipl33%40gmail%2ecom&lc=US&item_name=ArchiDroid&item_number=ArchiDroidApp&currency_code=USD"));
                    startActivity(browserIntent);
                    break;
            }
        }
    }
}