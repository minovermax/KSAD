package com.example.sokrates

import android.content.Context
import android.net.ConnectivityManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.StrictMode
import android.util.TypedValue
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import kotlinx.android.synthetic.main.activity_main.view.*
import java.net.InetAddress

class MainActivity : AppCompatActivity() {

    internal lateinit var quoteText: TextView
    internal lateinit var authorText: TextView

    internal lateinit var inspiringButton: ImageButton
    internal lateinit var encouragingButton: ImageButton
    internal lateinit var motivatingButton: ImageButton

    internal var INSPIRING_URL = "http://ksad.000webhostapp.com/serviceInspiring.php"
    internal var ENCOURAGING_URL = "http://ksad.000webhostapp.com/serviceEncouraging.php"
    internal var MOTIVATING_URL = "http://ksad.000webhostapp.com/serviceMotivating.php"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // do not touch
        val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
        StrictMode.setThreadPolicy(policy)

        // initializing
        quoteText = findViewById(R.id.quoteText)
        authorText = findViewById(R.id.authorText)

        inspiringButton = findViewById(R.id.inspiringButton)
        encouragingButton = findViewById(R.id.encouragingButton)
        motivatingButton = findViewById(R.id.motivatingButton)


        // doing stuff with buttons
        inspiringButton.setOnClickListener { _ ->

            if (isInternetAvailable()) {
                setQuoteAndAuthor(INSPIRING_URL)
                quoteText.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30.0F)
            } else {
                noInternetAlert()
            }
        }

        encouragingButton.setOnClickListener{ _ ->

            if (isInternetAvailable()) {
                setQuoteAndAuthor(ENCOURAGING_URL)
                quoteText.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30.0F)
            } else {
                noInternetAlert()
            }
        }

        motivatingButton.setOnClickListener{ _ ->

            if (isInternetAvailable()) {
                setQuoteAndAuthor(MOTIVATING_URL)
                quoteText.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 30.0F)
            } else {
                noInternetAlert()
            }
        }
    }

    // mutator function
    fun setQuoteAndAuthor(urlCategory: String) {
        val data = JsonParser().jsonParser(urlCategory)
        var randValue = (0 until data.size).random()

        quoteText.text = "\"" + data[randValue].quote + "\""
        authorText.text = "- " + data[randValue].author
    }


    fun isInternetAvailable(): Boolean {
        try {
            val webAddress = InetAddress.getByName("google.com")
            return !webAddress.equals("")
        } catch (e: Exception) {
            return false
        }
    }

    fun noInternetAlert() {
        val noInternetConnection = AlertDialog.Builder(this@MainActivity)
        noInternetConnection.setTitle("No Internet!")
        noInternetConnection.setMessage("Please connect to the Internet to connect to our quote database!")
        noInternetConnection.setIcon(R.mipmap.ic_launcher)
        noInternetConnection.setPositiveButton("OKAY"){ dialog, _ ->
            dialog.dismiss()
        }
        noInternetConnection.show()
    }


}
