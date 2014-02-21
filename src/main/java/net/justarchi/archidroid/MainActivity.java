package net.justarchi.archidroid;

import android.support.v4.app.FragmentActivity;
import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.AlarmManager;
import android.app.FragmentTransaction;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.Menu;

public class MainActivity extends FragmentActivity {

    private int pages = 3;

    private SectionsPagerAdapter mSectionsPagerAdapter;
    private ViewPager mViewPager;

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        return true;
    }

    public void restart(int delay) {
        PendingIntent intent = PendingIntent.getActivity(this.getBaseContext(), 0, new Intent(getIntent()), getIntent().getFlags());
        AlarmManager manager = (AlarmManager) this.getSystemService(Context.ALARM_SERVICE);
        manager.set(AlarmManager.RTC, System.currentTimeMillis() + delay, intent);
        System.exit(2);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.archidroid_main);
        mSectionsPagerAdapter = new SectionsPagerAdapter(getSupportFragmentManager());
        mViewPager = (ViewPager) findViewById(R.id.pager);
        mViewPager.setAdapter(mSectionsPagerAdapter);
        mViewPager.setOnPageChangeListener(new CustomOnPageChangeListener());

        ActionBar bar = getActionBar();
        bar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

        ActionBar.Tab Main = bar.newTab().setText(R.string.ArchiDroidMain);
        ActionBar.Tab Backend = bar.newTab().setText(R.string.ArchiDroidBackend);
        ActionBar.Tab Debian = bar.newTab().setText(R.string.ArchiDroidDebian);

        Main.setTabListener(new MyTabsListener());
        Backend.setTabListener(new MyTabsListener());
        Debian.setTabListener(new MyTabsListener());

        bar.addTab(Main);
        bar.addTab(Backend);
        bar.addTab(Debian);
    }

    public class SectionsPagerAdapter extends FragmentPagerAdapter {
        public SectionsPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public int getCount() {
            return pages;
        }

        @Override
        public Fragment getItem(int position) {
            Fragment fragment = null;
            switch (position) {
                case 0:
                    fragment = new ArchiDroidFragmentMain();
                    break;
                case 1:
                    fragment = new ArchiDroidFragmentBackend();
                    break;
                case 2:
                    fragment = new ArchiDroidFragmentDebian();
                    break;
            }
            return fragment;
        }
        @Override
        public CharSequence getPageTitle(int position) {
            return null;
        }
    }

    protected class CustomOnPageChangeListener implements ViewPager.OnPageChangeListener {

        @Override
        public void onPageScrolled(int arg0, float arg1, int arg2) {
        }

        @Override
        public void onPageScrollStateChanged(int arg0) {
        }

        @Override
        public void onPageSelected(int position) {
            ActionBar.Tab a = getActionBar().getTabAt(position);
            a.select();
        }
    }

    protected class MyTabsListener implements ActionBar.TabListener {

        @Override
        public void onTabReselected(Tab arg0, FragmentTransaction arg1) {
        }

        @Override
        public void onTabSelected(Tab tab, FragmentTransaction arg1) {
            int tabPos = tab.getPosition();
            if (mViewPager.getCurrentItem() != tabPos)
                mViewPager.setCurrentItem(tabPos);
        }

        @Override
        public void onTabUnselected(Tab tab, FragmentTransaction arg1) {
        }
    }
}