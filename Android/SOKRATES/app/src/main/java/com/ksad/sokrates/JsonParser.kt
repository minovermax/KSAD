package com.example.sokrates

import com.google.gson.Gson
import java.net.URL

class JsonParser {
    fun jsonParser(url: String): Array<Response> {
        var response = URL(url).readText()
        var gson = Gson()

        val data = gson.fromJson(response, Array<Response>::class.java)

        return data
    }
}