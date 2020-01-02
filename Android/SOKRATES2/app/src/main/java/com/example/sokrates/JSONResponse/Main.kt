package com.example.sokrates.JSONResponse


import com.example.sokrates.Response
import java.net.URL
import com.google.gson.Gson


fun main() {


    var response = URL("http://ksad.000webhostapp.com/serviceMotivating.php").readText()
    var gson = Gson()

    val data = gson.fromJson(response, Array<Response>::class.java)

    println(data[0].quote)
    println(data[0].author)


}