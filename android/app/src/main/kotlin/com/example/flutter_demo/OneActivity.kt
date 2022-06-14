package com.example.flutter_demo

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class OneActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.e("xxxx", "OneActivity")
        setContentView(R.layout.one_activity_layout)

        findViewById<Button>(R.id.btn_jump1)
            .setOnClickListener {
                val intent = Intent()
                intent.setClass(this,MainActivity::class.java)
                startActivity(intent)
            }
    }
}