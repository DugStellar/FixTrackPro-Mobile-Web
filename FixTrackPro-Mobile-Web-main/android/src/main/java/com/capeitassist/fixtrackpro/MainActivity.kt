
package com.capeitassist.fixtrackpro

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.Executors

class MainActivity : AppCompatActivity() {

    private val executor = Executors.newSingleThreadExecutor()

    // For the Android emulator with XAMPP on your computer.
    private val apiUrl =
        "http://10.0.2.2/FixTrackPro-Mobile-Web/api/notifications.php"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btnRefresh = findViewById<Button>(R.id.btnRefresh)
        val txtStatus = findViewById<TextView>(
            R.id.txtNotificationStatus
        )

        btnRefresh.setOnClickListener {
            btnRefresh.isEnabled = false
            txtStatus.text = "Loading notifications..."

            executor.execute {
                val result = try {
                    fetchNotifications()
                } catch (e: Exception) {
                    "Unable to load notifications.\n\n" +
                        "Check that Apache and MySQL are running, " +
                        "the API URL is correct, and your computer " +
                        "is reachable from the emulator.\n\n" +
                        "Details: ${e.message ?: "Unknown error"}"
                }

                runOnUiThread {
                    txtStatus.text = result
                    btnRefresh.isEnabled = true
                }
            }
        }
    }

    private fun fetchNotifications(): String {
        val connection = URL(apiUrl)
            .openConnection() as HttpURLConnection

        try {
            connection.requestMethod = "GET"
            connection.connectTimeout = 10000
            connection.readTimeout = 10000

            val statusCode = connection.responseCode

            val stream = if (statusCode in 200..299) {
                connection.inputStream
            } else {
                connection.errorStream
            }

            val response = stream?.bufferedReader()
                ?.use { it.readText() }
                ?: throw Exception("The server returned no response.")

            if (statusCode !in 200..299) {
                throw Exception("Server returned HTTP $statusCode: $response")
            }

            val json = JSONObject(response)

            if (json.optString("status") != "success") {
                throw Exception(
                    json.optString(
                        "message",
                        "The API reported an error."
                    )
                )
            }

            val notifications = json.getJSONArray("notifications")

            if (notifications.length() == 0) {
                return "No notifications yet.\n\n" +
                    "New announcements will appear here."
            }

            val output = StringBuilder()
            output.append("Latest notifications\n\n")

            for (i in 0 until notifications.length()) {
                val item = notifications.getJSONObject(i)

                output.append(item.optString("title", "Untitled"))
                output.append("\n")

                output.append(
                    item.optString("message", "No message available.")
                )
                output.append("\n")

                output.append(
                    "Date: " +
                        item.optString("broadcast_date", "Not available")
                )
                output.append("\n\n--------------------\n\n")
            }

            return output.toString()

        } finally {
            connection.disconnect()
        }
    }

    override fun onDestroy() {
        executor.shutdownNow()
        super.onDestroy()
    }
}
