import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class CallBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        val i = Intent()
        i.setClassName("com.package.sample", "com.package.sample.MainActivity")
        i.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context?.startActivity(i)
    }
}
